import 'package:flutter/material.dart';
import 'package:sura_flutter/sura_flutter.dart';

import '../../../constant/app_theme_color.dart';
import '../../../providers/theme_provider.dart';
import '../../../services/local_storage_service.dart';
import '../../pages/root_page/root_page.dart';
import '../../widgets/state_widgets/error_widget.dart';
import '../../widgets/state_widgets/loading_widget.dart';

class SplashScreenPage extends StatefulWidget {
  @override
  _SplashScreenPageState createState() => _SplashScreenPageState();
}

class _SplashScreenPageState extends State<SplashScreenPage> {
  FutureManager<bool> splashManager = FutureManager();

  Future<bool> onSplashing() async {
    await LocalStorage.initialize();
    ThemeProvider.getProvider(context).initializeTheme();
    await Future.delayed(const Duration(seconds: 1));
    PageNavigator.pushReplacement(context, RootPage());
    return true;
  }

  @override
  void initState() {
    splashManager.asyncOperation(() => onSplashing());
    super.initState();
  }

  @override
  void dispose() {
    splashManager.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.materialPrimary,
      body: FutureManagerBuilder<bool>(
        futureManager: splashManager,
        loading: const LoadingWidget(Colors.white),
        error: (error) {
          return OnErrorWidget(
            message: error,
            hasAppBar: true,
            onRefresh: () => onSplashing(),
          );
        },
        ready: (context, ready) => const LoadingWidget(Colors.white),
      ),
    );
  }
}
