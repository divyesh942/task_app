import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo_design/config/app_asset.dart';
import 'package:todo_design/config/app_theme.dart';
import 'package:todo_design/screens/home/controller/dashboard_controller.dart';
import 'package:todo_design/screens/home/view/dashboard_screen.dart';
import 'package:todo_design/services/preference.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Preferences.init();
  Get.put(DashboardController(), permanent: true);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Todo app',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: AppFonts.sourceSans,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primary,
        ),
        textTheme: TextTheme(
          bodyMedium: AppTextStyle.medium,
        ),
        useMaterial3: true,
      ),
      home: const MyDashBoard(),
    );
  }
}
