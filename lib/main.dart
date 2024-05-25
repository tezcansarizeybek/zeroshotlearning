import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zeroshotmobile/routes/app_pages.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      theme: ThemeData(primaryColor: Colors.orange, useMaterial3: true),
      darkTheme: ThemeData.dark(useMaterial3: true),
      title: 'Zero Shot Learning',
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
    );
  }
}
