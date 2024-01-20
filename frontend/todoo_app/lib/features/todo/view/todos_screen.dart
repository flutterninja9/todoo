import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todoo_app/core/async_value/async_value.dart';
import 'package:todoo_app/core/design_system/app_theme.dart';
import 'package:todoo_app/core/extensions/datetime_X.dart';
import 'package:todoo_app/di/di.dart';
import 'package:todoo_app/features/auth/view_model/auth_view_model.dart';
import 'package:todoo_app/features/todo/view/widgets/todos_loaded_widget.dart';
import 'package:todoo_app/features/todo/view_model/todos_view_model.dart';

class TodosScreen extends StatefulWidget {
  const TodosScreen({super.key});
  static const route = "/todos";

  @override
  State<TodosScreen> createState() => _TodosScreenState();
}

class _TodosScreenState extends State<TodosScreen> {
  late final TodoViewModel viewModel;

  @override
  void initState() {
    super.initState();
    viewModel = sl<TodoViewModel>();
    viewModel.fetchTodos(day: DateTime.now());
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => viewModel,
      child: Scaffold(
        backgroundColor: AppTheme.of(context).backgroundColor,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          title: Consumer<TodoViewModel>(
            builder: (context, provider, child) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    onPressed: () {
                      viewModel.fetchTodos(
                        day: viewModel.currentFilter
                            .subtract(const Duration(days: 1)),
                      );
                    },
                    icon: const Icon(Icons.navigate_before_outlined),
                    color: AppTheme.of(context).iconColor,
                  ),
                  Text(
                    provider.currentFilter.toFormattedString(),
                    style: TextStyle(color: AppTheme.of(context).textColor),
                  ),
                  IconButton(
                    onPressed: viewModel.currentFilter.toFormattedString() ==
                            DateTime.now().toFormattedString()
                        ? null
                        : () {
                            viewModel.fetchTodos(
                              day: viewModel.currentFilter
                                  .add(const Duration(days: 1)),
                            );
                          },
                    icon: const Icon(Icons.navigate_next_outlined),
                    color: AppTheme.of(context).iconColor,
                  ),
                ],
              );
            },
          ),
          actions: [
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
                              ?.copyWith(color: AppTheme.of(context).textColor),
                        ),
                        backgroundColor: AppTheme.of(context).backgroundColor,
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: Text(
                              "No",
                              style: TextStyle(
                                  color: AppTheme.of(context).textColor),
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                              context.read<AuthViewModel>().logoutUser();
                            },
                            child: Text(
                              "Yes",
                              style: TextStyle(
                                  color: AppTheme.of(context).textColor),
                            ),
                          ),
                        ],
                      );
                    });
              },
              color: AppTheme.of(context).iconColor,
              icon: const Icon(Icons.logout),
            ),
          ],
        ),
        body: Consumer<TodoViewModel>(
          builder: (context, provider, child) {
            if (provider.state == ViewState.loading) {
              return Center(
                child: CircularProgressIndicator(
                  color: AppTheme.of(context).orangeColor,
                ),
              );
            }

            return TodosLoadedWidget(
              todos: provider.todos,
              isEmpty: provider.state == ViewState.empty,
              isError: provider.state == ViewState.error,
              onCreate: viewModel.addTodo,
              onDelete: viewModel.deleteTodo,
              onUpdate: viewModel.updateTodo,
            );
          },
        ),
      ),
    );
  }
}
