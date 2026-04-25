import 'package:dio/dio.dart';

/// Define the symbols that both platform-specific implementations must provide.
bool get isPlatformTest =>
    throw UnsupportedError('isPlatformTest not implemented');

void configurePlatformProxy(Dio dio) =>
    throw UnsupportedError('configurePlatformProxy not implemented');

String getPlatformBaseUrl(bool isTest) =>
    throw UnsupportedError('getPlatformBaseUrl not implemented');
