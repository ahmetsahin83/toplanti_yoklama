import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:go_router/go_router.dart';

import '../../controller/meeting_conroller.dart';
import '../../model/attendance_model.dart';
import '../../model/meeting_model.dart';

class MeetingView extends ConsumerWidget {
  const MeetingView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.read(meetingProvider);
    return Scaffold(
        appBar: AppBar(
          title: const Text('Toplantılar'),
          actions: [
            IconButton(
              onPressed: () {
                ref.watch(meetingProvider).newMeeting(context);
              },
              icon: const Icon(Icons.add),
            )
          ],
        ),
        body: FutureBuilder(
          future: controller.getMeetings(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            } else {
              List<MeetingModel> meetings = snapshot.data as List<MeetingModel>;
              meetings.sort((a, b) => b.id!.compareTo(a.id!));
              return ListView.separated(
                  itemCount: meetings.length,
                  separatorBuilder: (context, index) => const Divider(),
                  itemBuilder: (context, index) {
                    return Slidable(
                      endActionPane: ActionPane(
                        motion: const ScrollMotion(),
                        children: [
                          SlidableAction(
                            onPressed: (context) {
                              ref.watch(meetingProvider).deleteMeeting(meetings[index].id!);
                            },
                            label: 'Sil',
                            backgroundColor: Colors.red,
                            icon: Icons.delete,
                          ),
                          SlidableAction(
                            onPressed: (ctx) {
                              context.goNamed(
                                'attendance',
                                extra: meetings[index].id,
                              );
                            },
                            label: 'Yoklama Al',
                            backgroundColor: Colors.yellow,
                            icon: Icons.check,
                          ),
                        ],
                      ),
                      child: ListTile(
                        leading: Text((index + 1).toString()),
                        title: Text(meetings[index].name!),
                        subtitle: Text(meetings[index].dateTime!),
                        onTap: () {
                          showModalBottomSheet(
                              context: context,
                              builder: (ccc) {
                                return SizedBox(
                                  height: 400,
                                  child: FutureBuilder(
                                    future: controller.getAttendanceByMeetingId(meetings[index].id!),
                                    builder: (context, snapshot) {
                                      if (!snapshot.hasData) {
                                        return const Center(child: CircularProgressIndicator());
                                      } else {
                                        var data = snapshot.data as List<AttendanceModel>;
                                        return Column(
                                          children: [
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Row(
                                                  children: [
                                                    const Icon(
                                                      Icons.person,
                                                      color: Colors.green,
                                                    ),
                                                    Text(data.where((element) => element.katildiMi!).length.toString()),
                                                    const Icon(
                                                      Icons.person,
                                                      color: Colors.red,
                                                    ),
                                                    Text(data.where((element) => !element.katildiMi!).length.toString()),
                                                  ],
                                                ),
                                                Text(
                                                  meetings[index].name!,
                                                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                                                ),
                                                TextButton(
                                                    onPressed: () {
                                                      ccc.pop();
                                                    },
                                                    child: const Text("Kapat"))
                                              ],
                                            ),
                                            Expanded(
                                              child: ListView.separated(
                                                  shrinkWrap: true,
                                                  itemCount: data.length,
                                                  separatorBuilder: (context, index) => const Divider(),
                                                  itemBuilder: (context, index) {
                                                    return ListTile(
                                                      leading: Text((index + 1).toString()),
                                                      title: Text(controller.userList.firstWhere((element) => element.id == data[index].userId).name!),
                                                      trailing: Text(
                                                        data[index].katildiMi! ? "Katıldı" : "Katılmadı",
                                                        style: TextStyle(
                                                          fontSize: 14,
                                                          color: data[index].katildiMi! ? Colors.green : Colors.red,
                                                        ),
                                                      ),
                                                    );
                                                  }),
                                            ),
                                          ],
                                        );
                                      }
                                    },
                                  ),
                                );
                              });
                        },
                      ),
                    );
                  });
            }
          },
        ));
  }
}
