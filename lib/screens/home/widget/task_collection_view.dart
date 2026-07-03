import 'package:flutter/material.dart';
import 'package:todo_design/model/task.dart';
import 'package:todo_design/screens/home/widget/task_card_widgets.dart';
import 'package:todo_design/utils/responsive.dart';

class TaskCollectionView extends StatelessWidget {
  const TaskCollectionView({
    super.key,
    required this.tasks,
    required this.onArchiveToggle,
    required this.onCheckedToggle,
    this.onTapTask,
    this.trailingBuilder,
    this.bottomPadding = 96,
  });

  final List<Task> tasks;
  final void Function(Task task) onArchiveToggle;
  final void Function(Task task) onCheckedToggle;
  final void Function(Task task)? onTapTask;
  final Widget? Function(Task task)? trailingBuilder;
  final double bottomPadding;

  @override
  Widget build(BuildContext context) {
    final responsive = AppDimensions.of(context);
    final horizontalPadding = responsive.isMobile ? 12.0 : 16.0;

    if (responsive.taskGridCount == 1) {
      return ListView.separated(
        itemCount: tasks.length,
        padding: EdgeInsets.fromLTRB(
          horizontalPadding,
          14,
          horizontalPadding,
          bottomPadding,
        ),
        separatorBuilder: (_, __) => const SizedBox(height: 16),
        itemBuilder: (_, index) => _TaskTile(
          task: tasks[index],
          onTap: onTapTask,
          onArchiveToggle: onArchiveToggle,
          onCheckedToggle: onCheckedToggle,
          trailingBuilder: trailingBuilder,
        ),
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        const spacing = 18.0;
        final availableWidth = constraints.maxWidth - (horizontalPadding * 2);
        final itemWidth =
            (availableWidth - (spacing * (responsive.taskGridCount - 1))) /
                responsive.taskGridCount;

        return SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(
            horizontalPadding,
            14,
            horizontalPadding,
            bottomPadding,
          ),
          child: Wrap(
            spacing: spacing,
            runSpacing: spacing,
            children: [
              for (final task in tasks)
                SizedBox(
                  width: itemWidth,
                  child: _TaskTile(
                    task: task,
                    onTap: onTapTask,
                    onArchiveToggle: onArchiveToggle,
                    onCheckedToggle: onCheckedToggle,
                    trailingBuilder: trailingBuilder,
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}

class _TaskTile extends StatefulWidget {
  const _TaskTile({
    required this.task,
    required this.onArchiveToggle,
    required this.onCheckedToggle,
    this.onTap,
    this.trailingBuilder,
  });

  final Task task;
  final void Function(Task task) onArchiveToggle;
  final void Function(Task task) onCheckedToggle;
  final void Function(Task task)? onTap;
  final Widget? Function(Task task)? trailingBuilder;

  @override
  State<_TaskTile> createState() => _TaskTileState();
}

class _TaskTileState extends State<_TaskTile> {
  bool _hovering = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovering = true),
      onExit: (_) => setState(() => _hovering = false),
      child: AnimatedScale(
        scale: _hovering ? 1.03 : 1.0,
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeOut,
        child: InkWell(
          borderRadius: BorderRadius.circular(24),
          onTap: widget.onTap == null ? null : () => widget.onTap!(widget.task),
          child: TaskCard(
            task: widget.task,
            onArchiveToggle: () => widget.onArchiveToggle(widget.task),
            onCheckedToggle: () => widget.onCheckedToggle(widget.task),
            icon: widget.trailingBuilder?.call(widget.task),
          ),
        ),
      ),
    );
  }
}
