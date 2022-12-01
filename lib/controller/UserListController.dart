import 'package:flutter/cupertino.dart';

import '../helpers/utils.dart';
import '../models/account.dart';

class UserListController extends ChangeNotifier {
  List<Account> list = [];

  setList(List<Account> list) {
    this.list = list;
    notifyListeners();
  }

  Future<void> load() async {
    await Utils.initConfig();

    Map<String, dynamic> formData = {};
    try {
      List<dynamic> listData =
          await Utils.getListWithForm('userlist.php', formData);
      list = Account.fromJsonList(listData);
      notifyListeners();
    } catch (e) {
      debugPrint('cant load list Account $e!');
    }
  }

  String? loadNameById(int? id) {
    if (id != null) {
      var whereAccount = this.list.where((element) => element.id == id);
      if (whereAccount.isNotEmpty) {
        return whereAccount.first.name;
      }
    }

    return null;
  }
}
