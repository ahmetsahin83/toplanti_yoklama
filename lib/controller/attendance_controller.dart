import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../service/attendance_service.dart';
import '../service/service_locator.dart';

final attendanceProvider = ChangeNotifierProvider<AttendanceController>((ref) {
  return AttendanceController();
});

class AttendanceController extends ChangeNotifier {
  late final AttendanceService _attendanceService;
  AttendanceController() {
    _attendanceService = getIt<AttendanceService>();
  }
  getUsers(int meetingId) async {
    return await _attendanceService.getUsers(meetingId);
  }

  newAttendance(int userId, int meetingId, bool katildiMi) async {
    await _attendanceService.newAttendance(userId, meetingId, katildiMi);
    notifyListeners();
  }

  getAttendance(int userId) async {
    return await _attendanceService.getAttendance(userId);
  }

  changeAttendance(int id, bool katildiMi) async {
    await _attendanceService.changeAttendance(id, katildiMi);
    notifyListeners();
  }

  Future<List<int>> getAttendanceCount(int userId) async {
    return await _attendanceService.getAttendanceCount(userId);
  }
}
