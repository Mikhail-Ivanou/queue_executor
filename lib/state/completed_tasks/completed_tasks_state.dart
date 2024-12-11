part of 'completed_tasks_bloc.dart';

sealed class CompletedTasksState extends Equatable {
  const CompletedTasksState();
}

class CompletedTasksInitial extends CompletedTasksState {
  @override
  List<Object> get props => [];
}

class CompletedTasksLoaded extends CompletedTasksState {
  final List<Task> tasks;

  const CompletedTasksLoaded({
    required this.tasks,
  });

  @override
  List<Object?> get props => [
        tasks,
      ];

  CompletedTasksLoaded copyWith({
    List<Task>? tasks,
  }) {
    return CompletedTasksLoaded(
      tasks: tasks ?? this.tasks,
    );
  }
}
