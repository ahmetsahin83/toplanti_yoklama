class UserModel {
  int? id;
  String? createdAt;
  String? name;
  String? phone;
  String? uid;

  UserModel({this.id, this.createdAt, this.name, this.phone, this.uid});

  UserModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    createdAt = json['created_at'];
    name = json['name'];
    phone = json['phone'];
    uid = json['uid'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['created_at'] = createdAt;
    data['name'] = name;
    data['phone'] = phone;
    data['uid'] = uid;
    return data;
  }
}
