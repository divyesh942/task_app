import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo_design/config/app_asset.dart';
import 'package:todo_design/config/app_string.dart';
import 'package:todo_design/model/task.dart';
import 'package:todo_design/screens/home/controller/dashboard_controller.dart';
import 'package:todo_design/screens/home/widget/empty_task.dart';
import 'package:todo_design/screens/home/widget/task_collection_view.dart';
import 'package:todo_design/screens/home/widget/task_dialog_widget.dart';

class IncompleteTaskWidget extends StatelessWidget {
  const IncompleteTaskWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final DashboardController controller = Get.find<DashboardController>();

    return Obx(() {
      final List<Task> uncheckedTasks = controller.incompleteTasks;

      if (uncheckedTasks.isEmpty) {
        return const EmptyTask(
          image: AppImages.taskInCompleteImage,
          title: AppString.allClear,
          description: AppString.completedAllTask,
        );
      }

      return TaskCollectionView(
        tasks: uncheckedTasks,
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
