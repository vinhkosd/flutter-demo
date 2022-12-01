import 'dart:convert';

class Task {
//  {
//         "id": 1,
//         "ten": "Di bung nuoc",
//         "mo_ta": "Di bung nuoc duoi tang 2",
//         "status": 5,
//         "attachment": "[]",
//         "time": "2022-11-08 11:13:00",
//         "owner_id": 2,
//         "assign_id": 3,
//         "complete_level": null,
//         "owner": null,
//         "assign": null
//     },
  final int id;
  final String ten;
  final String mo_ta;
  final int status;
  final List<dynamic> attachment;
  final String time;
  final int owner_id;
  final int assign_id;
  final int? complete_level;
  final String owner;
  final String assign;

  Task({
    required this.id,
    required this.ten,
    required this.attachment,
    required this.mo_ta,
    required this.owner_id,
    required this.status,
    required this.time,
    required this.assign_id,
    this.complete_level,
    required this.owner,
    required this.assign,
  });

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: (json["id"] != null) ? int.parse(json["id"].toString()) : 0,
      ten: (json["ten"] != null) ? json["ten"].toString() : '',
      attachment: (json["attachment"] != null)
          ? jsonDecode(json["attachment"].toString())
          : [],
      mo_ta: (json["mo_ta"] != null) ? json["mo_ta"].toString() : '',
      owner_id: (json["owner_id"] != null)
          ? int.parse(json["owner_id"].toString())
          : 0,
      status:
          (json["status"] != null) ? int.parse(json["status"].toString()) : -1,
      time: (json["time"] != null) ? json["time"].toString() : 'null',
      assign: (json["assign"] != null) ? json["assign"].toString() : '',
      assign_id: (json["assign_id"] != null)
          ? int.parse(json["assign_id"].toString())
          : 0,
      complete_level: (json["complete_level"] != null)
          ? int.parse(json["complete_level"].toString())
          : 0,
      owner: (json["owner"] != null) ? json["owner"].toString() : '',
    );
  }

  static List<Task> fromJsonList(List list) {
    return list.map((item) => Task.fromJson(item)).toList();
  }
}
