part of 'task_service_cubit.dart';

sealed class TaskServiceState extends Equatable {
  const TaskServiceState();
}

final class TaskServicePaused extends TaskServiceState {
  @override
  List<Object> get props => [];
}

final class TaskServiceActive extends TaskServiceState {
  @override
  List<Object> get props => [];
}
