import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/networking/dio_provider.dart';
import 'models/login_request.dart';
import 'models/login_response.dart';
import 'models/profile_response.dart';
import 'models/signup_request.dart';
import 'models/signup_response.dart';

class AuthApi {
  const AuthApi({required this.dio});

  final Dio dio;

  static const _ansiYellow = '\x1B[33m';
  static const _ansiReset = '\x1B[0m';

  void _log(String message) {
    debugPrint('$_ansiYellow[AuthApi] $message$_ansiReset');
  }

  String _maskToken(String token) {
    if (token.length <= 8) return token;
    return '${token.substring(0, 4)}...${token.substring(token.length - 4)}';
  }

  String _buildUrl(String path) {
    final baseUrl = dio.options.baseUrl.endsWith('/')
        ? dio.options.baseUrl.substring(0, dio.options.baseUrl.length - 1)
        : dio.options.baseUrl;
    final normalizedPath = path.startsWith('/') ? path : '/$path';
    return '$baseUrl$normalizedPath';
  }

  Future<SignupResponse> signup(SignupRequest request) async {
    _log('POST /signup payload: {email: ${request.email}, password: ***}');
    try {
      final res = await dio.post<Map<String, dynamic>>(
        '/signup',
        data: request.toJson(),
      );
      _log('POST /signup -> ${res.statusCode} ${res.data}');
      return SignupResponse.fromJson(res.data!);
    } on DioException catch (e) {
      _log('POST /signup error -> ${e.response?.statusCode} ${e.response?.data ?? e.message}');
      rethrow;
    }
  }

  Future<LoginResponse> login(LoginRequest request) async {
    final url = _buildUrl('/login');
    _log('Calling: $url');
    _log('POST /login payload: {email: ${request.email}, password: ***}');
    try {
      final res = await dio.post<Map<String, dynamic>>(
        '/login',
        data: jsonEncode(request.toJson()),
        options: Options(
          headers: {
            HttpHeaders.contentTypeHeader: 'application/json',
            HttpHeaders.acceptHeader: 'application/json',
          },
          validateStatus: (status) => status != null && status < 600,
        ),
      );
      final bodyText = res.data is String ? res.data as String : jsonEncode(res.data);
      final snippet = bodyText.length > 200 ? bodyText.substring(0, 200) : bodyText;
      _log('Status: ${res.statusCode}');
      _log('Body: $snippet');
      if (res.statusCode != 200) {
        throw Exception('Login failed: ${res.statusCode}');
      }
      return LoginResponse.fromJson(res.data!);
    } on DioException catch (e) {
      _log('POST /login error -> ${e.response?.statusCode} ${e.response?.data ?? e.message}');
      rethrow;
    }
  }

  Future<ProfileResponse> profile({required String token}) async {
    _log('GET /profile token: ${_maskToken(token)}');
    try {
      final res = await dio.get<Map<String, dynamic>>(
        '/profile',
        options: Options(
          headers: {
            HttpHeaders.authorizationHeader: 'Bearer $token',
          },
        ),
      );
      _log('GET /profile -> ${res.statusCode} ${res.data}');
      return ProfileResponse.fromJson(res.data!);
    } on DioException catch (e) {
      _log('GET /profile error -> ${e.response?.statusCode} ${e.response?.data ?? e.message}');
      rethrow;
    }
  }
}

final authApiProvider = Provider<AuthApi>((ref) {
  return AuthApi(dio: ref.watch(dioProvider));
});
