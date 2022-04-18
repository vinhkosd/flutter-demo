import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_demo/header.dart';
import 'package:flutter_demo/tablebutton.dart';
import 'package:flutter_demo/utils.dart';

class Suppliers extends StatefulWidget {
  @override
  _SuppliersState createState() => _SuppliersState();
}

class _SuppliersState extends State<Suppliers> {
  static String jsonData = "{}";
  static Map<String, String> columnDefines = {
    'id': 'ID',
    'name': 'Tên',
    'phone': 'Số điện thoại',
    'fax': 'Fax',
    'address': 'Địa chỉ',
    'keyword': 'Từ khóa'
  };

  initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    String _jsonData = await Utils.getUrl('suppliers');
    setState(() {
      jsonData = _jsonData;
    });
    print(_jsonData);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Suppliers"),
      ),
      body: _buildBody(),
    );
  }

  _buildBody() {
    return SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Column(children: [
              Header(),
              DataTable(
                columns: buildColumns(columnDefines),
                rows: buildDataRows(columnDefines, jsonData),
              )
            ],)));
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
      // print(body['items'].runtimeType);
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
