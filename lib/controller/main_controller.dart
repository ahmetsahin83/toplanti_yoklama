import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../model/user_model.dart';
import '../service/meeting_service.dart';
import '../service/user_service.dart';

final mainProvider = ChangeNotifierProvider((ref) => MainController());

class MainController extends ChangeNotifier {
  MainController() {
    _userService = UserService();
    _meetingService = MeetingService();
  }
  late final UserService _userService;
  late final MeetingService _meetingService;
  final newUserName = TextEditingController();
  final newUserPhone = TextEditingController();
  final editedUserName = TextEditingController();
  final editedUserPhone = TextEditingController();
  final searchController = TextEditingController();
  Future<List<UserModel>> getUsers() async {
    return await _userService.getUsers();
  }

  newUser() async {
    await _userService.newUser(newUserName.text, newUserPhone.text);
    notifyListeners();
  }

  deleteUser(int id) async {
    await _userService.deleteUser(id);
    notifyListeners();
  }

  updateUser(int id, String name, String phone) async {
    await _userService.updateUser(id, name, phone);
    notifyListeners();
  }

  getMeetingById(int id) async {
    return await _meetingService.getMeetingsById(id);
  }

  sendMessage(user) async {
    String tel = user.phone!.replaceAll(' ', '');
    if (tel.startsWith('0')) {
      tel = "9$tel";
    } else if (tel.startsWith("5")) {
      tel = "90$tel";
    }
    await launchUrlString("https://wa.me/$tel", mode: LaunchMode.externalApplication);
  }

  callUser(user) async {
    String tel = user.phone!.replaceAll(' ', '');
    if (tel.startsWith('0')) {
      tel = "+9$tel";
    } else if (tel.startsWith("5")) {
      tel = "+90$tel";
      tel.replaceFirst("5", "+905");
    }

    final Uri telLaunchUri = Uri(
      scheme: 'tel',
      path: tel,
    );
    await launchUrl(telLaunchUri);
  }

  update() {
    notifyListeners();
  }
}
