import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:queue_executor/data/task_executor/task_service.dart';

part 'task_service_state.dart';

class TaskServiceCubit extends Cubit<TaskServiceState> {
  final TaskService service;

  TaskServiceCubit(this.service)
      : super(
          service.isPaused ? TaskServicePaused() : TaskServiceActive(),
        );

  void switchState() {
    service.isPaused = !service.isPaused;
    emit(service.isPaused ? TaskServicePaused() : TaskServiceActive());
    if (!service.isPaused) {
      service.init();
    }
  }
}
