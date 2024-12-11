import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:queue_executor/injector.dart';
import 'package:queue_executor/state/edit_task/edit_task_bloc.dart';

class EditTaskPage extends StatelessWidget {
  const EditTaskPage({
    super.key,
    this.taskId,
  });

  final int? taskId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<EditTaskBloc>(
      create: (context) => injector.get()
        ..add(EditTaskLoadEvent(
          taskId,
        )),
      child: Scaffold(
        appBar: AppBar(
          title: Text(taskId == null ? 'Create task' : 'Edit task'),
          actions: [
            BlocBuilder<EditTaskBloc, EditTaskState>(
              builder: (context, state) {
                return state.canSave
                    ? IconButton(
                        icon: Icon(Icons.check),
                        onPressed: () {
                          context.read<EditTaskBloc>().add(EditTaskSaveEvent());
                        })
                    : SizedBox();
              },
            ),
          ],
        ),
        body: _TaskContent(),
      ),
    );
  }
}

class _TaskContent extends StatelessWidget {
  const _TaskContent();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<EditTaskBloc, EditTaskState>(
      listener: (context, state) {
        if (state is EditTaskSaved) {
          Navigator.pop(context);
        }
      },
      builder: (context, state) {
        switch (state) {
          case EditTaskLoaded():
            final taskBloc = context.read<EditTaskBloc>();
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Column(children: [
                  TextFormField(
                    decoration: InputDecoration(
                      label: Text('Enter title'),
                    ),
                    initialValue: state.title,
                    onChanged: (value) {
                      taskBloc.add(UpdateTaskTitleEvent(value));
                    },
                    textInputAction: TextInputAction.next,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    decoration: InputDecoration(
                      label: Text('Enter description'),
                    ),
                    initialValue: state.desc,
                    onChanged: (value) {
                      taskBloc.add(UpdateTaskDescEvent(value));
                    },
                    onEditingComplete: () {
                      taskBloc.add(EditTaskSaveEvent());
                    },
                    textInputAction: TextInputAction.done,
                  ),
                ]),
              ),
            );
          default:
            return const SizedBox();
        }
      },
    );
  }
}
