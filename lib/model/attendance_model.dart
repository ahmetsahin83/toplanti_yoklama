class AttendanceModel {
  int? id;
  int? userId;
  int? meetingId;
  bool? katildiMi;

  AttendanceModel({this.id, this.userId, this.meetingId, this.katildiMi});

  AttendanceModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    meetingId = json['meeting_id'];
    katildiMi = json['isAttended'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['user_id'] = userId;
    data['meeting_id'] = meetingId;
    data['isAttended'] = katildiMi;
    return data;
  }
}
