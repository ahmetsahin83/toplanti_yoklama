// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../main.dart';
import '../service/login_service.dart';
import '../service/service_locator.dart';

final loginProvider = ChangeNotifierProvider((ref) => LoginController());

class LoginController extends ChangeNotifier {
  LoginController() {
    _loginService = getIt<LoginService>();
  }
  final mail = TextEditingController();
  final pass = TextEditingController();
  final formKey = GlobalKey<FormState>();
  late final LoginService _loginService;

  login(String mail, String pass, BuildContext context) async {
    if (formKey.currentState!.validate()) {
      waitDialog(context);
      final result = await _loginService.login(mail, pass);
      if (result == "başarılı") {
        context.go("/home");
      } else {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(result)));
      }
    }
  }
}
