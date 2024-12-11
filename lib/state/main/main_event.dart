part of 'main_bloc.dart';

sealed class MainEvent extends Equatable {
  const MainEvent();
}

class MainInitEvent extends MainEvent {
  const MainInitEvent();

  @override
  List<Object?> get props => [];
}

class UpdateTasksQueueEvent extends MainEvent {
  const UpdateTasksQueueEvent({required this.tasks});

  final List<Task> tasks;

  @override
  List<Object?> get props => [tasks];
}

class RestartTaskQueueEvent extends MainEvent {
  const RestartTaskQueueEvent({required this.task});

  final Task task;

  @override
  List<Object?> get props => [task];
}

class DeleteTaskEvent extends MainEvent {
  const DeleteTaskEvent({required this.task});

  final Task task;

  @override
  List<Object?> get props => [task];
}
