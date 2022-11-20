import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_demo/controller/MenuController.dart';
import 'package:flutter_demo/helpers/loading.dart';
import 'package:flutter_demo/helpers/responsive.dart';
import 'package:flutter_demo/screens/navbar/side_menu.dart';
import 'package:flutter_demo/screens/page/create_account.dart';
import 'package:flutter_demo/screens/page/update_account.dart';
import 'package:flutter_demo/widget/default_container.dart';
import 'package:flutter_demo/helpers/utils.dart';
import 'package:provider/provider.dart';

import '../../event_bus.dart';
import '../../models/account.dart';

class AccountList extends StatefulWidget {
  @override
  _AccountListState createState() => _AccountListState();
}

class _AccountListState extends State<AccountList> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  static String jsonData = "{}";
  int currentStatus = -1;

  static Map<String, dynamic> columnRenders = {
    'id': <String, dynamic>{
      'name': 'ID',
      'render': (dynamic data) {
        return data["id"];
      }
    },
    'username': <String, dynamic>{
      'name': 'Tài khoản',
      'render': (dynamic data) {
        return data["username"];
      }
    },
    'name': <String, dynamic>{
      'name': 'Tên',
      'render': (dynamic data) {
        return data["name"];
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

    eventBus.on<ReloadAccountsEvent>().listen((event) {
      setState(() {
        processing = true;
      });
      loadData();
    });
  }

  Future<void> loadData() async {
    await Utils.initConfig();

    Map<String, dynamic> formData = {};

    List<dynamic> listData =
        await Utils.getListWithForm('accountlist.php', formData);
    Map<String, dynamic> tableData = {'items': listData};
    String _jsonData = jsonEncode(tableData);

    setState(() {
      processing = false;
      jsonData = _jsonData;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (this.processing) {
      return loadingProcess(context, "Đang tải dữ liệu");
    }

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
      child: Column(children: [
        Row(
          children: [
            Padding(
                padding: const EdgeInsets.all(15.0),
                child: Container(
                    height: MediaQuery.of(context).size.height * 0.05,
                    width: Responsive.isDesktop(context)
                        ? MediaQuery.of(context).size.width * 0.1
                        : MediaQuery.of(context).size.width * 0.3,
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                          backgroundColor: Color.fromARGB(255, 26, 115, 232),
                          primary: Color.fromARGB(255, 255, 255, 255)),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => MultiProvider(
                                      providers: [
                                        ChangeNotifierProvider(
                                          create: (context) => MenuController(),
                                        ),
                                      ],
                                      child: CreateAccount(),
                                    )));
                      },
                      child: const Text('Thêm mới',
                          style: TextStyle(color: Colors.white, fontSize: 16)),
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

    // columns.add(DataColumn(
    //   label: Text(
    //     'Func',
    //     style:
    //         TextStyle(fontStyle: FontStyle.normal, fontWeight: FontWeight.bold),
    //   ),
    // ));
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

        rows.add(new DataRow(
          cells: cells,
          onSelectChanged: (bool? selected) {
            if (selected != null && selected) {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => MultiProvider(
                            providers: [
                              ChangeNotifierProvider(
                                create: (context) => MenuController(),
                              ),
                            ],
                            child: UpdateAccount(Account.fromJson(elm)),
                          )));
            }
          },
        ));
      });
    }

    return rows;
  }
}
