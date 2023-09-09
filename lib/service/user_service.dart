import 'package:supabase_flutter/supabase_flutter.dart';

import '../model/user_model.dart';
import '../utils/supabase_enum.dart';

class UserService {
  final supabase = Supabase.instance.client;

  Future<List<UserModel>> getUsers() async {
    final data = await supabase.from(SupabaseTables.users).select().then((value) => value.map((e) => UserModel.fromJson(e)).toList());
    //datayı usermodel listesi olarak return etme
    return data.cast<UserModel>();
  }

  newUser(String name, String phone) async {
    await supabase.from(SupabaseTables.users).insert([
      {"name": name, "phone": phone}
    ]);
  }

  deleteUser(int id) async {
    await supabase.from(SupabaseTables.users).delete().eq("id", id).execute();
    await supabase.from(SupabaseTables.attendance).delete().eq("user_id", id).execute();
    await supabase.from(SupabaseTables.meetings).delete().eq("user_id", id).execute();
  }

  updateUser(int id, String name, String phone) async {
    await supabase.from(SupabaseTables.users).update({"name": name, "phone": phone}).match({"id": id}).execute();
  }
}
