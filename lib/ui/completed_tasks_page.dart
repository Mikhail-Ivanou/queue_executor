import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:queue_executor/data/local_storage/db.dart';
import 'package:queue_executor/injector.dart';
import 'package:queue_executor/state/completed_tasks/completed_tasks_bloc.dart';
import 'package:queue_executor/ui/widgets/task_cell.dart';

class CompletedTasksPage extends StatelessWidget {
  const CompletedTasksPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<CompletedTasksBloc>(
      create: (context) => injector.get()..add(const CompletedTasksInitEvent()),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Completed tasks'),
        ),
        body: const _MainContent(),
      ),
    );
  }
}

class _MainContent extends StatelessWidget {
  const _MainContent();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CompletedTasksBloc, CompletedTasksState>(
      builder: (context, state) {
        return switch (state) {
          CompletedTasksInitial() => SizedBox(), //loader progress?
          CompletedTasksLoaded() => CompletedTasksLoadedWidget(
              tasks: state.tasks,
            ),
        };
      },
    );
  }
}

class CompletedTasksLoadedWidget extends StatelessWidget {
  const CompletedTasksLoadedWidget({
    super.key,
    required this.tasks,
  });

  final List<Task> tasks;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      separatorBuilder: (context, index) => Divider(),
      itemBuilder: (context, index) {
        final task = tasks[index];
        return TaskCell(task);
      },
      itemCount: tasks.length,
    );
  }
}
