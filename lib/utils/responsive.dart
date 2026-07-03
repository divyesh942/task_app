import 'package:flutter/material.dart';

class AppDimensions {
  const AppDimensions._(this.width);

  final double width;

  static AppDimensions of(BuildContext context) {
    return AppDimensions._(MediaQuery.sizeOf(context).width);
  }

  bool get isMobile => width < 700;
  bool get isTablet => width >= 700 && width < 1100;
  bool get isDesktop => width >= 1100;
  bool get showsSidebar => width >= 1000;
  int get taskGridCount => isDesktop
      ? 3
      : isTablet
          ? 2
          : 1;

  EdgeInsets get pagePadding {
    if (isDesktop) {
      return const EdgeInsets.symmetric(horizontal: 32, vertical: 24);
    }
    if (isTablet) {
      return const EdgeInsets.symmetric(horizontal: 24, vertical: 20);
    }
    return const EdgeInsets.symmetric(horizontal: 16, vertical: 16);
  }
}
