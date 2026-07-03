import 'package:flutter/material.dart';
import 'package:todo_design/config/app_asset.dart';

class AppColors {
  static const Color primary = Color(0xFF2f58e2);
  static const Color textPrimary = Color(0xFF0A0D47);
  static const Color textSecondary = Color(0xFFA2A3B9);
  static const Color appWhite = Color(0xFFF5F7FA);
  static const Color green = Color.fromARGB(255, 24, 232, 1);
  static Color shadowColor = const Color(0xff2F58E2).withOpacity(0.22);
  // static const Color starColor = Color(0xffE8B923);
  static const Color white = Colors.white;
  static const Color checkBoxBorder = Color(0xffD7DBE6);
  static Color taskCardShadow = const Color(0xFFE0E3EB).withAlpha(150);
  // static const Color errorColor = Colors.red;
  static Color barrierColor = Colors.black.withAlpha(60);
}

class AppDecoration {}

class AppTextStyle {
  static const TextStyle headline = TextStyle(
    fontFamily: AppFonts.sourceSans,
    fontSize: 30,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
    decoration: TextDecoration.none,
  );

  static TextStyle medium = const TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    decoration: TextDecoration.none,
  );

  static TextStyle small = const TextStyle(
    fontFamily: AppFonts.sourceSans,
    fontSize: 18,
    color: AppColors.textPrimary,
    decoration: TextDecoration.none,
  );
  static TextStyle listTitle = const TextStyle(
    fontFamily: AppFonts.sourceSans,
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    decoration: TextDecoration.none,
  );
  static TextStyle listSubTitle = const TextStyle(
    fontFamily: AppFonts.sourceSans,
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: AppColors.textSecondary,
    decoration: TextDecoration.none,
  );
  static TextStyle textFieldStyle = const TextStyle(
    fontFamily: AppFonts.sourceSans,
    color: Colors.white,
    fontSize: 15,
    fontWeight: FontWeight.w700,
    decoration: TextDecoration.none,
  );
}
