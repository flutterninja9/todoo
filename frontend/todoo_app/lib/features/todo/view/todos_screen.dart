import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todoo_app/core/async_value/async_value.dart';
import 'package:todoo_app/core/design_system/app_theme.dart';
import 'package:todoo_app/di/di.dart';
import 'package:todoo_app/features/auth/view_model/auth_view_model.dart';
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
    viewModel.fetchTodos();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => viewModel,
      child: Scaffold(
        backgroundColor: AppTheme.of(context).backgroundColor,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          leading: Icon(
            Icons.note,
            color: AppTheme.of(context).iconColor,
          ),
          title: Text(
            "TODOO",
            style: Theme.of(context)
                .textTheme
                .headlineMedium
                ?.copyWith(color: AppTheme.of(context).textColor),
          ),
          actions: [
            IconButton(
              onPressed: () {
                context.read<AuthViewModel>().logoutUser();
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
            if (provider.state == ViewState.empty) {
              return const Center(
                child: Text("No todos found!"),
              );
            }
            if (provider.state == ViewState.error) {
              return Center(
                child: Text(provider.errorMessage),
              );
            }
            if (provider.state == ViewState.loaded) {
              return ListView.builder(
                itemBuilder: (context, index) {
                  final todo = provider.todos!.todos[index];

                  return ListTile(
                    title: Text(todo.title),
                    subtitle: Text(todo.content),
                  );
                },
                itemCount: provider.todos?.count,
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
