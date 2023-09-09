// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:go_router/go_router.dart';

import '../../controller/attendance_controller.dart';
import '../../controller/main_controller.dart';
import '../../controller/meeting_conroller.dart';
import '../../main.dart';
import '../../model/attendance_model.dart';
import '../../model/user_model.dart';
import 'widgets/attendance_list_tile.dart';

class Home extends ConsumerWidget {
  const Home({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.read(mainProvider);
    return Scaffold(
        // drawer: const _Drawer(),
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              context.goNamed("meeting");
            },
            icon: const Icon(Icons.meeting_room),
          ),
          title: const Text('Kişiler'),
          actions: [
            IconButton(
              onPressed: () async {
                showDialog(
                  context: context,
                  builder: (ctx) {
                    return AlertDialog(
                      title: const Text("Yeni Kişi Ekle"),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          TextField(
                            controller: controller.newUserName,
                            decoration: const InputDecoration(
                              labelText: "İsim",
                            ),
                          ),
                          TextField(
                            controller: controller.newUserPhone,
                            decoration: const InputDecoration(
                              labelText: "Telefon",
                            ),
                          ),
                        ],
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(ctx);
                          },
                          child: const Text("İptal"),
                        ),
                        TextButton(
                          onPressed: () async {
                            waitDialog(context);
                            await ref.watch(mainProvider).newUser();
                            Navigator.pop(context);
                            Navigator.pop(ctx);
                          },
                          child: const Text("Ekle"),
                        ),
                      ],
                    );
                  },
                );
                controller.newUserName.clear();
                controller.newUserPhone.clear();
              },
              icon: const Icon(Icons.add),
            )
          ],
        ),
        body: FutureBuilder(
          future: controller.getUsers(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            } else {
              List<UserModel> users = snapshot.data as List<UserModel>;
              users.sort((a, b) => a.name!.compareTo(b.name!));
              ref.read(meetingProvider).userList = users;
              return Consumer(
                builder: (_, WidgetRef ref, __) {
                  return Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: controller.searchController,
                                decoration: InputDecoration(
                                    hintText: "Ara",
                                    prefixIcon: const Icon(Icons.search),
                                    border: const OutlineInputBorder(),
                                    contentPadding: const EdgeInsets.all(0),
                                    suffix: IconButton(
                                        onPressed: () {
                                          controller.searchController.clear();
                                          users = snapshot.data!
                                              .where((element) => element.name!.toLowerCase().contains(controller.searchController.text))
                                              .toList();
                                          ref.watch(mainProvider).update();
                                        },
                                        icon: const Icon(Icons.clear))),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 8),
                              child: ElevatedButton(
                                  onPressed: () {
                                    users = snapshot.data!.where((element) => element.name!.toLowerCase().contains(controller.searchController.text)).toList();
                                    ref.watch(mainProvider).update();
                                  },
                                  child: const Text("Ara")),
                            )
                          ],
                        ),
                      ),
                      Expanded(
                        child: ListView.separated(
                            shrinkWrap: true,
                            itemCount: users.length,
                            separatorBuilder: (context, index) => const Divider(
                                  thickness: 1,
                                  color: Colors.black,
                                  height: 0,
                                ),
                            itemBuilder: (context, index) {
                              final UserModel user = users[index];
                              return Slidable(
                                endActionPane: ActionPane(
                                  motion: const ScrollMotion(),
                                  children: [
                                    SlidableAction(
                                      onPressed: (ctx) async {
                                        waitDialog(context);
                                        await ref.watch(mainProvider).deleteUser(user.id!);
                                        Navigator.pop(context);
                                      },
                                      label: 'Sil',
                                      backgroundColor: Colors.red,
                                      icon: Icons.delete,
                                    ),
                                    SlidableAction(
                                      onPressed: (ctx) async {
                                        controller.editedUserName.text = user.name!;
                                        controller.editedUserPhone.text = user.phone!;
                                        showDialog(
                                            context: context,
                                            builder: (ctx) {
                                              return AlertDialog(
                                                title: const Text("Kişi Düzenle"),
                                                content: Column(
                                                  mainAxisSize: MainAxisSize.min,
                                                  children: [
                                                    TextField(
                                                      controller: controller.editedUserName,
                                                      decoration: const InputDecoration(
                                                        labelText: "İsim",
                                                      ),
                                                    ),
                                                    TextField(
                                                      controller: controller.editedUserPhone,
                                                      decoration: const InputDecoration(
                                                        labelText: "Telefon",
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                actions: [
                                                  TextButton(
                                                    onPressed: () {
                                                      Navigator.pop(ctx);
                                                    },
                                                    child: const Text("İptal"),
                                                  ),
                                                  TextButton(
                                                    onPressed: () async {
                                                      waitDialog(context);
                                                      await ref
                                                          .watch(mainProvider)
                                                          .updateUser(user.id!, controller.editedUserName.text, controller.editedUserPhone.text);
                                                      Navigator.pop(context);
                                                      Navigator.pop(ctx);
                                                    },
                                                    child: const Text("Düzenle"),
                                                  ),
                                                ],
                                              );
                                            });
                                      },
                                      label: 'Düzenle',
                                      backgroundColor: Colors.blue,
                                      icon: Icons.edit,
                                    ),
                                  ],
                                ),
                                child: ListTile(
                                  onTap: () {
                                    showModalBottomSheet(
                                      context: context,
                                      builder: (ctx) {
                                        return Column(
                                          mainAxisSize: MainAxisSize.min,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.all(16.0),
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  FutureBuilder(
                                                    future: ref.read(attendanceProvider).getAttendanceCount(user.id!),
                                                    builder: (context, snapshot) {
                                                      if (!snapshot.hasData) {
                                                        return const Center(child: CircularProgressIndicator());
                                                      } else {
                                                        List<int> list = snapshot.data as List<int>;
                                                        return Row(
                                                          children: [
                                                            const Icon(
                                                              Icons.person,
                                                              color: Colors.green,
                                                            ),
                                                            Text(list[0].toString()),
                                                            const Icon(
                                                              Icons.person,
                                                              color: Colors.red,
                                                            ),
                                                            Text(list[1].toString()),
                                                          ],
                                                        );
                                                      }
                                                    },
                                                  ),
                                                  Text(user.name!),
                                                  TextButton(
                                                    onPressed: () {
                                                      Navigator.pop(ctx);
                                                    },
                                                    child: const Text("Kapat"),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            FutureBuilder(
                                              future: ref.read(attendanceProvider).getAttendance(user.id!),
                                              builder: (context, snapshot) {
                                                if (snapshot.connectionState == ConnectionState.waiting) {
                                                  return const Center(child: CircularProgressIndicator());
                                                } else if (snapshot.hasError) {
                                                  return Center(child: Text("Hata: ${snapshot.error}"));
                                                } else if (!snapshot.hasData) {
                                                  return const Center(child: Text("Veri bulunamadı"));
                                                } else {
                                                  List<AttendanceModel> yoklama = snapshot.data as List<AttendanceModel>;
                                                  yoklama.sort((a, b) => b.id!.compareTo(a.id!));
                                                  return Flexible(
                                                    child: ListView.builder(
                                                      itemCount: yoklama.length,
                                                      itemBuilder: (context, index) {
                                                        return AttendanceListTile(controller: controller, yoklama: yoklama[index], index: index);
                                                      },
                                                    ),
                                                  );
                                                }
                                              },
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  },
                                  leading: Text((index + 1).toString()),
                                  title: Text(user.name!),
                                  subtitle: Text(user.phone!),
                                  trailing: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      IconButton(
                                        onPressed: () async {
                                          await controller.callUser(user);
                                        },
                                        icon: const Icon(Icons.call),
                                      ),
                                      IconButton(
                                        onPressed: () async {
                                          await controller.sendMessage(user);
                                        },
                                        icon: const Icon(Icons.message),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }),
                      ),
                    ],
                  );
                },
              );
            }
          },
        ));
  }
}
