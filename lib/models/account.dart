import 'package:flutter_demo/helpers/utils.dart';
import 'package:flutter_demo/models/role.dart';

import '../env.dart';

List<Role> listRole = [
  new Role(mo_ta: 'Giám đốc', name: 'god'),
  new Role(mo_ta: 'Trường phòng', name: 'admin'),
  new Role(mo_ta: 'Nhân viên', name: 'user'),
];

class Account {
  final int? id;
  final String? username;
  final String? name;
  final String? role;
  final String? imageurl;
  int? phongban_id;

  Account({
    this.id,
    this.username,
    this.name,
    this.role,
    this.phongban_id,
    this.imageurl,
  });

  factory Account.fromJson(Map<String, dynamic> json) {
    return Account(
      id: (json["id"] != null) ? int.parse(json["id"].toString()) : null,
      username: (json["username"] != null) ? json["username"].toString() : null,
      name: (json["name"] != null) ? json["name"].toString() : null,
      role: (json["role"] != null) ? json["role"].toString() : null,
      imageurl: (json["imageurl"] != null)
          ? '${hostUrl}${json["imageurl"].toString()}'
          : null,
      phongban_id: (json["phongban_id"] != null)
          ? int.parse(json["phongban_id"].toString())
          : null,
    );
  }

  static List<Account> fromJsonList(List list) {
    return list.map((item) => Account.fromJson(item)).toList();
  }

  ///this method will prevent the override of toString
  String userAsString() {
    return '#${this.id} ${this.name}';
  }

  ///custom comparing function to check if two users are equal
  bool isEqual(Account model) {
    return this.id == model.id;
  }

  bool filterByName(String filter) {
    return changeAlias(this.name!)
        .toLowerCase()
        .contains(changeAlias(filter).toLowerCase());
  }

  @override
  String toString() => '${this.name}';

  getRoleName() {
    var whereRole = listRole.where((element) => element.name == this.role);
    if (whereRole.isNotEmpty) {
      return whereRole.first.mo_ta;
    }
    return '';
  }
}
