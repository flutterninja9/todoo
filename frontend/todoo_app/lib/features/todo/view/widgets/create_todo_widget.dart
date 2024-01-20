import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todoo_app/core/design_system/app_theme.dart';
import 'package:todoo_app/di/di.dart';
import 'package:todoo_app/features/todo/view_model/create_todo_view_model.dart';

class CreateTodoWidget extends StatelessWidget {
  const CreateTodoWidget({
    super.key,
    required this.onCreate,
  });

  final Function({required String content, required String title}) onCreate;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => sl<CreateTodoViewModel>(),
        builder: (context, snapshot) {
          return Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 18,
            ),
            child: Row(
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
                          cursorColor: AppTheme.of(context).orangeColor,
                          style: TextStyle(
                            color: AppTheme.of(context).textColor,
                          ),
                          onChanged:
                              context.read<CreateTodoViewModel>().updateTitle,
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
                      Consumer<CreateTodoViewModel>(
                          builder: (context, provider, child) {
                        if (provider.contentTextfieldVisible) {
                          return Container(
                            decoration: BoxDecoration(
                              color: AppTheme.of(context).tileColor,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: TextField(
                              cursorColor: AppTheme.of(context).orangeColor,
                              style: TextStyle(
                                color: AppTheme.of(context).textColor,
                              ),
                              onChanged: context
                                  .read<CreateTodoViewModel>()
                                  .updateContent,
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
                          );
                        }

                        return const SizedBox.shrink();
                      }),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Consumer<CreateTodoViewModel>(
                    builder: (context, provider, child) {
                  return CircleAvatar(
                    backgroundColor: provider.canSave
                        ? AppTheme.of(context).orangeColor
                        : AppTheme.of(context).orangeColor.withOpacity(0.6),
                    child: IconButton(
                      onPressed: provider.canSave
                          ? () async {
                              await onCreate(
                                title: provider.title!,
                                content: provider.content!,
                              );
                            }
                          : null,
                      icon: const Icon(Icons.add),
                      color: AppTheme.of(context).backgroundColor,
                    ),
                  );
                }),
              ],
            ),
          );
        });
  }
}
