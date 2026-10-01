import 'package:dio/dio.dart';

import '../constants/api_constants.dart';
import 'api_exception.dart';

class ApiClient {
  ApiClient({Dio? dio})
      : _dio = dio ??
      Dio(
        BaseOptions(
          baseUrl: ApiConstants.baseUrl,
          connectTimeout: ApiConstants.connectTimeout,
          receiveTimeout: ApiConstants.receiveTimeout,
          headers: const {'Accept': 'application/json'},
        ),
      );

  final Dio _dio;

  Future<T> get<T>(
      String path, {
        Map<String, dynamic>? queryParameters,
        CancelToken? cancelToken,
      }) async {
    try {
      final response = await _dio.get<T>(
        path,
        queryParameters: queryParameters,
        cancelToken: cancelToken,
      );
      final data = response.data;
      if (data == null) throw const ApiException.parsing();
      return data;
    } on DioException catch (error) {
      throw ApiException.fromDio(error);
    }
  }
}