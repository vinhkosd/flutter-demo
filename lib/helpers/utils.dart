import 'dart:math';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import 'package:flutter/services.dart' show rootBundle;
import 'package:localstorage/localstorage.dart';
import 'package:rive/rive.dart';

class Utils {
  static String apiUrl;
  static Map<String, dynamic> config;
  static bool appInit = false;
  static Future<bool> initConfig() async {
    if (!appInit) {
      await Future.delayed(Duration(milliseconds: 2000));
    }

    if (apiUrl == null) {
      config = jsonDecode(await rootBundle.loadString('assets/config.json'));
      apiUrl = config["apiUrl"];
      appInit = true;
    }

    return appInit;
  }

  static Widget initScreen() {
    String name = 'assets/images/splashscreen.riv';
    return Center(
      child: RiveAnimation.asset(
        name,
      ),
    );
  }

  static String getToken() {
    final LocalStorage storage = new LocalStorage('user');

    var token = storage.getItem('token') ?? '';

    return token;
  }

  static Map<String, dynamic> getUser() {
    final LocalStorage storage = new LocalStorage('user');

    var user = storage.getItem('user') ?? '';

    return user;
  }

  static Map<String, String> buildHeaders() {
    var token = getToken();
    Map<String, String> headers = {
      // HttpHeaders.contentTypeHeader: "application/json", // or whatever
      HttpHeaders.authorizationHeader: "Bearer $token",
    };

    return headers;
  }

  static Future<Map<String, dynamic>> postWithForm(
      String requestUrl, Map<String, dynamic> formData) async {
    await initConfig();
    var url = Uri.parse(apiUrl + requestUrl);

    var response =
        await http.post(url, body: formData, headers: buildHeaders());
    return jsonDecode(response.body);
  }

  static Future<Map<String, dynamic>> getWithForm(
      String requestUrl, Map<String, dynamic> formData) async {
    await initConfig();
    var url = Uri.parse(apiUrl + requestUrl).replace(queryParameters: formData);
    var response = await http.get(url, headers: buildHeaders());
    return jsonDecode(response.body);
  }

  static Future<List<dynamic>> getListWithForm(
      String requestUrl, Map<String, dynamic> formData) async {
    await initConfig();
    var url = Uri.parse(apiUrl + requestUrl).replace(queryParameters: formData);
    var response = await http.get(url, headers: buildHeaders());
    return jsonDecode(response.body);
  }

  static Future<Map<String, dynamic>> postWithCtrl(
      String requestUrl, Map<String, TextEditingController> listCtrl) async {
    await initConfig();
    Map<String, dynamic> formData = {};
    listCtrl.forEach((key, value) {
      formData[key] = value.text;
    });
    var url = Uri.parse(apiUrl + requestUrl);
    var response =
        await http.post(url, body: formData, headers: buildHeaders());
    return jsonDecode(response.body);
  }

  static Future<Map<String, dynamic>> getWithCtrl(
      String requestUrl, Map<String, TextEditingController> listCtrl) async {
    await initConfig();
    Map<String, dynamic> formData = {};
    listCtrl.forEach((key, value) {
      formData[key] = value.text;
    });
    var url = Uri.parse(apiUrl + requestUrl).replace(queryParameters: formData);
    var response = await http.get(url, headers: buildHeaders());
    return jsonDecode(response.body);
  }

  static Future<bool> login(_email, _password) async {
    await initConfig();

    final LocalStorage storage = new LocalStorage('user');
    var url = Uri.parse(apiUrl + 'auth/login');
    var response =
        await http.post(url, body: {'username': _email, 'password': _password});

    if (response.statusCode == 200) {
      Map<String, dynamic> body = jsonDecode(response.body);

      if (body['status'] == "success") {
        // Navigator.push(context, MaterialPageRoute(builder: (_) => HomePage()));
        storage.setItem('token', body['token']);
        return true;
      }
    }

    return false;
  }

  static Future<String> me(_token) async {
    var url = Uri.parse(apiUrl + 'auth/me');

    var response = await http.post(url, headers: buildHeaders());

    Map<String, dynamic> body = jsonDecode(response.body);
    if (body['status'] == "success") {
      final LocalStorage storage = new LocalStorage('user');
      storage.setItem('user', body['user']);
    }
    return response.body;
  }

  static Future<String> getUrl(String requestUrl) async {
    await initConfig();

    var url = Uri.parse(apiUrl + requestUrl);
    var response = await http.get(url, headers: buildHeaders());

    return response.body;
  }
}

bool isJson(String jsonString) {
  var decodeSucceeded = false;
  try {
    var decodedJSON = json.decode(jsonString) as Map<String, dynamic>;
    decodeSucceeded = true;
  } on FormatException catch (e) {
    decodeSucceeded = false;
  }
  return decodeSucceeded;
}

String formatId(String id, {int length = 12}) {
  if (length > 12) length = 12;
  if (length < 1) length = 1;
  return ('000000000000' + id).substring(id.length <= length ? id.length : 12);
}

String formatMoney(dynamic money) {
  String str;
  str = money.toString().replaceAll(RegExp("\\B(?=(\\d{3})+(?!\\d))"), ",");
  return str;
}

String getRandomString(int length) {
  const _chars =
      'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
  Random _rnd = Random();
  return String.fromCharCodes(Iterable.generate(
      length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));
}

String changeAlias(String alias) {
  String str = alias;
  str = str.replaceAll(RegExp("??|??|???|???|??|??|???|???|???|???|???|??|???|???|???|???|???"), "a");
  str = str.replaceAll(RegExp("??|??|???|???|??|??|???|???|???|???|???|??|???|???|???|???|???"), "A");
  str = str.replaceAll(RegExp('??|??|???|???|???|??|???|???|???|???|???'), "e");
  str = str.replaceAll(RegExp('??|??|???|???|??'), "i");
  str = str.replaceAll(RegExp('??|??|???|???|??|??|???|???|???|???|???|??|???|???|???|???|???'), "o");
  str = str.replaceAll(RegExp('??|??|???|???|??|??|???|???|???|???|???'), "u");
  str = str.replaceAll(RegExp('??|??|???|???|??|??|???|???|???|???|???'), "U");
  str = str.replaceAll(RegExp('???|??|???|???|???'), "y");
  str = str.replaceAll(RegExp('???|??|???|???|???'), "Y");
  str = str.replaceAll(RegExp(r'??'), "d");
  str = str.replaceAll(RegExp(r'??'), "D");
  str = str.replaceAll(RegExp(' + '), " ");

  return str;
}

bool validEmail(String email) {
  return RegExp(
          r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
      .hasMatch(email);
}
