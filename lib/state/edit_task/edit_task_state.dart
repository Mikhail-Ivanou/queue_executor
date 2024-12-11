part of 'edit_task_bloc.dart';

sealed class EditTaskState extends Equatable {
  const EditTaskState();
}

final class EditTaskInitial extends EditTaskState {
  @override
  List<Object> get props => [];
}

final class EditTaskLoaded extends EditTaskState {
  final int? id;
  final TaskStatus? status;
  final String? title;
  final String? desc;
  final DateTime? createDate;

  const EditTaskLoaded({
    this.id,
    this.status,
    this.title,
    this.desc,
    this.createDate,
  });

  @override
  List<Object?> get props => [
        id,
        status,
        title,
        desc,
        createDate,
      ];

  EditTaskLoaded copyWith({
    int? id,
    TaskStatus? status,
    String? title,
    String? desc,
    DateTime? createDate,
  }) {
    return EditTaskLoaded(
      id: id ?? this.id,
      status: status ?? this.status,
      title: title ?? this.title,
      desc: desc ?? this.desc,
      createDate: createDate ?? this.createDate,
    );
  }
}

final class EditTaskSaved extends EditTaskState {
  @override
  List<Object> get props => [];
}

extension EditTaskStateExt on EditTaskState {
  bool get canSave {
    final state = this;
    return switch (state) {
      EditTaskLoaded() =>
        state.title?.isNotEmpty == true && state.desc?.isNotEmpty == true,
      _ => false,
    };
  }
}
