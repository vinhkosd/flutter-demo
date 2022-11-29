import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_demo/controller/MenuController.dart';
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
  static Map<String, dynamic> jsonData = {};
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
    try {
      Map<String, dynamic> formData = {};

      List<dynamic> listData =
          await Utils.getListWithForm('accountlist.php', formData);
      Map<String, dynamic> tableData = {'items': listData};

      setState(() {
        processing = false;
        jsonData = tableData;
      });
    } catch (e) {
      debugPrint('${e}');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: const Text('Thông báo: Không thể tải dữ liệu!'),
        duration: const Duration(seconds: 1),
        action: SnackBarAction(
          label: 'ACTION',
          onPressed: () {},
        ),
      ));
    }
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
      headerText: 'Quản lý tài khoản',
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
          : Column(children: [
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () async {
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
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          height: 44,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(3),
                            color: Color.fromARGB(255, 77, 151, 248),
                          ),
                          child: Center(
                            child: Text(
                              'Thêm mới',
                              style: Theme.of(context).textTheme.button!,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
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

  List<DataRow> buildDataRows(
      Map<String, dynamic> rowList, Map<String, dynamic> body) {
    List<DataRow> rows = [];

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
