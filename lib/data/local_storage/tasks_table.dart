import 'package:drift/drift.dart';
import 'package:queue_executor/domain/task_status.dart';

class Tasks extends Table {
  IntColumn get id => integer().nullable().autoIncrement()();

  TextColumn get status => textEnum<TaskStatus>()();

  TextColumn get title => text()();

  TextColumn get desc => text()();

  DateTimeColumn get createTime => dateTime()();
}
