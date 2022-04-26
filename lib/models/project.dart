import 'dart:convert';

import 'package:flutter_demo/helpers/utils.dart';

class Project {
  final int id;
  final String name;
  final int customer_id;
  final int total_amount;
  final int total_amount_paid;
  final int status;
  final String address;
  final String note;
  final int created_by;
  final int updated_by;
  final String created_at;
  final String updated_at;
  Project(
      {this.id,
      this.name,
      this.customer_id,
      this.total_amount,
      this.total_amount_paid,
      this.status,
      this.address,
      this.note,
      this.created_by,
      this.updated_by,
      this.created_at,
      this.updated_at});

  factory Project.fromJson(Map<String, dynamic> json) {
    if (json == null) return null;
    return Project(
      id: int.parse(json["id"].toString()),
      name: json["name"].toString(),
      customer_id: int.parse(json["customer_id"].toString()),
      total_amount: int.parse(json["total_amount"].toString()),
      total_amount_paid: int.parse(json["total_amount_paid"].toString()),
      status: int.parse(json["status"].toString()),
      address: json["address"].toString(),
      note: json["note"].toString(),
      created_by: int.parse(json["created_by"].toString()),
      updated_by: int.parse(json["updated_by"].toString()),
      created_at: json["created_at"].toString(),
      updated_at: json["updated_at"].toString(),
    );
  }

  static List<Project> fromJsonList(List list) {
    if (list == null) return null;
    return list.map((item) => Project.fromJson(item)).toList();
  }

  ///this method will prevent the override of toString
  String userAsString() {
    return '#${this.id} ${this.name}';
  }

  ///custom comparing function to check if two users are equal
  bool isEqual(Project model) {
    return this?.id == model?.id;
  }

  bool customerFilter(String filter) {
    return true;
  }

  @override
  String toString() => '${this.name} - DA${formatId(this.id.toString())}';

  String toJson() {
    Map<String, dynamic> customer = {
      "id": id,
      "name": name,
      "customer_id": customer_id,
      "total_amount": total_amount,
      "total_amount_paid": total_amount_paid,
      "status": status,
      "address": address,
      "note": note,
      "created_by": created_by,
      "updated_by": updated_by,
      "created_at": created_at,
      "updated_at": updated_at
    };
    return jsonEncode(customer);
  }

  Map<String, dynamic> toArray() {
    Map<String, dynamic> customer = {
      "id": id,
      "name": name,
      "customer_id": customer_id,
      "total_amount": total_amount,
      "total_amount_paid": total_amount_paid,
      "status": status,
      "address": address,
      "note": note,
      "created_by": created_by,
      "updated_by": updated_by,
      "created_at": created_at,
      "updated_at": updated_at
    };
    return customer;
  }

  String getAddress() {
    String add = address.toString();

    if (isJson(address.toString())) {
      Map<String, dynamic> obj = jsonDecode(address);
      add = [
        obj["address"],
        obj["ward_name"],
        obj["district_name"],
        obj["province_name"]
      ].where((a) => a != null).join(', ');
    }
    return add;
  }
}
