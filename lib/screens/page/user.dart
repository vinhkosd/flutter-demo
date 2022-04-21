import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_demo/controller/MenuController.dart';
import 'package:flutter_demo/screens/navbar/header.dart';
import 'package:flutter_demo/helpers/loading.dart';
import 'package:flutter_demo/screens/navbar/side_menu.dart';
import 'package:flutter_demo/screens/page/edit_page.dart';
import 'package:flutter_demo/widget/default_container.dart';
import 'package:flutter_demo/widget/tablebutton.dart';
import 'package:flutter_demo/helpers/utils.dart';
import 'package:provider/provider.dart';

class Users extends StatefulWidget {
  @override
  _UsersState createState() => _UsersState();
}

class _UsersState extends State<Users> {
  static String jsonData = "{}";

  static Map<String, dynamic> columnRenders = {
    'id': {
      'name': 'ID',
      'render': (dynamic data) {
        return data["id"];
      }
    },
    'full_name': <String, dynamic>{
      'name': 'Tên',
      'render': (dynamic data) {
        return data["full_name"];
      }
    },
    'email': <String, dynamic>{
      'name': 'Email',
      'render': (dynamic data) {
        return data["email"];
      }
    },
  };

  bool processing = true;

  BuildContext _context;

  var pagination;

  var ITEM_PER_PAGE = 100;

  initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    processing = true;
    Map<String, dynamic> formData = {};
    formData["limit"] = ITEM_PER_PAGE.toString();
    formData["type"] = "0";
    if (pagination != null) {
      formData["page"] = pagination["current_page"].toString();
    }

    Map<String, dynamic> tableData =
        await Utils.getWithForm('auth/getList', formData);
    String _jsonData = jsonEncode(tableData);

    setState(() {
      jsonData = _jsonData;
      pagination = tableData["pagination"];
    });
    processing = false;
  }

  @override
  Widget build(BuildContext context) {
    this._context = context;
    if (this.processing) {
      return loadingProcess(context, "Đang tải dữ liệu");
    }

    return Scaffold(
      key: context.read<MenuController>().scaffoldKey,
      drawer: SideMenu(),
      // appBar: AppBar(
      //   title: Text("Suppliers"),
      // ),
      body: _buildBody(),
    );
  }

  _buildBody() {
    return DefaultContainer(
        child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    DataTable(
                      showCheckboxColumn: false,
                      columns: buildColumns(columnRenders),
                      rows: buildDataRows(columnRenders, jsonData),
                    ),
                    Row(children: [
                      TextButton(
                        style: TextButton.styleFrom(
                          textStyle: const TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        onPressed: () async {
                          if (pagination != null &&
                              pagination["current_page"] > 1) {
                            setState(() {
                              pagination["current_page"]--;
                            });
                            await loadData();
                          }
                        },
                        child: Text(
                          'Prev',
                          style: TextStyle(
                              color: Color.fromARGB(255, 26, 115, 232),
                              fontSize: 15),
                        ),
                      ),
                      TextButton(
                        style: TextButton.styleFrom(
                          textStyle: const TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        onPressed: () {},
                        child: Text(
                          "${pagination["current_page"].toString() ?? 1}/${((pagination["total_items"] / ITEM_PER_PAGE)).ceil()}",
                          style: TextStyle(
                              color: Color.fromARGB(255, 26, 115, 232),
                              fontSize: 15),
                        ),
                      ),
                      TextButton(
                        style: TextButton.styleFrom(
                          textStyle: const TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        onPressed: () async {
                          if (pagination != null &&
                              (pagination["total_items"] / ITEM_PER_PAGE) >
                                  pagination["current_page"]) {
                            setState(() {
                              pagination["current_page"]++;
                            });
                            await loadData();
                          }
                        },
                        child: Text(
                          'Next',
                          style: TextStyle(
                              color: Color.fromARGB(255, 26, 115, 232),
                              fontSize: 15),
                        ),
                      ),
                    ])
                  ],
                ))));
  }

  List<DataColumn> buildColumns(Map<String, dynamic> rowList) {
    List<DataColumn> columns = [];
    rowList.forEach((column, columnName) {
      columns.add(DataColumn(
        label: Text(
          columnName['name'],
          style: TextStyle(
              fontStyle: FontStyle.normal, fontWeight: FontWeight.bold),
        ),
      ));
    });

    columns.add(DataColumn(
      label: Text(
        'Func',
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
              Text((columnTitle["render"](elm).toString() ?? '').toString())));
        });
        cells.add(DataCell(TableActionButton(
            action: "user",
            id: elm['id'],
            textButton: 'Edit',
            data: elm,
            columns: rowList)));

        rows.add(new DataRow(
          cells: cells,
          onSelectChanged: (bool selected) {
            if (selected) {
              Navigator.push(
                  _context,
                  MaterialPageRoute(
                      builder: (_) => EditPage(
                          id: elm['id'],
                          action: "user",
                          data: elm,
                          columns: rowList)));
            }
          },
        ));
      });
    }

    return rows;
  }
}
