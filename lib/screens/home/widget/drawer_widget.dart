import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:todo_design/config/app_asset.dart';
import 'package:todo_design/config/app_string.dart';
import 'package:todo_design/config/app_theme.dart';
import 'package:todo_design/extensions/ext_on_num.dart';
import 'package:todo_design/screens/home/view/archive_screen.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key, this.embedded = false});

  final bool embedded;

  @override
  Widget build(BuildContext context) {
    final content = Container(
      color: AppColors.primary,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.16),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppString.heading,
                      style: AppTextStyle.headline.copyWith(
                        color: AppColors.white,
                        fontSize: 28,
                      ),
                    ),
                    8.height,
                    Text(
                      AppString.taskSummary,
                      style: AppTextStyle.listSubTitle.copyWith(
                        color: AppColors.white.withOpacity(0.72),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              24.height,
              Divider(
                color: AppColors.white.withAlpha(170),
                thickness: 2,
              ),
              18.height,
              navigationMenu(
                context: context,
                icon: AppIcons.homeIcon,
                name: AppString.home,
                onTap: () {
                  if (!embedded) {
                    Get.back();
                  }
                },
              ),
              10.height,
              navigationMenu(
                context: context,
                icon: AppIcons.deleteIcon,
                name: AppString.archive,
                onTap: () {
                  if (!embedded) {
                    Get.back();
                  }
                  Get.to(() => ArchiveScreen());
                },
              ),
            ],
          ),
        ),
      ),
    );

    if (embedded) {
      return content;
    }

    return Drawer(
      shadowColor: Colors.black,
      elevation: 80,
      width: 320,
      backgroundColor: AppColors.primary,
      child: content,
    );
  }
}

Widget navigationMenu({
  required BuildContext context,
  required String icon,
  required String name,
  final VoidCallback? onTap,
}) {
  return InkWell(
    onTap: onTap,
    borderRadius: BorderRadius.circular(12),
    child: Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.white.withOpacity(0.08),
      ),
      child: Row(
        children: [
          SizedBox(
            height: 22,
            width: 22,
            child: SvgPicture.asset(icon),
          ),
          12.width,
          Expanded(
            child: Text(
              name,
              style: AppTextStyle.small.copyWith(
                color: AppColors.white,
                fontWeight: FontWeight.w700,
                fontSize: 18,
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
