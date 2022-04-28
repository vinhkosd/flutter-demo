
import 'package:flutter/material.dart';
import 'package:flutter_demo/models/product.dart';
import 'package:flutter_demo/helpers/utils.dart';

class Carts extends StatelessWidget {
  final List<Product> carts;
  final Function(Product elm) onSelectProduct;
  Carts({Key key, this.carts, this.onSelectProduct}) : super(key: key);

  static Map<String, dynamic> columnRenders = {
    // 'id': {
    //   'name': 'ID',
    //   'render': (Product product) {
    //     return product.id;
    //   }
    // },
    'name': <String, dynamic>{
      'name': 'Tên',
      'render': (Product product) {
        return product.name;
      }
    },
    'count': <String, dynamic>{
      'name': 'Số lượng',
      'render': (Product product) {
        return product.count;
      }
    },
    'vat': <String, dynamic>{
      'name': 'VAT (%)',
      'render': (Product product) {
        return "${product.vat} %";
      }
    },
    'price': <String, dynamic>{
      'name': 'Đơn giá',
      'render': (Product product) {
        return "${formatMoney(product.price)} VNĐ";
      }
    },
    'unit_name': <String, dynamic>{
      'name': 'Đơn vị',
      'render': (Product product) {
        return "${product.unit_name}";
      }
    },
    'total_price': <String, dynamic>{
      'name': 'Thành tiền',
      'render': (Product product) {
        return "${formatMoney(product.price * product.count)} VNĐ";
      }
    },
  };

  BuildContext _context;

  @override
  Widget build(BuildContext context) {
    this._context = context;

    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Container(
      width: width,
      height: height,
      color: Colors.white,
      child: SafeArea(child: 
                    SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child:DataTable(
                          showCheckboxColumn: false,
                          columns: buildColumns(columnRenders),
                          rows: buildDataRows(columnRenders, this.carts),
                        )
                      )
                    ),
                ));
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

    return columns;
  }

  List<DataRow> buildDataRows(
      Map<String, dynamic> rowList, List<Product> carts) {
    List<DataRow> rows = [];

    carts.forEach((elm) {
      List<DataCell> cells = [];
      rowList.forEach((columnName, columnTitle) {
        cells.add(DataCell(
            Text((columnTitle["render"](elm).toString() ?? '').toString())));
      });

      rows.add(new DataRow(
        cells: cells,
        onSelectChanged: (bool selected) {
          if (selected) {
            this.onSelectProduct(elm);
          }
        },
      ));
    });

    return rows;
  }
}
