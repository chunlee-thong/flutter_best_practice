import 'package:flutter/material.dart';

class AppConstant {}

const Locale EN_LOCALE = Locale('en', 'US');
const Locale KH_LOCALE = Locale('km', 'KH');

class ErrorMessage {
  static const UNEXPECTED_ERROR = "An unexpected error occur!";
  static const UNEXPECTED_TYPE_ERROR = "An unexpected type error occur!";
  static const CONNECTION_ERROR = "Error connecting to server. Please check your internet connection or Try again later!";
  static const TIMEOUT_ERROR = "Connection timeout. Please check your internet connection or Try again later!";
}

class HttpMethod {
  HttpMethod._();

  static const String GET = "get";
  static const String POST = "post";
  static const String PATCH = "patch";
  static const String PUT = "put";
  static const String DELETE = "delete";
}
