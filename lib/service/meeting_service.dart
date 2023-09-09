import '../utils/extensions.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../model/meeting_model.dart';
import '../utils/supabase_enum.dart';

class MeetingService {
  final supabase = Supabase.instance.client;

  Future<String> newMeeting(String name, String dateTime) async {
    if (name.isEmpty) {
      return "Lütfen tüm alanları doldurunuz.";
    }
    if (dateTime.isEmpty) {
      dateTime = DateTime.now().toShortString;
    }
    final data = await supabase.from(SupabaseTables.meetings).select().match({"date_time": dateTime, "name": name});
    if (!data.isEmpty) {
      return "Aynı isim ve tarihte bir kayıt mevcut!";
    } else {
      await supabase.from(SupabaseTables.meetings).insert([
        {"date_time": dateTime, "name": name}
      ]);
      return "Toplantı başarıyla oluşturuldu.";
    }
  }

  Future<List<MeetingModel>> getMeetings() async {
    final data = await supabase.from(SupabaseTables.meetings).select().then((value) => value.map((e) => MeetingModel.fromJson(e)).toList());
    return data.cast<MeetingModel>();
  }

  Future<MeetingModel> getMeetingsById(int id) async {
    var response = await supabase.from(SupabaseTables.meetings).select().eq("id", id).execute();

    var data = response.data as List<dynamic>;
    var meetings = data.map((e) => MeetingModel.fromJson(e as Map<String, dynamic>)).toList();

    return meetings.first;
  }

  deleteMeeting(int id) async {
    await supabase.from(SupabaseTables.meetings).delete().eq("id", id).execute();
    await supabase.from(SupabaseTables.attendance).delete().eq("meeting_id", id).execute();
  }
}
