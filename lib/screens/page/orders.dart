import 'dart:convert';

import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_demo/controller/MenuController.dart';
import 'package:flutter_demo/helpers/loading.dart';
import 'package:flutter_demo/helpers/responsive.dart';
import 'package:flutter_demo/models/customer.dart';
import 'package:flutter_demo/models/order_type.dart';
import 'package:flutter_demo/screens/navbar/side_menu.dart';
import 'package:flutter_demo/screens/page/create_orders.dart';
import 'package:flutter_demo/screens/page/edit_page.dart';
import 'package:flutter_demo/widget/default_container.dart';
import 'package:flutter_demo/helpers/utils.dart';
import 'package:flutter_demo/widget/tablebutton.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class Orders extends StatefulWidget {
  @override
  _OrdersState createState() => _OrdersState();
}

class _OrdersState extends State<Orders> {
  static String jsonData = "{}";
  int currentStatus = -1;
  Customer selectedCustomer;

  static Map<String, dynamic> columnRenders = {
    'date': <String, dynamic>{
      'name': 'Ngày',
      'render': (dynamic data) {
        return DateFormat("dd/MM/yyyy").format(DateTime.parse(data["date"]));
      }
    },
    'time': <String, dynamic>{
      'name': 'Giờ',
      'render': (dynamic data) {
        return DateFormat("hh:mm").format(DateTime.parse(data["date"]));
      }
    },
    'status': <String, dynamic>{
      'name': 'Trạng thái',
      'render': (dynamic data) {
        switch (data["status"]) {
          case 0:
            return ' Hủy';
          case 1:
            return ' Báo giá';
          case 2:
            return ' Chốt đơn';
          case 3:
            return ' Duyệt thanh toán';
          case 4:
            return ' Chờ xuất kho';
          case 5:
            return ' Đã xuất kho';
          case 6:
            return ' Đã giao hàng';
        }
        return data["type"];
      }
    },
    'code': <String, dynamic>{
      'name': 'Code',
      'render': (dynamic data) {
        return "DH${formatId(data["id"].toString())}";
      }
    },
    'amount': <String, dynamic>{
      'name': 'Thành tiền',
      'render': (dynamic data) {
        return "${formatMoney(data["amount"].toString())} đ";
      }
    },
    'discount': <String, dynamic>{
      'name': 'Giảm giá(%)',
      'render': (dynamic data) {
        return data["discount"];
      }
    },
    'vatPer': <String, dynamic>{
      'name': 'VAT(%)',
      'render': (dynamic data) {
        return data["vat"];
      }
    },
    'shipping_fee': <String, dynamic>{
      'name': 'Phụ thu',
      'render': (dynamic data) {
        return "${formatMoney(data["shipping_fee"].toString())} đ";
      }
    },
    'totalAmount2': <String, dynamic>{
      'name': 'Tổng thành tiền',
      'render': (dynamic data) {
        return "${formatMoney(data["total_amount"].toString())} đ";
      }
    },
    'receipt_id': <String, dynamic>{
      'name': 'Trạng thái thanh toán',
      'render': (dynamic data) {
        return "${data["receipt_id"] != null ? 'Đã thanh toán' : 'Chưa thanh toán'}";
      }
    },
    'customer_name': <String, dynamic>{
      'name': 'Khách hàng',
      'render': (dynamic data) {
        return data["customer_name"] ?? '';
      }
    },
    'project_name': <String, dynamic>{
      'name': 'Dự án',
      'render': (dynamic data) {
        return data["project_name"] ?? '';
      }
    },
    'note': <String, dynamic>{
      'name': 'Ghi chú',
      'render': (dynamic data) {
        return data["note"];
      }
    },
  };

  bool processing = true;
  BuildContext _context;
  List<OrderType> orderTypes = <OrderType>[];
  var pagination;

  var ITEM_PER_PAGE = 100;

  OrderType selectedOrderType;

  initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    await Utils.initConfig();
    Map<String, dynamic> orderConfig = Utils.config["ORDER"];

    List<dynamic> statusList = Utils.config["ORDER"]["STATUS_LIST"];
    orderTypes.add(new OrderType(value: -1, name: 'Tất cả'));
    statusList.forEach((element) {

      orderTypes.add(new OrderType(
          value: int.parse(element["id"].toString(), radix: 10),
          name: element["name"]));
    });

    Map<String, dynamic> formData = {};
    formData["limit"] = ITEM_PER_PAGE.toString();
    formData["status"] = currentStatus.toString();
    if (pagination != null) {
      formData["page"] = pagination["current_page"].toString();
    }

    Map<String, dynamic> tableData =
        await Utils.getWithForm('orders', formData);
    String _jsonData = jsonEncode(tableData);

    selectedOrderType = orderTypes[0];
    setState(() {
      processing = false;
      jsonData = _jsonData;
      pagination = tableData["pagination"];
    });
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
      body: _buildBody(),
    );
  }

  _buildBody() {
    return DefaultContainer(
      child: Column(children: [
        Padding(
          padding: const EdgeInsets.all(15.0),
          child: DropdownSearch<OrderType>(
            // label: "Name",
            itemAsString: (OrderType u) => u.toString(),
            onChanged: (OrderType data) async {
              setState(() {
                currentStatus = data.value;
                processing = true;
              });
              await loadData();
            },
            mode: Mode.MENU,
            // showSelectedItems: true,
            items: orderTypes,
            // items: ["English", "Japanese", "Chinese", 'Vietnamese'],
            dropdownSearchDecoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: "Chọn loại đơn hàng",
              hintText: "Chọn loại đơn hàng",
            ),
            selectedItem: selectedOrderType,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(15.0),
          child: DropdownSearch<Customer>(
              itemAsString: (Customer u) => u.toString(),
              onChanged: (Customer data) async {
                selectedCustomer = data;
                print(selectedCustomer.id);
                // projects/getByCustomerId/${selectedCustomer.id}
              },
              mode: Mode.MENU,
              isFilteredOnline: true,
              onFind: (String filter) async {
                if (filter.length > 2) {
                  var response = await Utils.getUrl("customers/search/$filter");
                  var models = Customer.fromJsonList(jsonDecode(response));
                  return models;
                }
                return [];
              },
              dropdownSearchDecoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: "Chọn khách hàng",
                hintText: "Chọn khách hàng",
              ),
              selectedItem: null,
              showSearchBox: true),
        ),
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
                                    child: CreateOrders(),
                                  )));
                      },
                      child: const Text('Thêm mới',
                          style: TextStyle(color: Colors.white, fontSize: 16)),
                    ))),
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
                        
                      },
                      child: const Text('Tạo phiếu',
                          style: TextStyle(color: Colors.white, fontSize: 16)),
                    )))
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
        Row(children: [
          TextButton(
            style: TextButton.styleFrom(
              textStyle:
                  const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            onPressed: () async {
              setState(() {
                pagination["current_page"] = 1;
              });
              await loadData();
            },
            child: Text(
              'First',
              style: TextStyle(
                  color: Color.fromARGB(255, 26, 115, 232), fontSize: 15),
            ),
          ),
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
            onPressed: () {},
            child: Text(
              "${pagination["current_page"].toString() ?? 1}/${((pagination["total_items"] / ITEM_PER_PAGE)).ceil()}",
              style: TextStyle(
                  color: Color.fromARGB(255, 26, 115, 232), fontSize: 15),
            ),
          ),
          TextButton(
            style: TextButton.styleFrom(
              textStyle:
                  const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
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
                  color: Color.fromARGB(255, 26, 115, 232), fontSize: 15),
            ),
          ),
          TextButton(
            style: TextButton.styleFrom(
              textStyle:
                  const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            onPressed: () async {
              setState(() {
                pagination["current_page"] =
                    (pagination["total_items"] / ITEM_PER_PAGE).ceil();
              });
              await loadData();
            },
            child: Text(
              'Last',
              style: TextStyle(
                  color: Color.fromARGB(255, 26, 115, 232), fontSize: 15),
            ),
          ),
        ])
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
        cells.add(DataCell(
          TableActionButton(
              action: "user",
              id: elm['id'],
              textButton: 'Edit',
              data: elm,
              columns: rowList),
        ));

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