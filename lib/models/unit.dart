import 'dart:convert';

import 'package:flutter_demo/helpers/utils.dart';

class Unit {
  final int unit_id;
  final String unit_name;
  final int unit_type;
  final double convert_factor;
  final int product_id;
  final int price_original;
  final Map<String, dynamic> parentJson;
  double newPrice = 0.0;
//   console.log(Object.keys(temp1).map(item => `final ${isNaN(temp1[item]) ? "String": "int"} ${item}`).join(`;
// `))
  Unit(
      {this.unit_id,
      this.unit_name,
      this.unit_type,
      this.convert_factor,
      this.product_id,
      this.price_original,
      this.parentJson});

  factory Unit.fromJson(
      Map<String, dynamic> json, Map<String, dynamic> parentJson) {
    if (json == null) return null;
    return Unit(
      unit_id: (json["unit_id"] != null)
          ? int.parse(json["unit_id"].toString())
          : null,
      unit_name:
          (json["unit_name"] != null) ? json["unit_name"].toString() : null,
      unit_type: (json["unit_type"] != null)
          ? int.parse(json["unit_type"].toString())
          : null,
      convert_factor: (json["convert_factor"] != null)
          ? double.parse(json["convert_factor"].toString())
          : null,
      product_id: (json["product_id"] != null)
          ? int.parse(json["product_id"].toString())
          : null,
      price_original:
          (parentJson != null && parentJson["price_original"] != null)
              ? int.parse(parentJson["price_original"].toString())
              : 0,
      parentJson: (parentJson != null) ? parentJson : null,
    );
  }

  static List<Unit> fromJsonList(List list, {Map<String, dynamic> parentJson}) {
    if (list == null) return null;
    return list.map((item) => Unit.fromJson(item, parentJson)).toList();
  }

  ///this method will prevent the override of toString
  String userAsString() {
    return '#${this.unit_id} ${this.unit_name}';
  }

  ///custom comparing function to check if two users are equal
  bool isEqual(Unit model) {
    return this?.unit_id == model?.unit_id;
  }

  bool customerFilter(String filter) {
    return true;
  }

  @override
  String toString() {
    newPrice = 0;

    if (this.unit_type == 0) {
      // newQuantity = newQuantity * parseInt(find.convert_factor, 10);
      newPrice = this.price_original / this.convert_factor;
    } else if (this.unit_type == 1 || this.unit_type == null) {
      // newQuantity = newQuantity / parseInt(find.convert_factor, 10);
      newPrice = (this.price_original * this.convert_factor).toDouble();
    }
    return '${this.unit_name} - $newPrice VNĐ';
  }

  String toJson() {
//     console.log(Object.keys(temp1).map(item => `"${item}": ${item}`).join(`,
// `))
    Map<String, dynamic> customer = {
      "unit_id": unit_id,
      "unit_name": unit_name,
      "unit_type": unit_type,
      "convert_factor": convert_factor,
      "product_id": product_id
    };
    return jsonEncode(customer);
  }

  Map<String, dynamic> toArray() {
    Map<String, dynamic> customer = {
      "unit_id": unit_id,
      "unit_name": unit_name,
      "unit_type": unit_type,
      "convert_factor": convert_factor,
      "product_id": product_id
    };
    return customer;
  }
}
