import 'dart:convert';

import 'package:flutter_demo/helpers/utils.dart';

class Absent {
//   {
//     "id": 2,
//     "reason": "abcxyz",
//     "attachment": "[\"uploads\\/-1668571025-bunipanelLeft.BackgroundImage.png\"]",
//     "status": 0,
//     "countdate": 1,
//     "time": "2022-11-16 11:57:07",
//     "register_id": 5,
//     "register_name": "vinh gmai com"
// }
  final int id;
  final String reason;
  final List<String> attachment;
  final String register_name;
  final int register_id;
  final int countdate;
  final int status;
  final String time;

  Absent({
    required this.id,
    required this.reason,
    required this.attachment,
    required this.register_name,
    required this.register_id,
    required this.countdate,
    required this.status,
    required this.time,
  });

  factory Absent.fromJson(Map<String, dynamic> json) {
    return Absent(
      id: (json["id"] != null) ? int.parse(json["id"].toString()) : 0,
      reason: (json["reason"] != null) ? json["reason"].toString() : '',
      attachment: (json["attachment"] != null)
          ? jsonDecode(json["attachment"].toString())
          : [],
      register_name: (json["register_name"] != null)
          ? json["register_name"].toString()
          : '',
      register_id: (json["register_id"] != null)
          ? int.parse(json["register_id"].toString())
          : 0,
      countdate: (json["countdate"] != null)
          ? int.parse(json["countdate"].toString())
          : 0,
      status:
          (json["status"] != null) ? int.parse(json["status"].toString()) : -1,
      time: (json["time"] != null) ? json["time"].toString() : 'null',
    );
  }

  static List<Absent> fromJsonList(List list) {
    return list.map((item) => Absent.fromJson(item)).toList();
  }

  ///custom comparing function to check if two users are equal
  bool isEqual(Absent model) {
    return this.id == model.id;
  }
}
