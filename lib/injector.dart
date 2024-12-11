import 'package:get_it/get_it.dart';
import 'package:queue_executor/data/local_storage/db.dart';
import 'package:queue_executor/data/task_executor/task_service.dart';
import 'package:queue_executor/state/completed_tasks/completed_tasks_bloc.dart';
import 'package:queue_executor/state/edit_task/edit_task_bloc.dart';
import 'package:queue_executor/state/main/main_bloc.dart';
import 'package:queue_executor/state/task_service/task_service_cubit.dart';

final injector = GetIt.instance;

void initInjector() {
  final database = MainDatabase();

  injector.registerSingleton<TaskService>(
    TaskService(database),
    dispose: (service) => service.dispose(),
  );

  injector.registerFactory<MainBloc>(() => MainBloc(database));
  injector
      .registerFactory<CompletedTasksBloc>(() => CompletedTasksBloc(database));
  injector.registerFactory<EditTaskBloc>(() => EditTaskBloc(database));
  injector.registerFactory(() => TaskServiceCubit(injector.get<TaskService>()));
}
