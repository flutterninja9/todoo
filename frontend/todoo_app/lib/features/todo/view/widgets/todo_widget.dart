import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todoo_app/core/design_system/app_theme.dart';
import 'package:todoo_app/di/di.dart';
import 'package:todoo_app/features/todo/model/todo_model.dart';
import 'package:todoo_app/features/todo/view/widgets/edit_todo_widget.dart';
import 'package:todoo_app/features/todo/view_model/edit_todo_viewmodel.dart';

class TodoWidget extends StatelessWidget {
  const TodoWidget({
    super.key,
    required this.todo,
    required this.onDelete,
    required this.onUpdate,
  });

  final Todo todo;
  final Function({required String todoId}) onDelete;
  final Function({
    required String id,
    String? title,
    String? content,
    String? status,
  }) onUpdate;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<EditTodoViewModel>(
        create: (context) => sl<EditTodoViewModel>()..init(todo),
        builder: (context, child) {
          return Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.symmetric(
              vertical: 8,
              horizontal: 16,
            ),
            decoration: BoxDecoration(
              border: Border.all(color: AppTheme.of(context).borderColor),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: [
                Expanded(
                  child: Consumer<EditTodoViewModel>(
                      builder: (context, provider, child) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CircleAvatar(
                              minRadius: 16,
                              backgroundColor: todo.completed
                                  ? AppTheme.of(context).greenColor
                                  : AppTheme.of(context).orangeColor,
                              child: InkWell(
                                onTap: todo.completed
                                    ? null
                                    : () async {
                                        await onUpdate(
                                          status: "completed",
                                          title: null,
                                          content: null,
                                          id: todo.id!,
                                        );
                                      },
                                child: CircleAvatar(
                                  backgroundColor: todo.completed
                                      ? AppTheme.of(context).greenColor
                                      : AppTheme.of(context).backgroundColor,
                                  maxRadius: todo.completed ? 16 : 14,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    todo.title ?? "-",
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w400,
                                      decoration: todo.completed
                                          ? TextDecoration.lineThrough
                                          : null,
                                      decorationStyle:
                                          TextDecorationStyle.dashed,
                                      decorationColor:
                                          AppTheme.of(context).iconColor,
                                      color: AppTheme.of(context).textColor,
                                    ),
                                  ),
                                  Text(
                                    todo.content ?? "-",
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400,
                                      decoration: todo.completed
                                          ? TextDecoration.lineThrough
                                          : null,
                                      decorationStyle:
                                          TextDecorationStyle.dashed,
                                      decorationColor:
                                          AppTheme.of(context).iconColor,
                                      color: AppTheme.of(context)
                                          .textColor
                                          .withOpacity(0.7),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        if (provider.isEditing)
                          EditTodoWidget(
                            todo: todo,
                            onUpdate: ({
                              required String content,
                              required String title,
                              required String status,
                            }) async {
                              await onUpdate(
                                title: title,
                                content: content,
                                status: status,
                                id: todo.id!,
                              );
                            },
                          ),
                      ],
                    );
                  }),
                ),
                Consumer<EditTodoViewModel>(
                    builder: (context, provider, child) {
                  return Row(
                    children: [
                      if (provider.isEditing)
                        IconButton(
                          onPressed: context
                              .read<EditTodoViewModel>()
                              .toggleEditingMode,
                          color: AppTheme.of(context).iconColor,
                          icon: const Icon(Icons.cancel_outlined),
                        )
                      else
                        IconButton(
                          onPressed: context
                              .read<EditTodoViewModel>()
                              .toggleEditingMode,
                          color: AppTheme.of(context).iconColor,
                          icon: const Icon(Icons.edit_outlined),
                        ),
                      IconButton(
                        onPressed: () async {
                          await showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: Text(
                                    "You you sure?",
                                    style: Theme.of(context)
                                        .textTheme
                                        .headlineSmall
                                        ?.copyWith(
                                            color:
                                                AppTheme.of(context).textColor),
                                  ),
                                  backgroundColor:
                                      AppTheme.of(context).backgroundColor,
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: Text(
                                        "No",
                                        style: TextStyle(
                                            color:
                                                AppTheme.of(context).textColor),
                                      ),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                        onDelete(todoId: todo.id!);
                                      },
                                      child: Text(
                                        "Yes",
                                        style: TextStyle(
                                            color:
                                                AppTheme.of(context).textColor),
                                      ),
                                    ),
                                  ],
                                );
                              });
                        },
                        color: AppTheme.of(context).iconColor,
                        icon: const Icon(Icons.delete_outline_outlined),
                      ),
                    ],
                  );
                }),
              ],
            ),
          );
        });
  }
}
