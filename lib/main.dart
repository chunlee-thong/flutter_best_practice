import 'dart:async';

import 'package:flutter/material.dart';

import 'app.dart';
import 'src/utils/logger.dart';
import 'src/utils/service_locator.dart';

void main() async {
  runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();
    registerLocator();
    runApp(MyApp());
  }, (exception, stackTrace) async {
    errorLog("RunZonedGuard error: ", exception);
  });
}
