import 'dart:convert';

import 'package:flutter/material.dart';

import '../env.dart';
import '../helpers/utils.dart';
import '../models/account.dart';
import 'package:http/http.dart' as http;

class UserController extends ChangeNotifier {
  Account? user;
  Future<Account?> setCurrentAccount() async {
    await Utils.initConfig();
    var url = Uri.parse(apiUrl + 'current_account.php');
    var response = await http.get(url, headers: Utils.buildHeaders());
    debugPrint('${response.statusCode}');
    debugPrint('${response.body}');
    if (response.statusCode == 200) {
      Map<String, dynamic> body = jsonDecode(response.body);

      if (body['success'] != null) {
        user = Account.fromJson(body['account']!);
        notifyListeners();
        return user;
      }
    }

    return null;
  }

  setAccount(Map<String, dynamic> jsonBody) async {
    user = Account.fromJson(jsonBody);
    notifyListeners();
  }
}
