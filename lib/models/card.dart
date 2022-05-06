import 'dart:convert';

import 'package:flutter_demo/helpers/utils.dart';

class TrelloCard {
  final int id;
  final String title;
  String description = "";
  final List<String> labels;
  final Map<String, List<CheckBoxInfo>> checkLists;
  List<UserComment> comments;
  double newPrice = 0.0;

  TrelloCard(
      {this.id,
      this.title,
      this.description,
      this.labels,
      this.checkLists,
      this.comments});

  factory TrelloCard.fromJson(
      Map<String, dynamic> json, Map<String, dynamic> parentJson) {
    if (json == null) return null;
    return TrelloCard(
      id: (json["id"] != null) ? int.parse(json["id"].toString()) : null,
      title: (json["title"] != null) ? json["title"].toString() : null,
      description:
          (json["description"] != null) ? json["description"].toString() : null,
      labels:
          (json["labels"] != null) ? List<String>.from(json["labels"]) : null,
      checkLists: (json["checkLists"] != null) ? json["checkLists"] : null,
      comments: (json["comments"] != null) ? json["comments"] : null,
    );
  }

  static List<TrelloCard> fromJsonList(List list,
      {Map<String, dynamic> parentJson}) {
    if (list == null) return null;
    return list.map((item) => TrelloCard.fromJson(item, parentJson)).toList();
  }

  ///this method will prevent the override of toString
  String userAsString() {
    return '#${this.id} ${this.title}';
  }

  ///custom comparing function to check if two users are equal
  bool isEqual(TrelloCard model) {
    return this?.id == model?.id;
  }

  bool customerFilter(String filter) {
    return true;
  }

  @override
  String toString() {
    return '${this.title}';
  }
}

class UserComment {
  String user;
  String comment;
  String category;

  UserComment({
    this.user,
    this.comment,
    this.category
  });
}

class CheckBoxInfo {
  bool checked = false;
  String title;

  CheckBoxInfo({
    this.checked,
    this.title,
  });
}
