import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo_design/config/app_asset.dart';
import 'package:todo_design/config/app_string.dart';
import 'package:todo_design/screens/home/controller/dashboard_controller.dart';
import 'package:todo_design/screens/home/widget/empty_task.dart';
import 'package:todo_design/screens/home/widget/task_collection_view.dart';
import 'package:todo_design/screens/home/widget/task_dialog_widget.dart';

class AllTask extends StatelessWidget {
  const AllTask({super.key});

  @override
  Widget build(BuildContext context) {
    final DashboardController controller = Get.find<DashboardController>();

    return Obx(() {
      final allTasks = controller.activeTasks;

      if (allTasks.isEmpty) {
        return const EmptyTask(
          image: AppImages.taskAllImage,
          title: AppString.addTask,
          description: AppString.emptyTask,
        );
      }

      return TaskCollectionView(
        tasks: allTasks,
        onTapTask: (task) => showTaskDialog(
          context,
          task: task,
          onSubmit: controller.updateTask,
        ),
        onArchiveToggle: controller.toggleArchive,
        onCheckedToggle: controller.toggleChecked,
      );
    });
  }
}
