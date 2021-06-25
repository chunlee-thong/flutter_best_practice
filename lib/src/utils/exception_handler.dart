import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../ui/widgets/ui_helper.dart';
import 'custom_exception.dart';

///a function that use globally for try catch the exception, so you can easily send a report or
///do run some function on some exception
///Return null if there is an exception
Future<T?> ExceptionWatcher<T>(
  ///context can be null
  BuildContext? context,
  FutureOr<T> Function() function, {
  VoidCallback? onDone,
  void Function(dynamic)? onError,
}) async {
  try {
    return await function();
  } on UserCancelException catch (_) {
    return null;
  } catch (exception, stackTrace) {
    String? message = "";
    if (exception is SessionExpiredException) {
      if (context != null) {
        UIHelper.showToast(context, exception.toString());
      }
    } else if (exception is PlatformException) {
      message = exception.message;
    } else if (exception is TypeError) {
      message = exception.toString();
    } else {
      message = exception.toString();
    }
    if (context != null) {
      UIHelper.showErrorDialog(context, message);
    }
    onError?.call(exception);
    return null;
  } finally {
    onDone?.call();
  }
}

void handleManagerError(dynamic exception, BuildContext context) {
  if (exception is SessionExpiredException) {
    UIHelper.showToast(context, exception.toString());
  }
}
