import 'dart:convert';

import 'package:flutter_demo/helpers/utils.dart';
import 'package:flutter_demo/models/unit.dart';

class Product {
  final int id;
  final int product_group_id;
  final String code;
  final String name;
  final String keyword;
  int unit_id;
  final int supplier_id;
  int price;
  final int supplier_price;
  final int status;
  final String created_at;
  final int created_by;
  final String updated_at;
  final int updated_by;
  final int image_id;
  final String description;
  int vat;
  final double quantity_original;
  String unit_name;
  final int unit_type;
  final int convert_factor;
  final int warehouse_id;
  final String warehouse_name;
  final List<Unit> unit_list;
  final int price_original;
  final int product_id;
  int count = 0;

  Product(
      {this.id,
      this.product_group_id,
      this.code,
      this.name,
      this.keyword,
      this.unit_id,
      this.supplier_id,
      this.price,
      this.supplier_price,
      this.status,
      this.created_at,
      this.created_by,
      this.updated_at,
      this.updated_by,
      this.image_id,
      this.description,
      this.vat,
      this.quantity_original,
      this.unit_name,
      this.unit_type,
      this.convert_factor,
      this.warehouse_id,
      this.warehouse_name,
      this.unit_list,
      this.price_original,
      this.product_id});

  factory Product.fromJson(Map<String, dynamic> json) {
    if (json == null) return null;
//     console.log(Object.keys(temp1).map(item => `${item}: (json["${item}"] != null) ? ${isNaN(temp1[item]) ? "": "int.parse("}json["${item}"].toString()${isNaN(temp1[item]) ? "": ")"} : null`).join(`,
// `))
    print(json["unit_list"].runtimeType);
    return Product(
        id: (json["id"] != null) ? int.parse(json["id"].toString()) : null,
        product_group_id: (json["product_group_id"] != null)
            ? int.parse(json["product_group_id"].toString())
            : null,
        code: (json["code"] != null) ? json["code"].toString() : null,
        name: (json["name"] != null) ? json["name"].toString() : null,
        keyword: (json["keyword"] != null) ? json["keyword"].toString() : null,
        unit_id: (json["unit_id"] != null)
            ? int.parse(json["unit_id"].toString())
            : null,
        supplier_id: (json["supplier_id"] != null)
            ? int.parse(json["supplier_id"].toString())
            : null,
        price: (json["price"] != null)
            ? int.parse(json["price"].toString())
            : null,
        supplier_price: (json["supplier_price"] != null)
            ? int.parse(json["supplier_price"].toString())
            : null,
        status: (json["status"] != null)
            ? int.parse(json["status"].toString())
            : null,
        created_at:
            (json["created_at"] != null) ? json["created_at"].toString() : null,
        created_by: (json["created_by"] != null)
            ? int.parse(json["created_by"].toString())
            : null,
        updated_at:
            (json["updated_at"] != null) ? json["updated_at"].toString() : null,
        updated_by: (json["updated_by"] != null)
            ? int.parse(json["updated_by"].toString())
            : null,
        image_id: (json["image_id"] != null)
            ? int.parse(json["image_id"].toString())
            : null,
        description: (json["description"] != null)
            ? json["description"].toString()
            : null,
        vat: (json["vat"] != null) ? int.parse(json["vat"].toString()) : null,
        quantity_original: (json["quantity_original"] != null)
            ? double.parse(json["quantity_original"].toString())
            : null,
        unit_name:
            (json["unit_name"] != null) ? json["unit_name"].toString() : null,
        unit_type: (json["unit_type"] != null)
            ? int.parse(json["unit_type"].toString())
            : null,
        convert_factor: (json["convert_factor"] != null)
            ? int.parse(json["convert_factor"].toString())
            : null,
        warehouse_id: (json["warehouse_id"] != null)
            ? int.parse(json["warehouse_id"].toString())
            : null,
        warehouse_name: (json["warehouse_name"] != null)
            ? json["warehouse_name"].toString()
            : null,
        unit_list: (json["unit_list"] != null)
            ? Unit.fromJsonList(json["unit_list"], parentJson: json)
            : [],
        price_original: (json["price_original"] != null)
            ? int.parse(json["price_original"].toString())
            : null,
        product_id: (json["product_id"] != null)
            ? int.parse(json["product_id"].toString())
            : null);
  }

  static List<Product> fromJsonList(List list) {
    if (list == null) return null;
    return list.map((item) => Product.fromJson(item)).toList();
  }

  ///this method will prevent the override of toString
  String userAsString() {
    return '#${this.id} ${this.name}';
  }

  ///custom comparing function to check if two users are equal
  bool isEqual(Product model) {
    return this?.id == model?.id;
  }

  bool filterByName(String filter) {
    return changeAlias(this.name)
        .toLowerCase()
        .contains(changeAlias(filter).toLowerCase());
  }

  @override
  String toString() => '${this.name}';

  String toJson() {
    Map<String, dynamic> customer = {
      "id": id,
      "product_group_id": product_group_id,
      "code": code,
      "name": name,
      "keyword": keyword,
      "unit_id": unit_id,
      "supplier_id": supplier_id,
      "price": price,
      "supplier_price": supplier_price,
      "status": status,
      "created_at": created_at,
      "created_by": created_by,
      "updated_at": updated_at,
      "updated_by": updated_by,
      "image_id": image_id,
      "description": description,
      "vat": vat,
      "quantity_original": quantity_original,
      "unit_name": unit_name,
      "unit_type": unit_type,
      "convert_factor": convert_factor,
      "warehouse_id": warehouse_id,
      "warehouse_name": warehouse_name,
      "unit_list": unit_list,
      "price_original": price_original,
      "product_id": product_id
    };
    return jsonEncode(customer);
  }

  Map<String, dynamic> toArray() {
    Map<String, dynamic> customer = {
      "id": id,
      "product_group_id": product_group_id,
      "code": code,
      "name": name,
      "keyword": keyword,
      "unit_id": unit_id,
      "supplier_id": supplier_id,
      "price": price,
      "supplier_price": supplier_price,
      "status": status,
      "created_at": created_at,
      "created_by": created_by,
      "updated_at": updated_at,
      "updated_by": updated_by,
      "image_id": image_id,
      "description": description,
      "vat": vat,
      "quantity_original": quantity_original,
      "unit_name": unit_name,
      "unit_type": unit_type,
      "convert_factor": convert_factor,
      "warehouse_id": warehouse_id,
      "warehouse_name": warehouse_name,
      "unit_list": unit_list,
      "price_original": price_original,
      "product_id": product_id
    };
    return customer;
  }

  // String getAddress() {
  //   String add = address.toString();

  //   if (isJson(address.toString())) {
  //     Map<String, dynamic> obj = jsonDecode(address);
  //     add = [
  //       obj["address"],
  //       obj["ward_name"],
  //       obj["district_name"],
  //       obj["province_name"]
  //     ].where((a) => a != null).join(', ');
  //   }
  //   return add;
  // }
}
