import 'package:flutter/material.dart';
import 'package:flutter_demo/screens/page/edit_page.dart';

class TableActionButton extends StatelessWidget {
  final int id;
  final String action;
  final String textButton;
  final Map<String, dynamic> data;
  final Map<String, dynamic> columns;

  const TableActionButton(
      {required this.id,
      required this.action,
      required this.textButton,
      required this.data,
      required this.columns});

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      style: OutlinedButton.styleFrom(
          backgroundColor: Color.fromARGB(255, 26, 115, 232),
          primary: Color.fromARGB(255, 255, 255, 255)),
      onPressed: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (_) => EditPage(
                    id: this.id,
                    action: this.action,
                    data: this.data,
                    columns: this.columns)));
        // return showDialog<String>(
        //   context: context,
        //   builder: (BuildContext context) => AlertDialog(
        //     title: Text("This Action: " + this.action),
        //     content: Text("This Id: " + this.id.toString()),
        //     actions: <Widget>[
        //       TextButton(
        //         onPressed: () => Navigator.pop(context, 'OK'),
        //         child: const Text('OK'),
        //       ),
        //     ],
        //   ),
        // );
      },
      child: Text(this.textButton,
          style: TextStyle(color: Colors.white, fontSize: 15)),
    );
  }
}
