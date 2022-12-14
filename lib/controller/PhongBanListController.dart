import 'package:flutter/cupertino.dart';
import 'package:flutter_demo/models/phongban.dart';

import '../helpers/utils.dart';

class PhongBanListController extends ChangeNotifier {
  List<PhongBan> list = [];
  List<PhongBan> listPhongBan = [];

  setList(List<PhongBan> list) {
    this.list = list;
    notifyListeners();
  }

  Future<void> load() async {
    await Utils.initConfig();

    Map<String, dynamic> formData = {};
    try {
      List<dynamic> listData =
          await Utils.getListWithForm('listphongban.php', formData);
      Map<String, dynamic> tableData = {'items': listData};
      list = PhongBan.fromJsonList(listData);
      notifyListeners();
    } catch (e) {
      debugPrint('cant load list phong ban!');
    }
  }

  Future<void> loadPhongBan() async {
    await Utils.initConfig();

    Map<String, dynamic> formData = {};
    try {
      List<dynamic> listData =
          await Utils.getListWithForm('phongbanlist.php', formData);
      listPhongBan = PhongBan.fromJsonList(listData);
      notifyListeners();
    } catch (e) {
      debugPrint('cant load list phong ban!');
    }
  }

  String? loadNameById(int? id) {
    if (id != null) {
      var wherePhongBan = this.list.where((element) => element.id == id);
      if (wherePhongBan.isNotEmpty) {
        return wherePhongBan.first.ten;
      }
    }

    return null;
  }
}
