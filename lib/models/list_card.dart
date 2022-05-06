import 'dart:convert';

import 'package:flutter_demo/helpers/utils.dart';

import 'card.dart';

class ListCard {
  final int id;
  final String title;
  final String thumbImg;
  final List<TrelloCard> cards;
//   console.log(Object.keys(temp1).map(item => `final ${isNaN(temp1[item]) ? "String": "int"} ${item}`).join(`;
// `))
  ListCard(
      {this.id,
      this.title,
      this.thumbImg,
      this.cards,});

  factory ListCard.fromJson(
      Map<String, dynamic> json, Map<String, dynamic> parentJson) {
    if (json == null) return null;
    return ListCard(
      id: (json["id"] != null)
          ? int.parse(json["id"].toString())
          : null,
      title:
          (json["title"] != null) ? json["title"].toString() : null,
      thumbImg: (json["thumb_img"] != null)
          ? json["thumb_img"].toString()
          : null,
      cards: (json["cards"] != null)
          ? TrelloCard.fromJsonList(json["cards"])
          : null,
    );
  }

  static List<ListCard> fromJsonList(List list, {Map<String, dynamic> parentJson}) {
    if (list == null) return null;
    return list.map((item) => ListCard.fromJson(item, parentJson)).toList();
  }

  ///this method will prevent the override of toString
  String userAsString() {
    return '#${this.id} ${this.title}';
  }

  ///custom comparing function to check if two users are equal
  bool isEqual(ListCard model) {
    return this?.id == model?.id;
  }

  bool customerFilter(String filter) {
    return true;
  }

  @override
  String toString() {
    return '${this.title}';
  }

  String toJson() {
//     console.log(Object.keys(temp1).map(item => `"${item}": ${item}`).join(`,
// `))
    Map<String, dynamic> customer = {
      "id": id,
      "title": title,
      "thumb_img": thumbImg,
      "cards": cards,
    };
    return jsonEncode(customer);
  }

  Map<String, dynamic> toArray() {
    Map<String, dynamic> customer = {
      "id": id,
      "title": title,
      "thumb_img": thumbImg,
      "cards": cards,
    };
    return customer;
  }
}
