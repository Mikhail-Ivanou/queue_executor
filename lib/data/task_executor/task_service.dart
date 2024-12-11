import 'dart:async';
import 'dart:math';

import 'package:drift/drift.dart';
import 'package:queue_executor/data/local_storage/db.dart';
import 'package:queue_executor/domain/task_status.dart';

class TaskService {
  final MainDatabase database;
  StreamSubscription<List<Task>>? tasksListener;
  bool isPaused = false;

  _Status _status = _Status.idle;

  TaskService(this.database) {
    init();
  }

  void init() {
    tasksListener?.cancel();
    final tasksQuery = database.tasks.select()
      ..where(
        (tbl) {
          return tbl.status.equals(TaskStatus.newTask.name);
        },
      );

    tasksListener = tasksQuery.watch().listen(
      (tasks) {
        if (!isPaused && _status == _Status.idle) {
          final task = tasks.firstOrNull;
          if (task != null) {
            _process(task);
          }
        }
      },
    );
  }

  void dispose() {
    tasksListener?.cancel();
  }

  Future<void> _process(Task initialTask) async {
    _status = _Status.processing;
    Task task = initialTask.copyWith(status: TaskStatus.executing);
    database.tasks.replaceOne(task);
    final random = Random();
    await Future.delayed(Duration(seconds: random.nextInt(60)));
    task = initialTask.copyWith(
      status: random.nextInt(10) > 2 ? TaskStatus.completed : TaskStatus.error,
    );
    _status = _Status.idle;
    database.tasks.replaceOne(task);
  }
}

enum _Status {
  idle,
  processing,
}
