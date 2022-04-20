import 'dart:math';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import 'package:flutter/services.dart' show rootBundle;
import 'package:localstorage/localstorage.dart';

class Utils {
  static String apiUrl;
  static Map<String, dynamic> config;
  static Future initConfig() async {
    if (apiUrl == null) {
      config = jsonDecode(await rootBundle.loadString('assets/config.json'));
      apiUrl = config["apiUrl"];
    }
  }

  static String getToken() {
    final LocalStorage storage = new LocalStorage('user');

    var token = storage.getItem('token') ?? '';

    return token;
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
    print(url);
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
        await http.post(url, body: {'email': _email, 'password': _password});

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

  static String changeAlias(String alias) {
    String str = alias;
    str = str.replaceAll(RegExp("à|á|ạ|ả|ã|â|ầ|ấ|ậ|ẩ|ẫ|ă|ằ|ắ|ặ|ẳ|ẵ"), "a");
    str = str.replaceAll(RegExp("À|Á|Ạ|Ả|Ã|Â|Ầ|Ấ|Ậ|Ẩ|Ẫ|Ă|Ằ|Ắ|Ặ|Ẳ|Ẵ"), "A");
    str = str.replaceAll(RegExp('è|é|ẹ|ẻ|ẽ|ê|ề|ế|ệ|ể|ễ'), "e");
    str = str.replaceAll(RegExp('ì|í|ị|ỉ|ĩ'), "i");
    str = str.replaceAll(RegExp('ò|ó|ọ|ỏ|õ|ô|ồ|ố|ộ|ổ|ỗ|ơ|ờ|ớ|ợ|ở|ỡ'), "o");
    str = str.replaceAll(RegExp('ù|ú|ụ|ủ|ũ|ư|ừ|ứ|ự|ử|ữ'), "u");
    str = str.replaceAll(RegExp('Ù|Ú|Ụ|Ủ|Ũ|Ư|Ừ|Ứ|Ự|Ử|Ữ'), "U");
    str = str.replaceAll(RegExp('ỳ|ý|ỵ|ỷ|ỹ'), "y");
    str = str.replaceAll(RegExp('Ỳ|Ý|Ỵ|Ỷ|Ỹ'), "Y");
    str = str.replaceAll(RegExp(r'đ'), "d");
    str = str.replaceAll(RegExp(r'Đ'), "D");
    str = str.replaceAll(RegExp(' + '), " ");

    return str;
  }

  static String formatMoney(int money) {
    String str;
    str = money.toString().replaceAll(RegExp("\\B(?=(\\d{3})+(?!\\d))"), ",");
    return str;
  }

  static String getRandomString(int length) {
    const _chars =
        'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
    Random _rnd = Random();
    return String.fromCharCodes(Iterable.generate(
        length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));
  }

  static Future<String> getUrl(String requestUrl) async {
    await initConfig();

    var url = Uri.parse(apiUrl + requestUrl);
    var response = await http.get(url, headers: buildHeaders());
    return response.body;
  }
}
