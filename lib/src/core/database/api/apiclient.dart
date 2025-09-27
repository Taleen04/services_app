import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:trasport_ai/src/core/database/cache/shared_pref_helper.dart';
import 'package:trasport_ai/src/core/go_route/go_route.dart';
import 'package:trasport_ai/src/core/resources/api_constants.dart';

class ApiClient {
  static final Dio dio =
      Dio(
          BaseOptions(
            baseUrl: ApiConstants.baseUrl,
            // No timeout limits for large data
          ),
        )
        ..interceptors.add(
          InterceptorsWrapper(
            onRequest: (options, handler) async {
              final token = SharedPrefHelper.getString(StorageKeys.token);
              if (token.isNotEmpty) {
                log('from interceptor ----- $token');
                options.headers['Authorization'] = 'Bearer $token';
              }
              return handler.next(options);
            },
          ),
        )
        ..interceptors.add(
          PrettyDioLogger(
            requestHeader: true,
            requestBody: true,
            responseBody: true,
            responseHeader: false,
            error: true,
          ),
        );
}
