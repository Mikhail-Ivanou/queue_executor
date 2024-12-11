import 'package:flutter/material.dart';
import 'package:queue_executor/data/local_storage/db.dart';
import 'package:queue_executor/domain/task_status.dart';

class TaskCell extends StatelessWidget {
  final Task task;

  const TaskCell(this.task, {super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          task.status.icon,
          color: task.status.color,
        ),
        const SizedBox(
          width: 12,
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8),
              Text(
                task.title,
              ),
              const SizedBox(height: 1),
              Text(
                task.desc,
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ],
    );
  }
}

extension on TaskStatus {
  IconData? get icon => switch (this) {
        TaskStatus.newTask => Icons.access_time,
        TaskStatus.executing => Icons.incomplete_circle,
        TaskStatus.completed => Icons.check_circle,
        TaskStatus.error => Icons.error_outline_rounded,
      };

  Color get color => switch (this) {
        TaskStatus.newTask => Colors.black,
        TaskStatus.executing => Colors.orangeAccent,
        TaskStatus.completed => Colors.green,
        TaskStatus.error => Colors.red,
      };
}
