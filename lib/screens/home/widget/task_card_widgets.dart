import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:todo_design/config/app_asset.dart';
import 'package:todo_design/config/app_theme.dart';
import 'package:todo_design/extensions/ext_on_num.dart';
import 'package:todo_design/model/task.dart';

class TaskCard extends StatelessWidget {
  const TaskCard({
    super.key,
    required this.task,
    required this.onArchiveToggle,
    required this.onCheckedToggle,
    this.icon,
  });

  final Task task;
  final VoidCallback onArchiveToggle;
  final VoidCallback onCheckedToggle;
  final Widget? icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            blurStyle: BlurStyle.outer,
            color: AppColors.taskCardShadow,
            offset: const Offset(0, 1),
            blurRadius: 22,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Transform.scale(
                scale: 1.1,
                child: Checkbox(
                  value: task.isChecked,
                  side: BorderSide(
                    color: task.isChecked
                        ? AppColors.green
                        : AppColors.checkBoxBorder,
                    width: 2,
                  ),
                  fillColor: WidgetStatePropertyAll(
                    task.isChecked ? AppColors.green : null,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                  onChanged: (_) => onCheckedToggle(),
                ),
              ),
              8.width,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      task.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: task.isChecked
                          ? AppTextStyle.listTitle.copyWith(
                              decoration: TextDecoration.lineThrough,
                            )
                          : AppTextStyle.listTitle.copyWith(fontSize: 17),
                    ),
                    6.height,
                    Text(
                      task.description.isEmpty
                          ? 'No description added'
                          : task.description,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyle.listSubTitle.copyWith(
                        color: AppColors.textSecondary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              if (icon != null) ...[
                8.width,
                icon!,
              ],
              IconButton(
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                splashRadius: 20,
                onPressed: onArchiveToggle,
                icon: SvgPicture.asset(
                  AppIcons.closeIcon,
                  height: 16,
                ),
              ),
            ],
          ),
          14.height,
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              _Tag(
                label: task.priority.title,
                background: AppColors.primary.withOpacity(0.12),
                foreground: AppColors.primary,
              ),
              _Tag(
                label: task.isChecked ? 'Completed' : 'Pending',
                background: task.isChecked
                    ? AppColors.green.withOpacity(0.1)
                    : AppColors.appWhite,
                foreground:
                    task.isChecked ? AppColors.green : AppColors.textSecondary,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _Tag extends StatelessWidget {
  const _Tag({
    required this.label,
    required this.background,
    required this.foreground,
  });

  final String label;
  final Color background;
  final Color foreground;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: AppTextStyle.listSubTitle.copyWith(
          color: foreground,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
