part of 'edit_task_bloc.dart';

sealed class EditTaskEvent extends Equatable {
  const EditTaskEvent();
}

class EditTaskLoadEvent extends EditTaskEvent {
  const EditTaskLoadEvent(this.taskId);

  final int? taskId;

  @override
  List<Object?> get props => [taskId];
}

class EditTaskRefreshEvent extends EditTaskEvent {
  const EditTaskRefreshEvent(this.task);

  final Task task;

  @override
  List<Object?> get props => [task];
}

class EditTaskSaveEvent extends EditTaskEvent {
  const EditTaskSaveEvent();

  @override
  List<Object?> get props => [];
}

class UpdateTaskTitleEvent extends EditTaskEvent {
  final String title;

  const UpdateTaskTitleEvent(this.title);

  @override
  List<Object?> get props => [title];
}

class UpdateTaskDescEvent extends EditTaskEvent {
  final String desc;

  const UpdateTaskDescEvent(this.desc);

  @override
  List<Object?> get props => [desc];
}
