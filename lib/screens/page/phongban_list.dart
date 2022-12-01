import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_demo/controller/MenuController.dart';
import 'package:flutter_demo/controller/PhongBanListController.dart';
import 'package:flutter_demo/event_bus.dart';
import 'package:flutter_demo/helpers/responsive.dart';
import 'package:flutter_demo/screens/navbar/side_menu.dart';
import 'package:flutter_demo/screens/page/phong_ban_view.dart';
import 'package:flutter_demo/screens/page/update_phongban.dart';
import 'package:flutter_demo/widget/default_container.dart';
import 'package:flutter_demo/helpers/utils.dart';
import 'package:provider/provider.dart';

import '../../models/phongban.dart';
import 'create_phongban.dart';

class PhongBanList extends StatefulWidget {
  @override
  _PhongBanListState createState() => _PhongBanListState();
}

class _PhongBanListState extends State<PhongBanList> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  int currentStatus = -1;
  List<PhongBan> listPhongBan = [];
  bool processing = true;

  initState() {
    super.initState();
    loadData();

    eventBus.on<ToggleDrawerEvent>().listen((event) {
      if (!(scaffoldKey.currentState?.isDrawerOpen ?? false))
        scaffoldKey.currentState?.openDrawer();
    });

    eventBus.on<ReloadPhongBanEvent>().listen((event) {
      setState(() {
        processing = true;
      });
      loadData();
    });
  }

  Future<void> loadData() async {
    await Utils.initConfig();

    await context.read<PhongBanListController>().load();
    listPhongBan = context.read<PhongBanListController>().list;
    setState(() {
      processing = false;
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
      headerText: 'Quản lý phòng ban',
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
                                      child: CreatePhongBan(),
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
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListView.builder(
                      itemCount: listPhongBan.length,
                      itemBuilder: ((context, index) => PhongBanView(
                            phongBan: listPhongBan[index],
                            onTap: () {
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
                                            child: UpdatePhongBan(
                                                listPhongBan[index]),
                                          )));
                            },
                          ))),
                ),
              ),
            ]),
    );
  }

  List<DataColumn> buildColumns(Map<String, dynamic> rowList) {
    List<DataColumn> columns = [];
    rowList.forEach((column, columnName) {
      columns.add(DataColumn(
        label: Text(
          columnName["name"],
          style: Theme.of(context).textTheme.titleSmall,
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
