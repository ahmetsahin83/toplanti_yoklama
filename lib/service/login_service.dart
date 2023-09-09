import 'package:supabase_flutter/supabase_flutter.dart';

class LoginService {
  final supabase = Supabase.instance.client;
  login(String mail, String pass) async {
    try {
      await Supabase.instance.client.auth.signInWithPassword(email: mail, password: pass);
      return "başarılı";
    } catch (e) {
      return e.toString();
    }
  }
}
