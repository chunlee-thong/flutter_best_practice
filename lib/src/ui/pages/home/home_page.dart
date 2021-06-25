import 'package:flutter/material.dart';

import '../../../constant/app_config.dart';
import '../../../providers/theme_provider.dart';
import '../../widgets/ui_helper.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: UIHelper.CustomAppBar(title: AppConfig.APP_NAME),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [],
        ),
      ),
      floatingActionButton: ElevatedButton(
        onPressed: () {
          ThemeProvider.getProvider(context).switchTheme();
        },
        child: Text("Switch Theme"),
      ),
    );
  }
}
