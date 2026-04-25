import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ebzim_app/core/services/api_client.dart';
import 'package:ebzim_app/core/services/storage_service.dart';

import 'package:ebzim_app/core/services/user_profile_service.dart';
export 'package:ebzim_app/core/models/user_profile.dart';

class AuthState {
  final bool isAuthenticated;
  final bool isLoading;
  final bool isInitializing; // New flag for boot/refresh
  final bool isEmailVerificationRequired;
  final String? emailForVerification;
  final String? error;
  final UserProfile? user;

  AuthState({
    this.isAuthenticated = false,
    this.isLoading = false,
    this.isInitializing = false, // Defaults to false after boot
    this.isEmailVerificationRequired = false,
    this.emailForVerification,
    this.error,
    this.user,
  });
}

class AuthNotifier extends StateNotifier<AuthState> {
  final Ref _ref;

  AuthNotifier(this._ref) : super(AuthState(isInitializing: true)) {
    _loadSession();
  }

  Future<void> _loadSession() async {
    print('[DEBUG AUTH] _loadSession started');
    try {
      final token = await _ref.read(storageServiceProvider).getToken();
      print('[DEBUG AUTH] Token found: ${token != null}');
      if (token != null) {
        print('[DEBUG AUTH] Fetching user profile...');
        try {
          final user = await _ref
              .read(userProfileServiceProvider)
              .fetchUserProfile();
          // Guard: If state was changed (e.g. logout) while waiting, don't overwrite
          if (!state.isInitializing) return;

          print('[DEBUG AUTH] User profile fetched: ${user.getName('en')}');
          state = AuthState(
            isAuthenticated: true,
            user: user,
            isInitializing: false,
          );
        } catch (e) {
          print(
            '[DEBUG AUTH] Error fetching profile, likely invalid token: $e',
          );
          await _ref.read(storageServiceProvider).deleteToken();
          state = AuthState(isInitializing: false);
        }
      } else {
        print('[DEBUG AUTH] No token, setting initializing to false');
        state = AuthState(isInitializing: false);
      }
    } catch (e) {
      print('[DEBUG AUTH] Critical error in _loadSession: $e');
      state = AuthState(isInitializing: false);
    }
  }

  Future<void> login(String email, String password) async {
    state = AuthState(isLoading: true);
    final baseUrl = _ref.read(apiClientProvider).dio.options.baseUrl;
    print('[DEBUG AUTH] Attempting login...');
    print('  URL: ${baseUrl}auth/login');
    print('  Identity: $email');

    try {
      final response = await _ref
          .read(apiClientProvider)
          .dio
          .post('auth/login', data: {'email': email, 'password': password});

      print('[DEBUG AUTH] Login Success! Status: ${response.statusCode}');
      final token = response.data['access_token'];
      final userData = response.data['user'];

      if (token != null && userData != null) {
        await _ref.read(storageServiceProvider).saveToken(token);
        await _ref.read(storageServiceProvider).saveLastIdentity(email);
        state = AuthState(
          isAuthenticated: true,
          user: UserProfile.fromJson(userData),
        );
        print('[DEBUG AUTH] Session preserved and user profile loaded.');
      } else {
        print('[DEBUG AUTH] Login response missing token or user data.');
        state = AuthState(error: "authErrorUnknown");
      }
    } on DioException catch (e) {
      print('[DEBUG AUTH] DioException in login:');
      print('  Type: ${e.type}');
      print('  Message: ${e.message}');
      print('  Status Code: ${e.response?.statusCode}');
      print('  Server Data: ${e.response?.data}');

      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout ||
          e.type == DioExceptionType.connectionError) {
        state = AuthState(error: "authErrorNoConnection");
      } else if (e.response?.statusCode == 400 ||
          e.response?.statusCode == 401 ||
          e.response?.statusCode == 404 ||
          e.response?.statusCode == 403) {
        // Handle 400 (Bad Request) as invalid credentials because validation failure often means wrong format/user
        state = AuthState(error: "authErrorInvalid");
      } else {
        print('[DEBUG AUTH] Unhandled Status Code: ${e.response?.statusCode}');
        state = AuthState(
          error: "Error ${e.response?.statusCode}: ${e.message}",
        );
      }
    } catch (e) {
      print('[DEBUG AUTH] Unexpected error during login: $e');
      state = AuthState(error: "authErrorUnknown");
    }
  }

  Future<void> register(
    String name,
    String email,
    String password,
    String phone,
  ) async {
    state = AuthState(isLoading: true);

    // Split name into first and last name for backend compatibility
    final trimmedName = name.trim();
    final nameParts = trimmedName.isNotEmpty
        ? trimmedName.split(' ')
        : ['User'];
    final firstName = nameParts.first;
    final lastName = nameParts.length > 1 ? nameParts.sublist(1).join(' ') : '';

    try {
      final response = await _ref
          .read(apiClientProvider)
          .dio
          .post(
            'auth/register',
            data: {
              'email': email,
              'password': password,
              'profile': {
                'firstName': firstName,
                'lastName': lastName,
                'phone': phone,
              },
            },
          );

      if (response.statusCode == 201 || response.statusCode == 200) {
        if (response.data != null &&
            response.data['isVerificationRequired'] == true) {
          state = AuthState(
            isEmailVerificationRequired: true,
            emailForVerification: email,
            isInitializing: false,
          );
        } else {
          // Auto-login after successful registration if verification not required
          await login(email, password);
        }
      } else {
        state = AuthState(
          error: "Registration failed with status: ${response.statusCode}",
          isInitializing: false,
        );
      }
    } on DioException catch (e) {
      final dynamic serverData = e.response?.data;
      final dynamic serverMessage = serverData is Map
          ? serverData['message']
          : null;
      String errorMessage = "Registration failed";

      if (e.response?.statusCode == 409) {
        errorMessage = "authErrorConflict";
      } else if (serverMessage is List) {
        errorMessage = serverMessage.join(', ');
      } else if (serverMessage is String) {
        errorMessage = serverMessage;
      } else if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.connectionError) {
        errorMessage = "authErrorNoConnection";
      } else if (serverData is Map && serverData['error'] != null) {
        errorMessage = serverData['error'].toString();
      }

      state = AuthState(error: errorMessage);
    } catch (e) {
      state = AuthState(error: e.toString());
    }
  }

  Future<void> logout() async {
    await _ref.read(storageServiceProvider).deleteToken();
    state = AuthState();
  }

  Future<void> forgotPassword(String email) async {
    state = AuthState(isLoading: true);
    try {
      await _ref
          .read(apiClientProvider)
          .dio
          .post('auth/forgot-password', data: {'email': email});
      state = AuthState(); // Reset loading but keep session info empty
    } catch (e) {
      state = AuthState(error: e.toString());
    }
  }

  Future<void> resetPassword(String token, String newPassword) async {
    state = AuthState(isLoading: true, isInitializing: false);
    try {
      await _ref
          .read(apiClientProvider)
          .dio
          .post(
            'auth/reset-password',
            data: {'token': token, 'password': newPassword},
          );
      state = AuthState(isInitializing: false); // Reset loading
    } catch (e) {
      state = AuthState(error: e.toString(), isInitializing: false);
    }
  }

  Future<void> verifyEmail(String email, String token) async {
    state = AuthState(
      isLoading: true,
      isEmailVerificationRequired: true,
      emailForVerification: email,
      isInitializing: false,
    );
    try {
      await _ref
          .read(apiClientProvider)
          .dio
          .post('auth/verify-email', data: {'email': email, 'token': token});
      state = AuthState(
        isInitializing: false,
      ); // Success, verification no longer required
    } on DioException catch (e) {
      final dynamic serverData = e.response?.data;
      final errorMessage = serverData is Map
          ? serverData['message']
          : e.toString();
      state = AuthState(
        error: errorMessage,
        isEmailVerificationRequired: true,
        emailForVerification: email,
        isInitializing: false,
      );
    } catch (e) {
      state = AuthState(
        error: e.toString(),
        isEmailVerificationRequired: true,
        emailForVerification: email,
        isInitializing: false,
      );
    }
  }

  Future<void> updateProfile(Map<String, dynamic> profileData) async {
    final currentUser = state.user;
    state = AuthState(
      isAuthenticated: state.isAuthenticated,
      user: currentUser,
      isLoading: true,
      isInitializing: state.isInitializing,
    );
    try {
      final updatedUser = await _ref
          .read(userProfileServiceProvider)
          .updateProfile(profileData);
      state = AuthState(
        isAuthenticated: true,
        user: updatedUser,
        isLoading: false,
      );
    } catch (e) {
      state = AuthState(
        isAuthenticated: state.isAuthenticated,
        user: currentUser,
        error: e.toString(),
        isLoading: false,
      );
      rethrow;
    }
  }

  Future<void> uploadAvatar(List<int> bytes, String fileName) async {
    final currentUser = state.user;
    state = AuthState(
      isAuthenticated: state.isAuthenticated,
      user: currentUser,
      isLoading: true,
      isInitializing: state.isInitializing,
    );
    try {
      final updatedUser = await _ref
          .read(userProfileServiceProvider)
          .uploadAvatar(bytes, fileName, _ref);
      state = AuthState(
        isAuthenticated: true,
        user: updatedUser,
        isLoading: false,
      );
    } catch (e) {
      state = AuthState(
        isAuthenticated: state.isAuthenticated,
        user: currentUser,
        error: e.toString(),
        isLoading: false,
      );
      rethrow;
    }
  }
}

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier(ref);
});
