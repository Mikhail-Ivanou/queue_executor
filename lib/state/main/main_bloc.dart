import 'dart:async';

import 'package:drift/drift.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:queue_executor/data/local_storage/db.dart';
import 'package:queue_executor/domain/task_status.dart';

part 'main_event.dart';

part 'main_state.dart';

class MainBloc extends Bloc<MainEvent, MainState> {
  final MainDatabase db;
  StreamSubscription<List<Task>>? tasksListener;

  MainBloc(this.db) : super(MainInitial()) {
    on<MainInitEvent>((event, emit) async {
      tasksListener = db.tasks.select().watch().listen(
        (tasks) {
          add(UpdateTasksQueueEvent(tasks: tasks));
        },
      );
    });

    on<UpdateTasksQueueEvent>((event, emit) async {
      emit(MainLoaded(tasks: event.tasks));
    });

    on<RestartTaskQueueEvent>((event, emit) async {
      db.tasks.replaceOne(event.task.copyWith(
        status: TaskStatus.newTask,
      ));
    });

    on<DeleteTaskEvent>((event, emit) async {
      db.tasks.deleteOne(event.task);
    });
  }

  @override
  Future<void> close() {
    tasksListener?.cancel();
    return super.close();
  }
}
