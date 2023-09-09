class MeetingModel {
  int? id;
  String? createdAt;
  String? dateTime;
  String? name;

  MeetingModel({this.id, this.createdAt, this.dateTime, this.name});

  factory MeetingModel.fromJson(Map<String, dynamic> json) {
    return MeetingModel(
      id: json['id'],
      createdAt: json['created_at'],
      dateTime: json['date_time'],
      name: json['name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'created_at': createdAt,
      'date_time': dateTime,
      'name': name,
    };
  }
}
