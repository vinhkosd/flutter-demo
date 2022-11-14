import 'dart:convert';

import 'package:flutter_demo/helpers/utils.dart';

class PhongBan {
  final int id;
  final String ten;
  final String mo_ta;
  final int so_phong;
  final int manager_id;
  final String name;
  PhongBan({
    this.id,
    this.ten,
    this.mo_ta,
    this.so_phong,
    this.manager_id,
    this.name,
  });

  factory PhongBan.fromJson(Map<String, dynamic> json) {
    if (json == null) return null;
    return PhongBan(
      id: (json["id"] != null) ? int.parse(json["id"].toString()) : 0,
      ten: (json["ten"] != null) ? json["ten"].toString() : '',
      mo_ta: (json["mo_ta"] != null) ? json["mo_ta"].toString() : '',
      so_phong: (json["so_phong"] != null)
          ? int.parse(json["so_phong"].toString())
          : 0,
      manager_id: (json["manager_id"] != null)
          ? int.parse(json["manager_id"].toString())
          : 0,
      name: (json["name"] != null) ? json["name"].toString() : '',
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
