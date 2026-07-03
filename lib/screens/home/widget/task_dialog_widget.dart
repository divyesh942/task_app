import 'package:flutter/material.dart';
import 'package:todo_design/config/app_enums.dart';
import 'package:todo_design/config/app_string.dart';
import 'package:todo_design/config/app_theme.dart';
import 'package:todo_design/extensions/ext_on_num.dart';
import 'package:todo_design/model/task.dart';
import 'package:uuid/uuid.dart';

Future<void> showTaskDialog(
  BuildContext context, {
  Task? task,
  required Future<void> Function(Task task) onSubmit,
}) async {
  await showDialog<void>(
    context: context,
    barrierDismissible: true,
    barrierColor: AppColors.barrierColor,
    builder: (_) {
      return _TaskDialog(
        task: task,
        onSubmit: onSubmit,
      );
    },
  );
}

class _TaskDialog extends StatefulWidget {
  const _TaskDialog({
    required this.task,
    required this.onSubmit,
  });

  final Task? task;
  final Future<void> Function(Task task) onSubmit;

  @override
  State<_TaskDialog> createState() => _TaskDialogState();
}

class _TaskDialogState extends State<_TaskDialog> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _uuid = const Uuid();

  late Priorities _selectedPriority;
  late final bool _isUpdate;
  late final String _taskId;
  late final bool _isChecked;
  late final bool _isArchived;

  @override
  void initState() {
    super.initState();
    final task = widget.task;
    _isUpdate = task != null;
    _taskId = task?.id ?? _uuid.v4();
    _isChecked = task?.isChecked ?? false;
    _isArchived = task?.isArchived ?? false;
    _selectedPriority = task?.priority ?? Priorities.high;
    _titleController.text = task?.title ?? '';
    _descriptionController.text = task?.description ?? '';
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppColors.appWhite,
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 560),
        child: SingleChildScrollView(
          padding: EdgeInsets.only(
            bottom: MediaQuery.viewInsetsOf(context).bottom,
          ),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _isUpdate ? AppString.updateTask : AppString.createTask,
                    style: AppTextStyle.headline.copyWith(fontSize: 26),
                  ),
                  8.height,
                  Text(
                    AppString.taskSummary,
                    style: AppTextStyle.listSubTitle.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                  20.height,
                  TextFormField(
                    controller: _titleController,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    textInputAction: TextInputAction.next,
                    validator: (value) => value == null || value.trim().isEmpty
                        ? AppString.validateName
                        : null,
                    decoration: InputDecoration(
                      labelText: AppString.taskTitle,
                      labelStyle: AppTextStyle.listSubTitle.copyWith(
                        color: AppColors.textSecondary,
                      ),
                      hintStyle: AppTextStyle.listSubTitle.copyWith(
                        color: AppColors.textSecondary,
                      ),
                      hintText: AppString.taskTitleHint,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                  ),
                  14.height,
                  TextFormField(
                    controller: _descriptionController,
                    maxLines: 4,
                    decoration: InputDecoration(
                      hintStyle: AppTextStyle.listSubTitle.copyWith(
                        color: AppColors.textSecondary,
                      ),
                      labelStyle: AppTextStyle.listSubTitle.copyWith(
                        color: AppColors.textSecondary,
                      ),
                      labelText: AppString.taskDescription,
                      hintText: AppString.taskDescriptionHint,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                  ),
                  18.height,
                  Text(
                    AppString.priority,
                    style: AppTextStyle.small.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  12.height,
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: Priorities.values.map((priority) {
                      final isSelected = _selectedPriority == priority;
                      return ChoiceChip(
                        label: Text(priority.title),
                        selected: isSelected,
                        onSelected: (_) {
                          setState(() {
                            _selectedPriority = priority;
                          });
                        },
                        backgroundColor: AppColors.appWhite,
                        selectedColor: AppColors.primary.withOpacity(0.16),
                        labelStyle: AppTextStyle.listSubTitle.copyWith(
                          color: isSelected
                              ? AppColors.primary
                              : AppColors.textSecondary,
                          fontWeight: FontWeight.w700,
                        ),
                        side: BorderSide(
                          color: isSelected
                              ? AppColors.primary
                              : AppColors.checkBoxBorder,
                        ),
                      );
                    }).toList(),
                  ),
                  24.height,
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => Navigator.of(context).pop(),
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(
                              color: AppColors.checkBoxBorder,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            minimumSize: const Size.fromHeight(52),
                          ),
                          child: Text('Cancel',
                              style: AppTextStyle.small.copyWith(
                                color: AppColors.textSecondary,
                                fontWeight: FontWeight.w600,
                              )),
                        ),
                      ),
                      12.width,
                      Expanded(
                        child: FilledButton(
                          onPressed: _saveTask,
                          style: FilledButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            foregroundColor: AppColors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            minimumSize: const Size.fromHeight(52),
                          ),
                          child: Text(
                              _isUpdate
                                  ? AppString.updateTask
                                  : AppString.saveTask,
                              style: AppTextStyle.small.copyWith(
                                color: AppColors.white,
                                fontWeight: FontWeight.w600,
                              )),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _saveTask() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final task = Task(
      id: _taskId,
      title: _titleController.text.trim(),
      description: _descriptionController.text.trim(),
      priority: _selectedPriority,
      isChecked: _isChecked,
      isArchived: _isArchived,
    );

    await widget.onSubmit(task);
    if (mounted) {
      Navigator.of(context).pop();
    }
  }
}
