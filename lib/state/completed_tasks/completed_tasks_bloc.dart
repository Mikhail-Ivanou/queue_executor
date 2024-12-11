import 'dart:async';

import 'package:drift/drift.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:queue_executor/data/local_storage/db.dart';
import 'package:queue_executor/domain/task_status.dart';

part 'completed_tasks_event.dart';

part 'completed_tasks_state.dart';

class CompletedTasksBloc
    extends Bloc<CompletedTasksEvent, CompletedTasksState> {
  final MainDatabase db;
  StreamSubscription<List<Task>>? tasksListener;

  CompletedTasksBloc(this.db) : super(CompletedTasksInitial()) {
    on<CompletedTasksInitEvent>((event, emit) async {
      _listenCompletedTasks();
    });

    on<UpdateCompletedTasksEvent>((event, emit) async {
      emit(CompletedTasksLoaded(tasks: event.tasks));
    });
  }

  void _listenCompletedTasks() {
    final tasksQuery = db.tasks.select()
      ..where(
        (tbl) {
          return tbl.status.equals(TaskStatus.completed.name);
        },
      );

    tasksListener = tasksQuery.watch().listen(
      (tasks) {
        add(UpdateCompletedTasksEvent(tasks: tasks));
      },
    );
  }

  @override
  Future<void> close() {
    tasksListener?.cancel();
    return super.close();
  }
}
