import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:todo_design/config/app_asset.dart';
import 'package:todo_design/config/app_string.dart';
import 'package:todo_design/config/app_theme.dart';
import 'package:todo_design/screens/home/controller/dashboard_controller.dart';
import 'package:todo_design/screens/home/widget/empty_task.dart';
import 'package:todo_design/screens/home/widget/task_collection_view.dart';
import 'package:todo_design/utils/responsive.dart';

class ArchiveScreen extends StatelessWidget {
  ArchiveScreen({super.key});

  final dashboardController = Get.find<DashboardController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.appWhite,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        iconTheme: const IconThemeData(color: AppColors.white),
        title: Text(
          AppString.archive,
          style: AppTextStyle.headline.copyWith(
            color: AppColors.white,
            fontSize: 24,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Container(
        
        child: Obx(() {
          final tasks = dashboardController.archiveTasks;

          if (tasks.isEmpty) {
            return const Center(
              child: EmptyTask(
                image: AppImages.taskAllImage,
                title: '',
                description: AppString.emptyArchiveTask,
                imageHeight: 240,
              ),
            );
          }

          return ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: AppDimensions.of(context).isDesktop
                  ? 1180
                  : double.infinity,
            ),
            child: TaskCollectionView(
              tasks: tasks,
              onArchiveToggle: dashboardController.deleteFromArchive,
              onCheckedToggle: (_) {},
              trailingBuilder: (task) => IconButton(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                constraints: const BoxConstraints(),
                onPressed: () => dashboardController.unarchiveTask(task),
                icon: SvgPicture.asset(
                  AppIcons.restoreIcon,
                  height: 17,
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
