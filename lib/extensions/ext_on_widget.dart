import 'package:flutter/material.dart';
import 'package:todo_design/config/app_theme.dart';
import 'package:todo_design/screens/home/widget/app_loader.dart';

extension PaddingExtension on Widget {
  Widget get center => Center(child: this);
  Widget padding(EdgeInsets padding) {
    return Padding(
      padding: padding,
      child: this,
    );
  }

  Widget appLoading({bool isLoading = false, Color? color}) => Material(
        color: color ?? Colors.transparent,
        child: Stack(
          children: [
            this,
            if (isLoading) ...[
              Positioned.fill(
                child: Container(
                    color: AppColors.appWhite.withOpacity(0.9),
                    alignment: Alignment.center,
                    child: const AppLoader()),
              ),
            ],
          ],
        ),
      );
}
