import 'dart:async';

import 'package:drift/drift.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:queue_executor/data/local_storage/db.dart';
import 'package:queue_executor/domain/task_status.dart';

part 'edit_task_event.dart';

part 'edit_task_state.dart';

class EditTaskBloc extends Bloc<EditTaskEvent, EditTaskState> {
  final MainDatabase db;
  StreamSubscription<Task>? taskListener;

  EditTaskBloc(this.db) : super(EditTaskInitial()) {
    on<EditTaskLoadEvent>((event, emit) async {
      final taskId = event.taskId;
      if (taskId == null) {
        emit(EditTaskLoaded());
        return;
      }
      _listenTask(taskId);
    });

    on<EditTaskRefreshEvent>((event, emit) async {
      emit(EditTaskLoaded(
        id: event.task.id,
        status: event.task.status,
        title: event.task.title,
        desc: event.task.desc,
      ));
    });

    on<UpdateTaskTitleEvent>((event, emit) async {
      final currentState = state;
      switch (currentState) {
        case EditTaskLoaded():
          emit(currentState.copyWith(title: event.title));
        default:
      }
    });

    on<UpdateTaskDescEvent>((event, emit) async {
      final currentState = state;
      switch (currentState) {
        case EditTaskLoaded():
          emit(currentState.copyWith(desc: event.desc));
        default:
      }
    });

    on<EditTaskSaveEvent>((event, emit) async {
      final currentState = state;
      switch (currentState) {
        case EditTaskLoaded():
          {
            final title = currentState.title;
            final desc = currentState.desc;
            if (title == null || desc == null) {
              return;
            }
            final task = Task(
              id: currentState.id,
              title: title,
              desc: desc,
              status: currentState.status ?? TaskStatus.newTask,
              createTime: currentState.createDate ?? DateTime.now(),
            );
            db.tasks.insertOnConflictUpdate(task);
            emit(EditTaskSaved());
          }
        default:
      }
    });
  }

  void _listenTask(int taskId) {
    final taskQuery = db.tasks.select()..where((tbl) => tbl.id.equals(taskId));

    taskListener = taskQuery.watchSingle().listen(
      (task) {
        add(EditTaskRefreshEvent(task));
      },
    );
  }

  @override
  Future<void> close() {
    taskListener?.cancel();
    return super.close();
  }
}
