import 'package:get_it/get_it.dart';

import 'attendance_service.dart';
import 'login_service.dart';
import 'meeting_service.dart';
import 'user_service.dart';

final getIt = GetIt.instance;

void setupLocator() {
  getIt.registerLazySingleton(() => MeetingService());
  getIt.registerLazySingleton(() => AttendanceService());
  getIt.registerLazySingleton(() => LoginService());
  getIt.registerLazySingleton(() => UserService());
}
