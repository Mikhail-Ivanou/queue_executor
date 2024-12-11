part of 'main_bloc.dart';

sealed class MainState extends Equatable {
  const MainState();
}

class MainInitial extends MainState {
  @override
  List<Object> get props => [];
}

class MainLoaded extends MainState {
  final List<Task> tasks;

  const MainLoaded({
    required this.tasks,
  });

  @override
  List<Object?> get props => [
        tasks,
      ];

  MainLoaded copyWith({
    List<Task>? tasks,
  }) {
    return MainLoaded(
      tasks: tasks ?? this.tasks,
    );
  }
}
