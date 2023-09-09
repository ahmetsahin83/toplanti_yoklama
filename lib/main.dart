// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:firebase_core/firebase_core.dart';

import 'service/service_locator.dart';
import 'utils/router.dart';

main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  setupLocator();
  await Supabase.initialize(url: 'url', anonKey: 'ANON_KEY');

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routerConfig: router,
      title: 'Toplantı Takip Sistemi',
    );
  }
}

waitDialog(BuildContext context) {
  showDialog(barrierDismissible: true, context: context, builder: (context) => const Center(child: CircularProgressIndicator()));
}
