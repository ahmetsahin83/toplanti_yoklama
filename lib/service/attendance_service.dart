import 'package:supabase_flutter/supabase_flutter.dart';

import '../model/attendance_model.dart';
import '../model/user_model.dart';
import '../utils/supabase_enum.dart';

class AttendanceService {
  final supabase = Supabase.instance.client;

  Future<List> getUsers(int meetingId) async {
    var allUsers = await supabase.from(SupabaseTables.users).select().then((value) => value.map((e) => UserModel.fromJson(e)).toList());
    allUsers = allUsers.cast<UserModel>();
    var yoklamaUsers = await supabase.from(SupabaseTables.attendance).select().eq("meeting_id", meetingId);
    var updatedUsers = allUsers.where((user) => !yoklamaUsers.any((yoklamaUser) => yoklamaUser["user_id"] == user.id)).toList();

    return updatedUsers.cast<UserModel>();
  }

  Stream<List<UserModel>> getUsersStream(int meetingId) async* {
    List<UserModel> allUsers = await supabase.from(SupabaseTables.users).select().then((value) => value.map((e) => UserModel.fromJson(e)).toList());
    allUsers = allUsers.cast<UserModel>();
    var yoklamaUsers = await supabase.from(SupabaseTables.attendance).select().eq("meeting_id", meetingId);
    if (yoklamaUsers.isEmpty) {
      yield allUsers.cast<UserModel>();
    } else {
      List<UserModel> updatedUsers = allUsers.where((user) => !yoklamaUsers.any((yoklamaUser) => yoklamaUser.id == user.id)).toList();
      yield updatedUsers;
    }
  }

  newAttendance(int userId, int meetingId, bool katildiMi) async {
    await supabase.from(SupabaseTables.attendance).insert([
      {"user_id": userId, "meeting_id": meetingId, "katildi_mi": katildiMi}
    ]);
  }

  getAttendance(int userId) async {
    var data =
        await supabase.from(SupabaseTables.attendance).select().eq("user_id", userId).then((value) => value.map((e) => AttendanceModel.fromJson(e)).toList());
    return data.cast<AttendanceModel>();
  }

  changeAttendance(int id, bool katildiMi) async {
    await supabase.from(SupabaseTables.attendance).update({"katildi_mi": katildiMi}).eq("id", id).execute();
  }

  Future<List<int>> getAttendanceCount(int userId) async {
    var katildi = await supabase
        .from(SupabaseTables.attendance)
        .select(
            "*",
            const FetchOptions(
              count: CountOption.exact,
            ))
        .eq("user_id", userId)
        .eq("katildi_mi", true)
        .execute();
    var katilmadi = await supabase
        .from(SupabaseTables.attendance)
        .select(
            "*",
            const FetchOptions(
              count: CountOption.exact,
            ))
        .eq("user_id", userId)
        .eq("katildi_mi", false)
        .execute();
    return [katildi.data.length, katilmadi.data.length];
  }

  getAttendanceByMeetingId(int id) async {
    var data =
        await supabase.from(SupabaseTables.attendance).select().eq("meeting_id", id).then((value) => value.map((e) => AttendanceModel.fromJson(e)).toList());
    return data.cast<AttendanceModel>();
  }
}
