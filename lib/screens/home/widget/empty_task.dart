import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:todo_design/config/app_theme.dart';
import 'package:todo_design/extensions/ext_on_num.dart';
import 'package:todo_design/extensions/ext_on_widget.dart';

class EmptyTask extends StatelessWidget {
  final String image;
  final String title;
  final String description;
  final double? imageHeight;

  // Constructor
  const EmptyTask({
    super.key,
    required this.image,
    required this.title,
    required this.description,
    this.imageHeight,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Spacer(),
        Column(children: [
          SvgPicture.asset(image, height: imageHeight ?? 220),
          15.height,
          Text(
            title,
            style: AppTextStyle.small.copyWith(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: AppColors.primary),
          ),
          15.height,
          Text(
            textAlign: TextAlign.center,
            description,
            style: AppTextStyle.small.copyWith(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColors.textSecondary,
            ),
          ),
          30.height,
        ]),
        const Spacer(),
        const Spacer(),
      ],
    ).padding(
      const EdgeInsets.only(top: 30),
    );
  }
}
