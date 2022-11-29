import 'dart:math';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';

import '../event_bus.dart';
import '../models/account.dart';
import 'package:flutter_demo/env.dart' show apiUrl;

class Utils {
  static Map<String, dynamic> config = {};
  static bool appInit = false;
  static late SharedPreferences prefs;
  static Future<bool> initConfig() async {
    // SharedPreferences.setMockInitialValues({});
    prefs = await SharedPreferences.getInstance();

    if (!appInit) {
      await Future.delayed(Duration(milliseconds: 2000));
    }

    return appInit;
  }

  static bool isDarkTheme() {
    var isDarkTheme = prefs.getBool('darkTheme') ?? false;
    return isDarkTheme;
  }

  static void setDarkTheme(bool isDarkTheme) {
    prefs.setBool('darkTheme', isDarkTheme);
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

  static bool isLogin() {
    return getCookieHeaders() != '';
  }

  static String getCookieHeaders() {
    var cookieHeader = prefs.getString('cookie') ?? '';

    return cookieHeader;
  }

  static Account getAccount() {
    print('getAccount ${prefs.getString('account') ?? ''} ');
    var accountString = jsonDecode(prefs.getString('account') ?? '{}');

    return Account.fromJson(accountString);
  }

  static Map<String, String> buildHeaders() {
    var cookieHeader = getCookieHeaders();
    Map<String, String> headers = {
      // HttpHeaders.contentTypeHeader: "application/json", // or whatever
      HttpHeaders.cookieHeader: cookieHeader,
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
    var url = Uri.parse(apiUrl + 'login.php');
    var response =
        await http.post(url, body: {'username': _email, 'password': _password});

    if (response.statusCode == 200) {
      Map<String, dynamic> body = jsonDecode(response.body);

      if (body['success'] != null) {
        prefs.setString('cookie', response.headers['set-cookie']!);
        prefs.setString('account', jsonEncode(body['account']!));
        return true;
      }
    }

    return false;
  }

  static Future<bool> checkFirstLogin() async {
    await initConfig();

    if (prefs.getBool('isFirst') != null) return prefs.getBool('isFirst')!;

    var url = Uri.parse(apiUrl + 'checkfirstlogin.php');
    var response = await http.get(url);

    if (response.statusCode == 200) {
      Map<String, dynamic> body = jsonDecode(response.body);
      print(body);
      if (body['isFirst']) {
        prefs.setBool('isFirst', true);
        return true;
      }
    }

    prefs.setBool('isFirst', false);
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
        eventBus.fire(ReloadAccountsEvent());
        return body['success'];
      } else {
        return body['error'];
      }
    }

    return 'Lỗi hệ thống!';
  }

  static Future<String> updateAccount(body) async {
    await initConfig();

    var url = Uri.parse(apiUrl + 'editaccount.php');
    var response = await http.post(url, headers: buildHeaders(), body: body);
    print(response.body);
    if (response.statusCode == 200) {
      Map<String, dynamic> body = jsonDecode(response.body);

      if (body['success'] != null) {
        eventBus.fire(ReloadAccountsEvent());
        return body['success'];
      } else {
        return body['error'];
      }
    }

    return 'Lỗi hệ thống!';
  }

  static Future<String> editProfile(body) async {
    await initConfig();

    var url = Uri.parse(apiUrl + 'editprofile.php');
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

  static Future<String> createPhongBan(body) async {
    await initConfig();

    var url = Uri.parse(apiUrl + 'createphongban.php');
    var response = await http.post(url, headers: buildHeaders(), body: body);
    print(response.body);
    if (response.statusCode == 200) {
      Map<String, dynamic> body = jsonDecode(response.body);

      if (body['success'] != null) {
        eventBus.fire(ReloadPhongBanEvent());
        return body['success'];
      } else {
        return body['error'];
      }
    }

    return 'Lỗi hệ thống!';
  }

  static Future<String> updatePhongBan(body) async {
    await initConfig();

    var url = Uri.parse(apiUrl + 'editphongban.php');
    var response = await http.post(url, headers: buildHeaders(), body: body);
    print(response.body);
    if (response.statusCode == 200) {
      Map<String, dynamic> body = jsonDecode(response.body);

      if (body['success'] != null) {
        eventBus.fire(ReloadPhongBanEvent());
        return body['success'];
      } else {
        return body['error'];
      }
    }

    return 'Lỗi hệ thống!';
  }

  static Future<String> createAbsent(body) async {
    await initConfig();

    var url = Uri.parse(apiUrl + 'createabsent.php');
    var response = await http.post(url, headers: buildHeaders(), body: body);
    print(response.body);
    if (response.statusCode == 200) {
      Map<String, dynamic> body = jsonDecode(response.body);

      if (body['success'] != null) {
        eventBus.fire(ReloadAccountsEvent());
        return body['success'];
      } else {
        return body['error'];
      }
    }

    return 'Lỗi hệ thống!';
  }

  static Future<String> acceptAbsent(body) async {
    await initConfig();

    var url = Uri.parse(apiUrl + 'acceptabsent.php');
    var response = await http.post(url, headers: buildHeaders(), body: body);
    print(response.body);
    if (response.statusCode == 200) {
      Map<String, dynamic> body = jsonDecode(response.body);

      if (body['success'] != null) {
        eventBus.fire(ReloadAbsentsEvent());
        return body['success'];
      } else {
        return body['error'];
      }
    }

    return 'Lỗi hệ thống!';
  }

  static Future<String> rejectAbsent(body) async {
    await initConfig();

    var url = Uri.parse(apiUrl + 'rejectabsent.php');
    var response = await http.post(url, headers: buildHeaders(), body: body);
    print(response.body);
    if (response.statusCode == 200) {
      Map<String, dynamic> body = jsonDecode(response.body);

      if (body['success'] != null) {
        eventBus.fire(ReloadAbsentsEvent());
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

  static void logout() {
    prefs.setString('cookie', '');
  }
}

bool isJson(String jsonString) {
  var decodeSucceeded = false;
  try {
    json.decode(jsonString) as Map<String, dynamic>;
    decodeSucceeded = true;
  } on FormatException catch (e) {
    print(e);
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

bool validNumber(String number) {
  return RegExp(r"^[0-9]+$").hasMatch(number);
}
