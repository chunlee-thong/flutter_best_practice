import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_boiler_plate/src/services/cache_service.dart';

import '../../constant/app_constant.dart';
import '../../models/others/local_user_credential.dart';
import '../../utils/logger.dart';
import '../../utils/service_locator.dart';
import '../client/http_client.dart';
import '../client/http_exception.dart';

class BaseApiService {
  late final Dio dio;
  final IHttpCacheService? cacheService;
  BaseApiService({Dio? dio, this.cacheService}) {
    if (dio == null) {
      this.dio = BaseHttpClient.dio;
    } else {
      this.dio = dio;
    }
  }

  final String DATA_FIELD = "data";
  final String ERROR_MESSAGE_FIELD = "message";

  ///Create an Http request method that required path and a callback functions [onSuccess]
  ///default Http method is [GET]
  Future<T> onRequest<T>({
    required String path,
    required T Function(Response) onSuccess,
    String method = HttpMethod.GET,
    Map<String, dynamic>? query,
    Map<String, dynamic> headers = const {},
    dynamic data = const {},
    bool requiredToken = true,
    String? customToken,
    Dio? customDioClient,
  }) async {
    Response? response;
    try {
      final httpOption = Options(method: method, headers: {});
      if (requiredToken && getIt<LocalUserCredential>().hasValidToken()) {
        String token = getIt<LocalUserCredential>().jwtToken!;
        httpOption.headers!['Authorization'] = "bearer $token";
      }
      if (customToken != null) {
        httpOption.headers!['Authorization'] = "bearer $customToken";
      }
      httpOption.headers!.addAll(headers);
      String requestUrl = "${dio.options.baseUrl}" + path + constructQuery(query);

      if (cacheService != null && httpOption.method == HttpMethod.GET) {
        httpLog("Load data from cache: $requestUrl");
        Map<String, dynamic>? data = await cacheService!.loadCache(requestUrl);
        if (data != null) {
          httpLog("Cache has data");
          final response = Response(data: data, requestOptions: RequestOptions(path: requestUrl));
          return onSuccess(response);
        }
      }

      if (customDioClient != null) {
        response = await customDioClient.request(
          path,
          options: httpOption,
          queryParameters: query,
          data: data,
        );
      } else {
        response = await dio.request(
          path,
          options: httpOption,
          queryParameters: query,
          data: data,
        );
      }

      ///This condition may be depend on Response and your API
      //return onSuccess(response);
      if (response.data['status'] == true) {
        if (cacheService != null && httpOption.method == HttpMethod.GET) {
          await cacheService!.saveCache(requestUrl, response.data);
        }
        return onSuccess(response);
      } else {
        throw ServerResponseException(response.data['message']);
      }
    } on DioError catch (exception) {
      throw _onDioError(exception);
    } on ServerResponseException catch (exception) {
      throw _onServerResponseException(exception, response!);
    } catch (exception) {
      throw _onTypeError(exception);
    }
  }
}

String _onTypeError(dynamic exception) {
  errorLog(exception);
  //Logic or syntax error on some condition
  //errorLog("Type Error :=> ${exception.toString()}\nStackTrace:  ${exception.stackTrace.toString()}");
  return ErrorMessage.UNEXPECTED_TYPE_ERROR;
}

String constructQuery(Map<String, dynamic>? query) {
  if (query == null) return "";
  String queryString = "?";
  query.forEach((key, value) {
    queryString += "$key=$value&";
  });
  return queryString;
}

DioErrorException _onDioError(DioError exception) {
  _logDioError(exception);
  if (exception.error is SocketException) {
    return DioErrorException(ErrorMessage.CONNECTION_ERROR);
  }

  switch (exception.type) {
    case DioErrorType.connectTimeout:
      return DioErrorException(ErrorMessage.TIMEOUT_ERROR);
    case DioErrorType.response:
      String serverMessage;
      if (exception.response!.data is Map) {
        serverMessage = exception.response?.data["message"] ?? ErrorMessage.UNEXPECTED_ERROR;
      } else {
        serverMessage = ErrorMessage.UNEXPECTED_ERROR;
      }
      return DioErrorException(serverMessage, code: exception.response!.statusCode);
    default:
      return DioErrorException(ErrorMessage.UNEXPECTED_ERROR);
  }
}

void _logDioError(DioError exception) {
  String errorMessage = "Dio error :=> ${exception.requestOptions.path}";
  if (exception.response != null) {
    errorMessage += ", Response: => ${exception.response!.data.toString()}";
  } else {
    errorMessage += ", ${exception.message}";
  }
  httpLog(errorMessage);
}

ServerResponseException _onServerResponseException(dynamic exception, Response response) {
  httpLog("Server error :=> ${response.requestOptions.path}:=> $exception");
  return ServerResponseException(exception.toString());
}
