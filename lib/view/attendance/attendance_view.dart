import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';

import '../../controller/attendance_controller.dart';
import '../../model/user_model.dart';

class AttendanceView extends ConsumerWidget {
  const AttendanceView({super.key, required this.meetingId});

  final int meetingId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.read(attendanceProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Yoklama'),
      ),
      body: Center(
          child: FutureBuilder(
        future: controller.getUsers(meetingId),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const CircularProgressIndicator();
          } else {
            var data = snapshot.data as List<UserModel>;
            var list = List.generate(data.length, (index) => false);
            if (data.isEmpty) {
              return const Center(child: Text("Yoklama Alınacak Kişi Yok"));
            } else {}
            return ListView.separated(
                itemBuilder: (context, index) {
                  var user = data[index];
                  var katildiMi = list[index];
                  return Consumer(builder: (context, reff, _) {
                    return ListTile(
                      leading: Text((index + 1).toString()),
                      title: Text(user.name!),
                      trailing: SizedBox(
                        width: 100,
                        child: katildiMi
                            ? const Text("Yoklama Girildi")
                            : Row(
                                children: [
                                  IconButton(
                                    onPressed: () async {
                                      katildiMi = true;
                                      await reff.watch(attendanceProvider).newAttendance(user.id!, meetingId, true);
                                    },
                                    icon: const Icon(Icons.check),
                                  ),
                                  IconButton(
                                    onPressed: () async {
                                      katildiMi = true;
                                      await reff.watch(attendanceProvider).newAttendance(user.id!, meetingId, false);
                                    },
                                    icon: const Icon(Icons.close),
                                  ),
                                ],
                              ),
                      ),
                    );
                  });
                },
                separatorBuilder: (context, index) => const Divider(thickness: 1, height: 5),
                itemCount: data.length);
          }
        },
      )),
    );
  }
}
