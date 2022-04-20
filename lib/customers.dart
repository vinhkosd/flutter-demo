import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_demo/MenuController.dart';
import 'package:flutter_demo/header.dart';
import 'package:flutter_demo/loading.dart';
import 'package:flutter_demo/side_menu.dart';
import 'package:flutter_demo/tablebutton.dart';
import 'package:flutter_demo/utils.dart';
import 'package:provider/provider.dart';

class Customers extends StatefulWidget {
  @override
  _CustomersState createState() => _CustomersState();
}

class _CustomersState extends State<Customers> {
  static String jsonData = "{}";
  static Map<String, String> columnDefines = {
    'id': 'ID',
    'name': 'Tên',
    'address': 'Địa chỉ',
    'mobile_phone_number': 'Số điện thoại',
    'tax_code': 'Mã số thuế',
    'email': 'Email',
    'website': 'Website'
  };

  bool processing = true;

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
    print(formData);
    Map<String, dynamic> tableData =
        await Utils.getWithForm('customers', formData);
    String _jsonData = jsonEncode(tableData);
    print(tableData["pagination"]);
    setState(() {
      jsonData = _jsonData;
      pagination = tableData["pagination"];
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
    return SafeArea(
      child: 
      Column(children: [
        
        Header(),
        Expanded(child: 
        SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: SingleChildScrollView(
              
                scrollDirection: Axis.horizontal,
                // padding: EdgeInsets.symmetric(vertical: 1.0),
                
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header(),
                    // Column(
                    //   children: [Header()],
                    // ),
                    DataTable(
                      columns: buildColumns(columnDefines),
                      rows: buildDataRows(columnDefines, jsonData),
                    ),
                    Row(children: [
                      TextButton(
                        style: TextButton.styleFrom(
                          textStyle:
                              const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        onPressed: () async {
                          if (pagination != null && pagination["current_page"] > 1) {
                            setState(() {
                              pagination["current_page"]--;
                            });
                            await loadData();
                          }
                        },
                        child: Text(
                          'Prev',
                          style: TextStyle(
                              color: Color.fromARGB(255, 26, 115, 232), fontSize: 15),
                        ),
                      ),
                      TextButton(
                        style: TextButton.styleFrom(
                          textStyle:
                              const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        onPressed: () {
                          
                        },
                        child: Text(
                          "${pagination["current_page"].toString() ?? 1}/${((pagination["total_items"]/ITEM_PER_PAGE)).ceil()}",
                          style: TextStyle(
                              color: Color.fromARGB(255, 26, 115, 232), fontSize: 15),
                        ),
                      ),
                      TextButton(
                        style: TextButton.styleFrom(
                          textStyle:
                              const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        onPressed: ()async {
                          print(pagination);
                          if (pagination != null && (pagination["total_items"]/ITEM_PER_PAGE) > pagination["current_page"]) {
                            setState(() {
                              pagination["current_page"]++;
                            });
                            await loadData();
                          }
                        },
                        child: Text(
                          'Next',
                          style: TextStyle(
                              color: Color.fromARGB(255, 26, 115, 232), fontSize: 15),
                        ),
                      ),
                    ])
                  ],
                )))
      ,)
      ]),
    );
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
}
