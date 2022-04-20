import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_demo/MenuController.dart';
import 'package:flutter_demo/detail_page.dart';
import 'package:flutter_demo/login.dart';
import 'package:flutter_demo/tablebutton.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        textTheme: GoogleFonts.poppinsTextTheme(Theme.of(context).textTheme)
            .apply(bodyColor: Color.fromARGB(255, 0, 0, 0)),
      ),
      // theme: ThemeData.dark().copyWith(
      //   scaffoldBackgroundColor: Color.fromARGB(255, 0, 0, 0),
      //   textTheme: GoogleFonts.poppinsTextTheme(Theme.of(context).textTheme)
      //       .apply(bodyColor: Color.fromARGB(255, 255, 255, 255)),
      //   canvasColor: Color.fromARGB(255, 0, 188, 245),
      // ),
      debugShowCheckedModeBanner: false,
      // home: LoginDemo(),
       home: MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (context) => MenuController(),
          ),
        ],
        child: LoginDemo(),
      ),
    );
  }
}
// class MyApp extends StatelessWidget {
//   const MyApp({Key key}) : super(key: key);

//   static const String _title = 'Demo Datatable with jsonData';

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: _title,
//       home: Scaffold(
//         appBar: AppBar(title: const Text(_title)),
//         body: const MyStatelessWidget(),
//       ),
//     );
//   }
// }

// class MyStatelessWidget extends StatelessWidget {
//   const MyStatelessWidget({Key key}) : super(key: key);
//   static Map<String, String> columnDefines = {
//     'id': 'ID',
//     'name': 'Tên',
//     'phone': 'Số điện thoại',
//     'fax': 'Fax',
//     'address': 'Địa chỉ',
//     'keyword': 'Từ khóa'
//   };
  
//   @override
//   Widget build(BuildContext context) {
//     print(columnDefines);
//     return SingleChildScrollView(
//         scrollDirection: Axis.vertical,
//         child: SingleChildScrollView(
//             scrollDirection: Axis.horizontal,
//             child: DataTable(
//               columns: buildColumns(columnDefines),
//               rows: buildDataRows(columnDefines,
//                   '{"items":[{"id":1,"name":"H\u00e0 Ti\u00ean 1","keyword":"ha tien 1","phone":"0123456789","fax":"123456789","address":"11 BD","status":1,"created_at":"2022-01-11T08:00:36.000000Z","created_by":4,"updated_at":"2022-01-14T08:53:09.000000Z","updated_by":4},{"id":2,"name":"\u0110\u1ed3ng T\u00e2m","keyword":"dong tam","phone":null,"fax":null,"address":"Long An","status":1,"created_at":"2022-01-13T03:06:04.000000Z","created_by":4,"updated_at":"2022-01-13T03:06:20.000000Z","updated_by":4},{"id":3,"name":"C\u00f4ng ty TNHH SX v\u00e0 d\u1ecbch v\u1ee5 S\u00e0i G\u00f2n","keyword":"cong ty tnhh sx va dich vu sai gon","phone":null,"fax":null,"address":null,"status":1,"created_at":"2022-02-10T03:26:24.000000Z","created_by":4,"updated_at":"2022-02-10T03:26:24.000000Z","updated_by":4},{"id":4,"name":"NSX1","keyword":"nsx1","phone":"0123456789","fax":"123","address":"12 phan v\u0103n h\u1edbn","status":1,"created_at":"2022-02-25T02:16:06.000000Z","created_by":13,"updated_at":"2022-02-25T02:16:24.000000Z","updated_by":13}]}') /*const <DataRow>[
//         DataRow(
//           cells: <DataCell>[
//             DataCell(Text('Sarah')),
//             DataCell(Text('19')),
//             DataCell(Text('Student')),
//           ],
//         ),
//         DataRow(
//           cells: <DataCell>[
//             DataCell(Text('Janine')),
//             DataCell(Text('43')),
//             DataCell(Text('Professor')),
//           ],
//         ),
//         DataRow(
//           cells: <DataCell>[
//             DataCell(Text('William')),
//             DataCell(Text('27')),
//             DataCell(TableActionButton(
//                 action: "user",
//                 id: 1,
//                 textButton: 'Sign in')),
//           ],
//         ),
//       ]*/
//               ,
//             )));
//   }

//   // buildColumns(Map<String, String> map) {}
//   List<DataColumn> buildColumns(Map<String, String> rowList) {
//     List<DataColumn> columns = [];
//     rowList.forEach((column, columnName) {
//       columns.add(DataColumn(
//         label: Text(
//           columnName,
//           style: TextStyle(
//               fontStyle: FontStyle.normal, fontWeight: FontWeight.bold),
//         ),
//       ));
//     });

//     columns.add(DataColumn(
//       label: Text(
//         'Func',
//         style:
//             TextStyle(fontStyle: FontStyle.normal, fontWeight: FontWeight.bold),
//       ),
//     ));
//     return columns;
//   }

//   List<DataRow> buildDataRows(Map<String, String> rowList, String jsonData) {
//     List<DataRow> rows = [];

//     Map<String, dynamic> body = jsonDecode(jsonData);
//     if (body['items'] != null) {
//       // print(body['items'].runtimeType);
//       body['items'].forEach((elm) {
//         List<DataCell> cells = [];
//         rowList.forEach((columnName, columnTitle) {
//           cells.add(DataCell(Text((elm[columnName] ?? '').toString())));
//         });
//         cells.add(DataCell(TableActionButton(
//             action: "user",
//             id: elm['id'],
//             textButton: 'Edit',
//             data: elm,
//             columns: rowList)));
//         // <DataCell>[
//         //   DataCell(Text(elm['name'] ?? '')),
//         //   DataCell(Text(elm['address'] ?? '')),
//         //   DataCell(
//         //       TableActionButton(action: "user", id: elm['id'], textButton: 'Edit')),
//         // ]

//         rows.add(new DataRow(cells: cells));
//       });
//     }
//     // print(body);
//     // int id = 0;

//     // for (var i = 0; i < 5; i++) {
//     // new empty row

//     // rows.add(new DataRow(cells: <DataCell>[
//     //   DataCell(Text('William')),
//     //   DataCell(Text('27')),
//     //   DataCell(TableActionButton(action: "user", id: 1, textButton: 'Sign in')),
//     // ]));
//     // }

//     return rows;
//   }

//   onButtonClicked(int id) {
//     // this id ^ variable is the one coming from any clicked button
//     // use it e.g. to compare with any other variables from State
//     print("clicked button $id");
//   }
// }
