import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todoo_app/core/design_system/app_theme.dart';
import 'package:todoo_app/di/di.dart';
import 'package:todoo_app/features/todo/model/todo_model.dart';
import 'package:todoo_app/features/todo/view_model/edit_todo_viewmodel.dart';

class EditTodoWidget extends StatefulWidget {
  const EditTodoWidget({
    super.key,
    required this.todo,
    required this.onUpdate,
  });

  final Todo todo;
  final Function({
    required String content,
    required String title,
    required String status,
  }) onUpdate;

  @override
  State<EditTodoWidget> createState() => _EditTodoWidgetState();
}

class _EditTodoWidgetState extends State<EditTodoWidget> {
  late final TextEditingController titleController;
  late final TextEditingController contentController;

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController(text: widget.todo.title);
    contentController = TextEditingController(text: widget.todo.content);
  }

  @override
  void dispose() {
    titleController.dispose();
    contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => sl<EditTodoViewModel>()..init(widget.todo),
        builder: (context, snapshot) {
          return Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 18,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: AppTheme.of(context).tileColor,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: TextField(
                          controller: titleController,
                          cursorColor: AppTheme.of(context).orangeColor,
                          style: TextStyle(
                            color: AppTheme.of(context).textColor,
                          ),
                          onChanged:
                              context.read<EditTodoViewModel>().updateTitle,
                          decoration: InputDecoration(
                            hintText: "write your next task",
                            hintStyle: TextStyle(
                              color: AppTheme.of(context)
                                  .textColor
                                  .withOpacity(0.7),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 12,
                            ),
                            border: const OutlineInputBorder(
                              borderSide: BorderSide.none,
                            ),
                            errorBorder: const OutlineInputBorder(
                              borderSide: BorderSide.none,
                            ),
                            enabledBorder: const OutlineInputBorder(
                              borderSide: BorderSide.none,
                            ),
                            focusedBorder: const OutlineInputBorder(
                              borderSide: BorderSide.none,
                            ),
                            focusedErrorBorder: const OutlineInputBorder(
                              borderSide: BorderSide.none,
                            ),
                            focusColor: AppTheme.of(context).borderColor,
                            hoverColor: AppTheme.of(context).borderColor,
                            fillColor: AppTheme.of(context).borderColor,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        decoration: BoxDecoration(
                          color: AppTheme.of(context).tileColor,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: TextField(
                          controller: contentController,
                          cursorColor: AppTheme.of(context).orangeColor,
                          style: TextStyle(
                            color: AppTheme.of(context).textColor,
                          ),
                          onChanged:
                              context.read<EditTodoViewModel>().updateContent,
                          decoration: InputDecoration(
                            hintText: "how about some description?",
                            hintStyle: TextStyle(
                              color: AppTheme.of(context)
                                  .textColor
                                  .withOpacity(0.7),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 12,
                            ),
                            border: const OutlineInputBorder(
                              borderSide: BorderSide.none,
                            ),
                            errorBorder: const OutlineInputBorder(
                              borderSide: BorderSide.none,
                            ),
                            enabledBorder: const OutlineInputBorder(
                              borderSide: BorderSide.none,
                            ),
                            focusedBorder: const OutlineInputBorder(
                              borderSide: BorderSide.none,
                            ),
                            focusedErrorBorder: const OutlineInputBorder(
                              borderSide: BorderSide.none,
                            ),
                            focusColor: AppTheme.of(context).borderColor,
                            hoverColor: AppTheme.of(context).borderColor,
                            fillColor: AppTheme.of(context).borderColor,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Consumer<EditTodoViewModel>(
                            builder: (context, provider, child) {
                              return Row(
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      provider.updateStatus("completed");
                                    },
                                    child: CircleAvatar(
                                      backgroundColor:
                                          AppTheme.of(context).greenColor,
                                      child: provider.status == "completed"
                                          ? const Icon(Icons.done)
                                          : null,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  GestureDetector(
                                    onTap: () {
                                      provider.updateStatus("pending");
                                    },
                                    child: CircleAvatar(
                                      backgroundColor:
                                          AppTheme.of(context).orangeColor,
                                      child: provider.status == "pending"
                                          ? const Icon(Icons.done)
                                          : null,
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                          const SizedBox(width: 12),
                          Consumer<EditTodoViewModel>(
                              builder: (context, provider, child) {
                            return ElevatedButton.icon(
                              icon: const Icon(Icons.edit_outlined),
                              label: const Text("Update"),
                              style: ButtonStyle(
                                backgroundColor: provider.canUpdate
                                    ? MaterialStatePropertyAll(
                                        AppTheme.of(context).orangeColor)
                                    : MaterialStatePropertyAll(
                                        AppTheme.of(context)
                                            .orangeColor
                                            .withOpacity(0.6)),
                                iconColor: provider.canUpdate
                                    ? MaterialStatePropertyAll(
                                        AppTheme.of(context).backgroundColor)
                                    : MaterialStatePropertyAll(
                                        AppTheme.of(context)
                                            .backgroundColor
                                            .withOpacity(0.6)),
                                foregroundColor: provider.canUpdate
                                    ? MaterialStatePropertyAll(
                                        AppTheme.of(context).backgroundColor)
                                    : MaterialStatePropertyAll(
                                        AppTheme.of(context)
                                            .backgroundColor
                                            .withOpacity(0.6)),
                              ),
                              onPressed: provider.canUpdate
                                  ? () async {
                                      await widget.onUpdate(
                                        title: provider.title!,
                                        content: provider.content!,
                                        status: provider.status!,
                                      );
                                    }
                                  : null,
                            );
                          }),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        });
  }
}
