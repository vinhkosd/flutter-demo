import 'dart:math';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import 'package:flutter/services.dart' show rootBundle;
import 'package:localstorage/localstorage.dart';
import 'package:rive/rive.dart';

import '../models/account.dart';

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
    // String name = 'assets/images/splashscreen.riv';
    return Center(
      child: Text('Personal Management'),
    );

    // return Center(
    //   child: RiveAnimation.asset(
    //     name,
    //   ),
    // );
  }

  static String getToken() {
    final LocalStorage storage = new LocalStorage('user');

    var token = storage.getItem('token') ?? '';

    return token;
  }

  static Account getAccount() {
    final LocalStorage storage = new LocalStorage('user');

    var accountString = storage.getItem('account') ?? '';

    return Account.fromJson(accountString);
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
      HttpHeaders.cookieHeader: token,
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
    print(response.body);
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
    var url = Uri.parse(apiUrl + 'login.php');
    var response =
        await http.post(url, body: {'username': _email, 'password': _password});

    if (response.statusCode == 200) {
      Map<String, dynamic> body = jsonDecode(response.body);

      if (body['success'] != null) {
        storage.setItem('account', body['account']);
        storage.setItem('token', response.headers['set-cookie']);
        return true;
      }
    }

    return false;
  }

  static Future<bool> checkFirstLogin() async {
    await initConfig();

    var url = Uri.parse(apiUrl + 'checkfirstlogin.php');
    print(url);
    var response = await http.get(url);
    print(response);
    print(url);
    if (response.statusCode == 200) {
      Map<String, dynamic> body = jsonDecode(response.body);
      print(body);
      if (body['isFirst']) {
        return true;
      }
    }

    return false;
  }

  static Future<bool> firstLogin(
      String name, String username, String password) async {
    await initConfig();

    var url = Uri.parse(apiUrl + 'firstlogin.php');

    var response = await http.post(url,
        body: {'name': name, 'username': username, 'password': password});

    if (response.statusCode == 200) {
      Map<String, dynamic> body = jsonDecode(response.body);
      print(body);
      if (body['success'] != null) {
        return true;
      }
    }

    return false;
  }

  static Future<String> createAccount(body) async {
    await initConfig();

    var url = Uri.parse(apiUrl + 'createaccount.php');
    var response = await http.post(url, headers: buildHeaders(), body: body);
    print(response.body);
    if (response.statusCode == 200) {
      Map<String, dynamic> body = jsonDecode(response.body);

      if (body['success'] != null) {
        return body['success'];
      } else {
        return body['error'];
      }
    }

    return 'Lỗi hệ thống!';
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

bool validEmail(String email) {
  return RegExp(
          r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
      .hasMatch(email);
}

bool validFullName(String email) {
  return RegExp(
          r"^[a-zA-ZÀÁÂÃÈÉÊÌÍÒÓÔÕÙÚĂĐĨŨƠàáâãèéêìíòóôõùúăđĩũơƯĂẠẢẤẦẨẪẬẮẰẲẴẶẸẺẼỀỀỂẾưăạảấầẩẫậắằẳẵặẹẻẽềềểếỄỆỈỊỌỎỐỒỔỖỘỚỜỞỠỢỤỦỨỪễệỉịọỏốồổỗộớờởỡợụủứừỬỮỰỲỴÝỶỸửữựỳỵỷỹ\s|_]+$")
      .hasMatch(email);
}
