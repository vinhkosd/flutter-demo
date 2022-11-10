import 'dart:convert';

import 'package:flutter_demo/helpers/utils.dart';

class PhongBan {
  final int id;
  final String ten;
  PhongBan({
    this.id,
    this.ten,
  });

  factory PhongBan.fromJson(Map<String, dynamic> json) {
    if (json == null) return null;
    return PhongBan(
      id: int.parse(json["id"].toString()),
      ten: json["ten"].toString(),
    );
  }

  static List<PhongBan> fromJsonList(List list) {
    if (list == null) return null;
    return list.map((item) => PhongBan.fromJson(item)).toList();
  }

  ///this method will prevent the override of toString
  String userAsString() {
    return '#${this.id} ${this.ten}';
  }

  ///custom comparing function to check if two users are equal
  bool isEqual(PhongBan model) {
    return this?.id == model?.id;
  }

  bool customerFilter(String filter) {
    return true;
  }

  @override
  String toString() => this.ten;
}
