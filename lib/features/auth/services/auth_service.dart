import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/services/api_client.dart';
import '../../../core/services/storage_service.dart';

import '../../profile/services/user_profile_service.dart';

class AuthState {
  final bool isAuthenticated;
  final bool isLoading;
  final String? error;
  final UserProfile? user;

  AuthState({
    this.isAuthenticated = false,
    this.isLoading = false,
    this.error,
    this.user,
  });
}

class AuthNotifier extends StateNotifier<AuthState> {
  final Ref _ref;

  AuthNotifier(this._ref) : super(AuthState()) {
    _loadSession();
  }

  Future<void> _loadSession() async {
    final token = await _ref.read(storageServiceProvider).getToken();
    if (token != null) {
      state = AuthState(isAuthenticated: true);
    }
  }

  Future<void> login(String email, String password) async {
    state = AuthState(isLoading: true);
    
    try {
      final response = await _ref.read(apiClientProvider).dio.post(
        'auth/login',
        data: {
          'email': email,
          'password': password,
        },
      );

      final token = response.data['access_token'];
      final userData = response.data['user'];
      
      if (token != null && userData != null) {
        await _ref.read(storageServiceProvider).saveToken(token);
        state = AuthState(
          isAuthenticated: true,
          user: UserProfile.fromJson(userData),
        );
      } else {
        state = AuthState(error: "authErrorUnknown");
      }
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout || e.type == DioExceptionType.receiveTimeout) {
        state = AuthState(error: "authErrorNoConnection");
      } else if (e.response?.statusCode == 401) {
        state = AuthState(error: "authErrorInvalid");
      } else {
        state = AuthState(error: "authErrorUnknown");
      }
    } catch (e) {
      state = AuthState(error: "authErrorUnknown");
    }
  }

  Future<void> register(String name, String email, String password, String phone) async {
    state = AuthState(isLoading: true);
    
    // Split name into first and last name for backend compatibility
    final nameParts = name.trim().split(' ');
    final firstName = nameParts.first;
    final lastName = nameParts.length > 1 ? nameParts.sublist(1).join(' ') : '';

    try {
      final response = await _ref.read(apiClientProvider).dio.post(
        '/auth/register',
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
        // Auto-login after successful registration
        await login(email, password);
      } else {
        state = AuthState(error: "Registration failed with status: ${response.statusCode}");
      }
    } on DioException catch (e) {
      final dynamic serverMessage = e.response?.data?['message'];
      String errorMessage = "Registration failed";
      
      if (e.response?.statusCode == 409) {
        errorMessage = "Email already exists";
      } else if (serverMessage is List) {
        errorMessage = serverMessage.join(', ');
      } else if (serverMessage is String) {
        errorMessage = serverMessage;
      } else if (e.type == DioExceptionType.connectionTimeout) {
        errorMessage = "Connection timeout: Server might be offline";
      } else if (e.type == DioExceptionType.connectionError) {
        errorMessage = "Connection error: Check if the backend is running";
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
}

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier(ref);
});
