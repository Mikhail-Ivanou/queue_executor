import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:queue_executor/data/local_storage/db.dart';
import 'package:queue_executor/domain/task_status.dart';
import 'package:queue_executor/injector.dart';
import 'package:queue_executor/state/main/main_bloc.dart';
import 'package:queue_executor/state/task_service/task_service_cubit.dart';
import 'package:queue_executor/ui/completed_tasks_page.dart';
import 'package:queue_executor/ui/edit_task_page.dart';
import 'package:queue_executor/ui/widgets/task_cell.dart';

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<MainBloc>(
          create: (context) => injector.get()..add(const MainInitEvent()),
        ),
        BlocProvider<TaskServiceCubit>(
          create: (context) => injector.get(),
        ),
      ],
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Tasks executor app'),
          leading: BlocBuilder<TaskServiceCubit, TaskServiceState>(
            builder: (context, state) {
              return IconButton(
                icon: Icon(state.icon),
                onPressed: () {
                  context.read<TaskServiceCubit>().switchState();
                },
              );
            },
          ),
          actions: [
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const CompletedTasksPage()),
                );
              },
              child: const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text('Completed'),
              ),
            ),
          ],
        ),
        body: const _MainContent(),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => EditTaskPage(),
              ),
            );
          },
          child: const Icon(Icons.add),
        ), // This trailing comma makes auto-formatting nicer for build methods.
      ),
    );
  }
}

extension on TaskServiceState {
  IconData? get icon => switch (this) {
        TaskServicePaused() => Icons.play_arrow,
        TaskServiceActive() => Icons.pause,
      };
}

class _MainContent extends StatelessWidget {
  const _MainContent();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MainBloc, MainState>(
      builder: (baseContext, state) {
        switch (state) {
          case MainInitial():
            return const Padding(
              padding: EdgeInsets.all(16.0),
              child: Center(
                child: Text('Loading...'),
              ),
            );
          case MainLoaded():
            final tasks = state.tasks.toList();
            return ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              separatorBuilder: (context, index) => Divider(),
              itemBuilder: (context, index) {
                final task = tasks[index];
                return GestureDetector(
                  onTap: () {
                    if (task.status == TaskStatus.error) {
                      context.read<MainBloc>().add(
                            RestartTaskQueueEvent(task: task),
                          );
                      return;
                    }
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => EditTaskPage(taskId: task.id),
                      ),
                    );
                  },
                  onLongPress: () {
                    _deleteTask(context, task);
                  },
                  child: TaskCell(task),
                );
              },
              itemCount: tasks.length,
            );
        }
      },
    );
  }

  void _deleteTask(BuildContext context, Task task) {
    showAdaptiveDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text('Delete task?'),
          content: Text(task.title),
          actions: [
            OutlinedButton(
              onPressed: () {
                context.read<MainBloc>().add(DeleteTaskEvent(task: task));
                Navigator.pop(dialogContext);
              },
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                context.read<MainBloc>().add(DeleteTaskEvent(task: task));
                Navigator.pop(dialogContext);
              },
              child: Text('Delete'),
            )
          ],
        );
      },
    );
  }
}
