import 'dart:convert';

import 'package:flutter_demo/helpers/utils.dart';

class Role {
  final String name;
  final String mo_ta;
  Role({
    this.mo_ta,
    this.name,
  });

  bool customerFilter(String filter) {
    return true;
  }

  @override
  String toString() => this.mo_ta;
}
