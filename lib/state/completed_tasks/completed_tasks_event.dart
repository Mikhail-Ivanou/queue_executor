part of 'completed_tasks_bloc.dart';

sealed class CompletedTasksEvent extends Equatable {
  const CompletedTasksEvent();
}

class CompletedTasksInitEvent extends CompletedTasksEvent {
  const CompletedTasksInitEvent();

  @override
  List<Object?> get props => [];
}

class UpdateCompletedTasksEvent extends CompletedTasksEvent {
  const UpdateCompletedTasksEvent({required this.tasks});

  final List<Task> tasks;

  @override
  List<Object?> get props => [tasks];
}