import 'dart:convert';

import 'package:flutter_demo/helpers/utils.dart';
import 'package:flutter_demo/models/unit.dart';

class Account {
  final int id;
  final String username;
  final String name;
  final String role;
  int phongban_id;

  Account({
    this.id,
    this.username,
    this.name,
    this.role,
    this.phongban_id,
  });

  factory Account.fromJson(Map<String, dynamic> json) {
    if (json == null) return null;
    return Account(
      id: (json["id"] != null) ? int.parse(json["id"].toString()) : null,
      username: (json["username"] != null) ? json["username"].toString() : null,
      name: (json["name"] != null) ? json["name"].toString() : null,
      role: (json["role"] != null) ? json["role"].toString() : null,
      phongban_id: (json["phongban_id"] != null)
          ? int.parse(json["phongban_id"].toString())
          : null,
    );
  }

  static List<Account> fromJsonList(List list) {
    if (list == null) return null;
    return list.map((item) => Account.fromJson(item)).toList();
  }

  ///this method will prevent the override of toString
  String userAsString() {
    return '#${this.id} ${this.name}';
  }

  ///custom comparing function to check if two users are equal
  bool isEqual(Account model) {
    return this?.id == model?.id;
  }

  bool filterByName(String filter) {
    return changeAlias(this.name)
        .toLowerCase()
        .contains(changeAlias(filter).toLowerCase());
  }

  @override
  String toString() => '${this.name}';
}
