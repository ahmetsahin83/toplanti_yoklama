// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../utils/extensions.dart';

import '../model/user_model.dart';
import '../service/attendance_service.dart';
import '../service/meeting_service.dart';
import '../service/service_locator.dart';

final meetingProvider = ChangeNotifierProvider<MeetingController>((ref) {
  return MeetingController();
});

class MeetingController extends ChangeNotifier {
  MeetingController() {
    _meetingService = getIt<MeetingService>();
    _attendanceService = getIt<AttendanceService>();
  }
  late final MeetingService _meetingService;
  late final AttendanceService _attendanceService;
  String dateTime = "";
  final meetingNameController = TextEditingController();
  List<UserModel> userList = [];
  newMeeting(BuildContext context) async {
    meetingNameController.clear();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Yeni Toplantı Oluştur"),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Form(
                    child: TextFormField(
                  controller: meetingNameController,
                  decoration: const InputDecoration(
                    labelText: "Toplantı Adı",
                  ),
                )),
                SizedBox(
                  height: 300,
                  width: 300,
                  child: CalendarDatePicker(
                    initialDate: DateTime.now(),
                    firstDate: DateTime.utc(2000),
                    lastDate: DateTime.utc(2030),
                    onDateChanged: (date) {
                      dateTime = date.toShortString;
                    },
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("İptal"),
            ),
            TextButton(
              onPressed: () async {
                final response = await _meetingService.newMeeting(meetingNameController.text, dateTime);
                Navigator.pop(context);
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: Text(response),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                            notifyListeners();
                          },
                          child: const Text("Tamam"),
                        ),
                      ],
                    );
                  },
                );
              },
              child: const Text("Oluştur"),
            ),
          ],
        );
      },
    );
  }

  getMeetings() async {
    final data = await _meetingService.getMeetings();
    return data;
  }

  getAttendanceByMeetingId(int id) async {
    final data = await _attendanceService.getAttendanceByMeetingId(id);
    return data;
  }

  deleteMeeting(int id) async {
    await _meetingService.deleteMeeting(id);
    notifyListeners();
  }
}
