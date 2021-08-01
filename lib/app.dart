import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sura_flutter/sura_flutter.dart';

import 'src/api/client/http_client.dart';
import 'src/constant/app_config.dart';
import 'src/constant/app_theme_color.dart';
import 'src/providers/loading_provider.dart';
import 'src/providers/theme_provider.dart';
import 'src/pages/splash/splash_page.dart';
import 'src/widgets/state_widgets/error_widget.dart';
import 'src/widgets/state_widgets/loading_widget.dart';
import 'src/widgets/state_widgets/page_loading.dart';

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    BaseHttpClient.init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => LoadingProvider()),
      ],
      child: Builder(
        builder: (context) => Consumer<ThemeProvider>(
          builder: (context, themeProvider, child) {
            return SuraProvider(
              loadingWidget: const LoadingWidget(),
              errorWidget: (error, onRefresh) {
                return OnErrorWidget(
                  message: error,
                  onRefresh: onRefresh,
                );
              },
              child: MaterialApp(
                title: AppConfig.APP_NAME,
                navigatorKey: SuraNavigator.navigatorKey,
                theme: themeProvider.isDarkTheme ? kDarkTheme : kLightTheme,
                debugShowCheckedModeBanner: false,
                builder: (context, child) {
                  ErrorWidget.builder = (detail) {
                    if (kReleaseMode) return FlutterCustomErrorRendering();
                    return ErrorWidget(detail.exception);
                  };
                  return PageLoading(child: child!);
                },
                home: SplashScreenPage(),
              ),
            );
          },
        ),
      ),
    );
  }
}
