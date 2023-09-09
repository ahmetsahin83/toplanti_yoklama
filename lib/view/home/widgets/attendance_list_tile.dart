import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import '../../../controller/attendance_controller.dart';
import '../../../controller/main_controller.dart';
import '../../../model/attendance_model.dart';
import '../../../model/meeting_model.dart';

class AttendanceListTile extends StatelessWidget {
  const AttendanceListTile({super.key, required this.controller, required this.yoklama, required this.index});

  final MainController controller;
  final AttendanceModel yoklama;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (_, WidgetRef reffo, __) {
        return FutureBuilder(
            future: controller.getMeetingById(yoklama.meetingId!),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }
              MeetingModel meeting = snapshot.data as MeetingModel;
              return Slidable(
                endActionPane: ActionPane(
                  motion: const ScrollMotion(),
                  children: [
                    SlidableAction(
                      onPressed: (ctx) async {
                        await reffo.watch(attendanceProvider).changeAttendance(yoklama.id!, !yoklama.katildiMi!);
                      },
                      label: 'Değiştir',
                      backgroundColor: Colors.blue,
                      icon: Icons.change_circle,
                    ),
                  ],
                ),
                child: ListTile(
                  leading: Text((index + 1).toString()),
                  title: Text(meeting.name!),
                  subtitle: Text(meeting.dateTime!),
                  trailing: Text(
                    yoklama.katildiMi! ? "Katıldı" : "Katılmadı",
                    style: TextStyle(fontSize: 14, color: yoklama.katildiMi! ? Colors.green : Colors.red),
                  ),
                ),
              );
            });
      },
    );
  }
}
