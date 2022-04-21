import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_demo/controller/MenuController.dart';
import 'package:flutter_demo/helpers/loading.dart';
import 'package:flutter_demo/screens/navbar/side_menu.dart';
import 'package:flutter_demo/widget/default_container.dart';
import 'package:flutter_demo/widget/tablebutton.dart';
import 'package:flutter_demo/helpers/utils.dart';
import 'package:provider/provider.dart';

class Companies extends StatefulWidget {
  @override
  _CompaniesState createState() => _CompaniesState();
}

class _CompaniesState extends State<Companies> {
  static String jsonData = "{}";
  static Map<String, String> columnDefines = {
    'id': 'ID',
    'name': 'Tên',
    'phone': 'Số điện thoại',
    'code': 'Mã',
    'president': 'Giám đốc',
    'address': 'Địa chỉ'
  };

  bool processing = true;

  initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    String _jsonData = await Utils.getUrl('companies');
    setState(() {
      jsonData = _jsonData;
    });
    processing = false;
  }

  @override
  Widget build(BuildContext context) {
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
                // padding: EdgeInsets.symmetric(vertical: 1.0),
                child: Column(
                  children: [
                    // IconButton(
                    //   icon: Icon(Icons.menu),
                    //   onPressed: context.read<MenuController>().controlMenu,
                    // ),
                    DataTable(
                      columns: buildColumns(columnDefines),
                      rows: buildDataRows(columnDefines, jsonData),
                    )
                  ],
                ))));
  }

  // buildColumns(Map<String, String> map) {}
  List<DataColumn> buildColumns(Map<String, String> rowList) {
    List<DataColumn> columns = [];
    rowList.forEach((column, columnName) {
      columns.add(DataColumn(
        label: Text(
          columnName,
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

  List<DataRow> buildDataRows(Map<String, String> rowList, String jsonData) {
    List<DataRow> rows = [];

    Map<String, dynamic> body = jsonDecode(jsonData);
    if (body['items'] != null) {
      body['items'].forEach((elm) {
        List<DataCell> cells = [];
        rowList.forEach((columnName, columnTitle) {
          cells.add(DataCell(Text((elm[columnName] ?? '').toString())));
        });
        cells.add(DataCell(TableActionButton(
            action: "user",
            id: elm['id'],
            textButton: 'Edit',
            data: elm,
            columns: rowList)));

        rows.add(new DataRow(cells: cells));
      });
    }

    return rows;
  }

  onButtonClicked(int id) {
    print("clicked button $id");
  }
}
