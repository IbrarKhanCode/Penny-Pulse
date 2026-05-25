import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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

  dio.interceptors.add(
    InterceptorsWrapper(
      onRequest: (options, handler) async {
        debugPrint('[HTTP] ${options.method} ${options.uri}');
        try {
          final token = await ref.read(tokenStoreProvider).readToken();
          if (token != null && token.isNotEmpty) {
            options.headers[HttpHeaders.authorizationHeader] = 'Bearer $token';
            options.headers['X-Auth-Token'] = token;
          }
        } catch (e) {
          debugPrint('[HTTP] Error reading token from store: $e');
        }
        handler.next(options);
      },
    ),
  );

  return dio;
});
