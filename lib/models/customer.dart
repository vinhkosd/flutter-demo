import 'dart:convert';

import 'package:flutter_demo/helpers/utils.dart';

class Customer {
  final String address;
  final String contacts;
  final int e_wallet;
  final int exemption_wallet;
  final int id;
  final String mobile_phone_number;
  final String name;
  final String phone_number;
  final String tax_code;
  final int type;

  Customer(
      {this.address,
      this.contacts,
      this.e_wallet,
      this.exemption_wallet,
      this.id,
      this.mobile_phone_number,
      this.name,
      this.phone_number,
      this.tax_code,
      this.type});

  factory Customer.fromJson(Map<String, dynamic> json) {
    if (json == null) return null;
    return Customer(
      address: json["address"].toString(),
      contacts: json["contacts"].toString(),
      e_wallet: int.parse(json["e_wallet"].toString()),
      exemption_wallet: int.parse(json["exemption_wallet"].toString()),
      id: int.parse(json["id"].toString()),
      mobile_phone_number: json["mobile_phone_number"].toString(),
      name: json["name"].toString(),
      phone_number: json["phone_number"].toString(),
      tax_code: json["tax_code"].toString(),
      type: int.parse(json["type"].toString()),
    );
  }

  static List<Customer> fromJsonList(List list) {
    if (list == null) return null;
    return list.map((item) => Customer.fromJson(item)).toList();
  }

  ///this method will prevent the override of toString
  String userAsString() {
    return '#${this.id} ${this.name}';
  }

  ///custom comparing function to check if two users are equal
  bool isEqual(Customer model) {
    return this?.id == model?.id;
  }

  bool customerFilter(String filter) {
    return true;
  }

  @override
  String toString() => name;

  String toJson() {
    Map<String, dynamic> customer = {
      "address": address,
      "contacts": contacts,
      "e_wallet": e_wallet,
      "id": id,
      "mobile_phone_number": mobile_phone_number,
      "name": name,
      "phone_number": phone_number,
      "tax_code": tax_code,
      "type": type
    };
    return jsonEncode(customer);
  }

  Map<String, dynamic> toArray() {
    Map<String, dynamic> customer = {
      "address": address,
      "contacts": contacts,
      "e_wallet": e_wallet,
      "id": id,
      "mobile_phone_number": mobile_phone_number,
      "name": name,
      "phone_number": phone_number,
      "tax_code": tax_code,
      "type": type
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
