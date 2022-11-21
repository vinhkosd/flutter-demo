import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_demo/controller/MenuController.dart';
import 'package:flutter_demo/screens/navbar/side_menu.dart';
import 'package:flutter_demo/widget/default_container.dart';
import 'package:flutter_demo/helpers/utils.dart';
import 'package:provider/provider.dart';

import '../../event_bus.dart';
import 'create_absent.dart';

class AbsentList extends StatefulWidget {
  @override
  _AbsentListState createState() => _AbsentListState();
}

class _AbsentListState extends State<AbsentList> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  static String jsonData = "{}";
  static String message = '';
  int currentStatus = -1;
  int? absentRemain;
  int? absentTotal;
  int? absentMax;

  static Map<String, dynamic> columnRenders = {
    'id': <String, dynamic>{
      'name': 'ID',
      'render': (dynamic data) {
        return data["id"];
      }
    },
    'register_name': <String, dynamic>{
      'name': 'Người đăng ký',
      'render': (dynamic data) {
        return data["register_name"];
      }
    },
    'time': <String, dynamic>{
      'name': 'Thời gian đăng ký',
      'render': (dynamic data) {
        return data["time"];
      }
    },
    'status': <String, dynamic>{
      'name': 'Trạng thái',
      'render': (dynamic data) {
        switch (int.parse(data['status'].toString())) {
          case 0:
            return 'Chưa nhận';
          case 1:
            return 'Đồng ý';
          case 2:
            return 'Từ chối';
        }
        return data["status"];
      }
    },
  };

  bool processing = true;

  initState() {
    super.initState();
    loadData();

    eventBus.on<ToggleDrawerEvent>().listen((event) {
      if (!(scaffoldKey.currentState?.isDrawerOpen ?? false))
        scaffoldKey.currentState?.openDrawer();
    });

    eventBus.on<ReloadAbsentsEvent>().listen((event) {
      setState(() {
        processing = true;
      });
      loadData();
    });
  }

  Future<void> loadData() async {
    await Utils.initConfig();

    Map<String, dynamic> formData = {};

    Map<String, dynamic> listData =
        await Utils.getWithForm('listabsent.php', formData);
    Map<String, dynamic> tableData = {'items': listData['data']};

    absentMax = listData['absentMax'] ?? null;
    absentRemain = listData['absentMax'] ?? null;
    absentTotal = listData['absentTotal'] ?? null;
    String _jsonData = jsonEncode(tableData);

    setState(() {
      processing = false;
      jsonData = _jsonData;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      drawer: SideMenu(),
      body: _buildBody(),
    );
  }

  _buildBody() {
    return DefaultContainer(
      rightIcon: IconButton(
        icon: Icon(Icons.replay),
        onPressed: () {
          setState(() {
            processing = true;
          });
          loadData();
        },
      ),
      child: this.processing
          ? Center(
              child: CircularProgressIndicator(
                semanticsLabel: 'Linear progress indicator',
              ),
            )
          : Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              if (absentMax != null)
                Text('Số ngày nghỉ phép tối đa: ${absentMax}'),
              if (absentTotal != null)
                Text('Số ngày nghỉ phép đã sử dụng: ${absentTotal}'),
              if (absentRemain != null)
                Text('Số ngày nghỉ phép còn lại: ${absentRemain}'),
              if (Utils.getAccount().role != 'god')
                Row(
                  children: [
                    Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Container(
                            height: MediaQuery.of(context).size.height * 0.05,
                            child: OutlinedButton(
                              style: OutlinedButton.styleFrom(
                                  backgroundColor:
                                      Color.fromARGB(255, 26, 115, 232),
                                  primary: Color.fromARGB(255, 255, 255, 255)),
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (_) => MultiProvider(
                                              providers: [
                                                ChangeNotifierProvider(
                                                  create: (context) =>
                                                      MenuController(),
                                                ),
                                              ],
                                              child: CreateAbsent(),
                                            )));
                              },
                              child: const Text('Đăng ký nghỉ phép',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 16)),
                            ))),
                  ],
                ),
              Expanded(
                  child: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: DataTable(
                          showCheckboxColumn: false,
                          columns: buildColumns(columnRenders),
                          rows: buildDataRows(columnRenders, jsonData),
                        ),
                      ))),
            ]),
    );
  }

  List<DataColumn> buildColumns(Map<String, dynamic> rowList) {
    List<DataColumn> columns = [];
    rowList.forEach((column, columnName) {
      columns.add(DataColumn(
        label: Text(
          columnName["name"],
          style: TextStyle(
              fontStyle: FontStyle.normal, fontWeight: FontWeight.bold),
        ),
      ));
    });

    columns.add(DataColumn(
      label: Text(
        'Chức năng',
        style:
            TextStyle(fontStyle: FontStyle.normal, fontWeight: FontWeight.bold),
      ),
    ));
    return columns;
  }

  List<DataRow> buildDataRows(Map<String, dynamic> rowList, String jsonData) {
    List<DataRow> rows = [];

    Map<String, dynamic> body = jsonDecode(jsonData);
    if (body['items'] != null) {
      body['items'].forEach((elm) {
        List<DataCell> cells = [];
        rowList.forEach((columnName, columnTitle) {
          cells.add(DataCell(
              Text((columnTitle["render"](elm).toString()).toString())));
        });

        if (Utils.getAccount().role != 'user' &&
            int.parse(elm['status'].toString()) == 0) {
          cells.add(DataCell(Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                      backgroundColor: Color.fromARGB(255, 26, 115, 232),
                      primary: Color.fromARGB(255, 255, 255, 255)),
                  onPressed: () async {
                    var params = {'id': elm['id'].toString()};
                    print(elm);
                    var responseMessage = await Utils.rejectAbsent(params);
                    setState(() {
                      processing = false;
                      message = responseMessage;
                    });

                    Navigator.of(context).restorablePush(showDialog);
                  },
                  child: const Text('Từ chối',
                      style: TextStyle(color: Colors.white, fontSize: 16)),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                      backgroundColor: Color.fromARGB(255, 26, 115, 232),
                      primary: Color.fromARGB(255, 255, 255, 255)),
                  onPressed: () async {
                    var params = {'id': elm['id'].toString()};

                    var responseMessage = await Utils.acceptAbsent(params);
                    setState(() {
                      processing = false;
                      message = responseMessage;
                    });

                    Navigator.of(context).restorablePush(showDialog);
                  },
                  child: const Text('Đồng ý',
                      style: TextStyle(color: Colors.white, fontSize: 16)),
                ),
              ),
            ],
          )));
        } else {
          cells.add(DataCell(Text('')));
        }

        rows.add(new DataRow(
          cells: cells,
        ));
      });
    }

    return rows;
  }

  static Route<Object?> showDialog(BuildContext context, Object? arguments) {
    return DialogRoute<void>(
      context: context,
      builder: (BuildContext context) => AlertDialog(title: Text(message)),
    );
  }
}
