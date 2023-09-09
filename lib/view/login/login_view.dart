import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';

import '../../controller/login_controller.dart';

class LoginView extends ConsumerWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(loginProvider);
    return Scaffold(
        appBar: AppBar(
          title: const Text("Giriş Yap!"),
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Form(
              key: controller.formKey,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "TOPLANTI TAKİP SİSTEMİ",
                      style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 60),
                    TextFormField(
                      controller: controller.mail,
                      decoration: const InputDecoration(labelText: "Mail", border: OutlineInputBorder()),
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: controller.pass,
                      decoration: const InputDecoration(labelText: "Şifre", border: OutlineInputBorder()),
                      obscureText: true,
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      height: 40,
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () async {
                          await controller.login(controller.mail.text, controller.pass.text, context);
                        },
                        child: const Text("Giriş Yap"),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ));
  }
}
