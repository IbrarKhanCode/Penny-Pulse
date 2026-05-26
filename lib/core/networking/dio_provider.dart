import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/router.dart';
import '../../features/auth/data/token_store.dart';
import '../config/api_config.dart';

final dioProvider = Provider<Dio>((ref) {
  final config = ref.watch(apiConfigProvider);
  final baseUrl = config.baseUrl.endsWith('/')
      ? config.baseUrl.substring(0, config.baseUrl.length - 1)
      : config.baseUrl;
  final dio = Dio(
    BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 20),
      sendTimeout: const Duration(seconds: 10),
      headers: {
        HttpHeaders.acceptHeader: 'application/json',
        HttpHeaders.contentTypeHeader: 'application/json',
      },
    ),
  );

  // Lock to serialize refresh attempts for this Dio instance.
  Future<void>? _refreshFuture;

  dio.interceptors.add(
    InterceptorsWrapper(
      onRequest: (options, handler) async {
        debugPrint('[HTTP] ${options.method} ${options.uri}');
        try {
          final token = await ref.read(tokenStoreProvider).readAccessToken();
          if (token != null && token.isNotEmpty) {
            options.headers[HttpHeaders.authorizationHeader] = 'Bearer $token';
            options.headers['X-Auth-Token'] = token;
          }
        } catch (e) {
          debugPrint('[HTTP] Error reading token from store: $e');
        }
        handler.next(options);
      },
      onError: (err, handler) async {
        final status = err.response?.statusCode;
        if (status == 401) {
          final requestOptions = err.requestOptions;
          final requestPath = requestOptions.path;
          final isRefreshRequest = requestPath == '/refresh' || requestPath.endsWith('/refresh');

          if (requestOptions.extra['retry'] == true || isRefreshRequest) {
            await _forceLogout(ref);
            return handler.next(err);
          }

          final tokenStore = ref.read(tokenStoreProvider);
          final refreshToken = await tokenStore.readRefreshToken();
          if (refreshToken == null || refreshToken.isEmpty) {
            await _forceLogout(ref);
            return handler.next(err);
          }

          try {
            if (_refreshFuture == null) {
              _refreshFuture = (() async {
                final refreshDio = Dio(BaseOptions(baseUrl: dio.options.baseUrl));
                try {
                  final res = await refreshDio.post<Map<String, dynamic>>(
                    '/refresh',
                    data: jsonEncode({'refresh_token': refreshToken}),
                    options: Options(
                      headers: {
                        HttpHeaders.contentTypeHeader: 'application/json',
                        HttpHeaders.acceptHeader: 'application/json',
                      },
                      validateStatus: (status) => status != null && status < 600,
                    ),
                  );

                  if (res.statusCode == 200 && res.data != null) {
                    final newAccess = res.data!['access_token'] as String?;
                    final newRefresh = res.data!['refresh_token'] as String?;
                    if (newAccess != null && newAccess.isNotEmpty) {
                      await tokenStore.saveAccessToken(newAccess);
                      if (newRefresh != null && newRefresh.isNotEmpty) {
                        await tokenStore.saveRefreshToken(newRefresh);
                      }
                    } else {
                      await _forceLogout(ref);
                      throw DioException(requestOptions: res.requestOptions, response: res);
                    }
                  } else {
                    await _forceLogout(ref);
                    throw DioException(requestOptions: res.requestOptions, response: res);
                  }
                } catch (e) {
                  await _forceLogout(ref);
                  rethrow;
                } finally {
                  _refreshFuture = null;
                }
              })();
            }

            await _refreshFuture;

            final newToken = await tokenStore.readAccessToken();
            if (newToken == null || newToken.isEmpty) {
              await _forceLogout(ref);
              return handler.next(err);
            }

            requestOptions.headers[HttpHeaders.authorizationHeader] = 'Bearer $newToken';
            requestOptions.headers['X-Auth-Token'] = newToken;
            requestOptions.extra['retry'] = true;

            final response = await dio.fetch(requestOptions);
            return handler.resolve(response);
          } catch (e) {
            await _forceLogout(ref);
            return handler.next(err);
          }
        }
        handler.next(err);
      },
    ),
  );

  return dio;
});

Future<void> _forceLogout(Ref ref) async {
  final tokenStore = ref.read(tokenStoreProvider);
  await tokenStore.clearTokens();
  ref.read(routerProvider).go('/login');
}
