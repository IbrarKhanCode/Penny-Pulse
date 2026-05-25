import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/errors/app_exception.dart';
import 'auth_api.dart';
import 'auth_repository.dart';
import 'models/auth_user.dart';
import 'models/login_request.dart';
import 'models/profile_response.dart';
import 'models/signup_request.dart';
import 'models/signup_response.dart';
import 'token_store.dart';

class AuthRepositoryImpl implements AuthRepository {
  const AuthRepositoryImpl(this._api, this._tokenStore);

  final AuthApi _api;
  final TokenStore _tokenStore;

  @override
  Future<SignupResponse> signup({
    required String email,
    required String password,
  }) async {
    try {
      return await _api.signup(SignupRequest(email: email, password: password));
    } on DioException catch (e) {
      throw _mapDioError(e);
    }
  }

  @override
  Future<AuthUser> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _api.login(
        LoginRequest(email: email, password: password),
      );
      await _tokenStore.saveToken(response.accessToken);
      return response.user;
    } on DioException catch (e) {
      throw _mapDioError(e);
    }
  }

  @override
  Future<ProfileResponse> profile() async {
    final token = await _tokenStore.readToken();
    if (token == null || token.isEmpty) {
      throw const AppException(message: 'Please log in again.');
    }

    try {
      return await _api.profile(token: token);
    } on DioException catch (e) {
      throw _mapDioError(e);
    }
  }

  @override
  Future<void> logout() async {
    final token = await _tokenStore.readToken();
    if (token != null && token.isNotEmpty) {
      try {
        await _api.logout(token: token);
      } on DioException {
        // Best-effort revoke; still clear local token.
      }
    }
    await _tokenStore.clearToken();
  }

  AppException _mapDioError(DioException e) {
    final statusCode = e.response?.statusCode;
    final detail = e.response?.data is Map
        ? (e.response!.data as Map)['detail']?.toString()
        : null;
    final message = detail ?? e.message ?? 'An unexpected error occurred';
    return AppException(message: message, statusCode: statusCode);
  }
}

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepositoryImpl(
    ref.watch(authApiProvider),
    ref.watch(tokenStoreProvider),
  );
});
