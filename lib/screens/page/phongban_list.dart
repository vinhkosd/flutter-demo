import 'dart:convert';

import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_demo/controller/MenuController.dart';
import 'package:flutter_demo/event_bus.dart';
import 'package:flutter_demo/helpers/loading.dart';
import 'package:flutter_demo/helpers/responsive.dart';
import 'package:flutter_demo/models/customer.dart';
import 'package:flutter_demo/screens/navbar/side_menu.dart';
import 'package:flutter_demo/screens/page/create_account.dart';
import 'package:flutter_demo/screens/page/edit_page.dart';
import 'package:flutter_demo/screens/page/update_phongban.dart';
import 'package:flutter_demo/widget/default_container.dart';
import 'package:flutter_demo/helpers/utils.dart';
import 'package:flutter_demo/widget/tablebutton.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../../models/phongban.dart';
import 'create_phongban.dart';

class PhongBanList extends StatefulWidget {
  @override
  _PhongBanListState createState() => _PhongBanListState();
}

class _PhongBanListState extends State<PhongBanList> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  static String jsonData = "{}";
  int currentStatus = -1;
  Customer selectedCustomer;

  static Map<String, dynamic> columnRenders = {
    'id': <String, dynamic>{
      'name': 'ID',
      'render': (dynamic data) {
        return data["id"];
      }
    },
    'ten': <String, dynamic>{
      'name': 'Tên',
      'render': (dynamic data) {
        return data["ten"];
      }
    },
    'mo_ta': <String, dynamic>{
      'name': 'Mô tả',
      'render': (dynamic data) {
        return data["mo_ta"];
      }
    },
    'so_phong': <String, dynamic>{
      'name': 'Số phòng',
      'render': (dynamic data) {
        return data["so_phong"];
      }
    },
    'name': <String, dynamic>{
      'name': 'Trưởng phòng',
      'render': (dynamic data) {
        return data["name"] ?? '';
      }
    },
  };

  bool processing = true;
  BuildContext _context;

  initState() {
    super.initState();
    loadData();

    eventBus.on<ToggleDrawerEvent>().listen((event) {
      if (!scaffoldKey.currentState.isDrawerOpen)
        scaffoldKey.currentState.openDrawer();
    });

    eventBus.on<ReloadPhongBanEvent>().listen((event) {
      setState(() {
        processing = false;
      });
      loadData();
    });
  }

  Future<void> loadData() async {
    await Utils.initConfig();

    Map<String, dynamic> formData = {};

    List<dynamic> listData =
        await Utils.getListWithForm('listphongban.php', formData);
    Map<String, dynamic> tableData = {'items': listData};
    String _jsonData = jsonEncode(tableData);

    setState(() {
      processing = false;
      jsonData = _jsonData;
    });
  }

  @override
  Widget build(BuildContext context) {
    this._context = context;
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
                                      child: CreatePhongBan(),
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
              Text((columnTitle["render"](elm).toString() ?? '').toString())));
        });
        // cells.add(DataCell(
        //   TableActionButton(
        //       action: "user",
        //       id: elm['id'],
        //       textButton: 'Edit',
        //       data: elm,
        //       columns: rowList),
        // ));

        rows.add(new DataRow(
          cells: cells,
          onSelectChanged: (bool selected) {
            if (selected) {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => MultiProvider(
                            providers: [
                              ChangeNotifierProvider(
                                create: (context) => MenuController(),
                              ),
                            ],
                            child: UpdatePhongBan(PhongBan.fromJson(elm)),
                          )));
            }
          },
        ));
      });
    }

    return rows;
  }
}