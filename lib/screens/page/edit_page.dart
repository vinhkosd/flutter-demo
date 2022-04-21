import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';
import 'package:flutter_demo/helpers/utils.dart';

class EditPage extends StatefulWidget {
  final int id;
  final String action;
  final Map<String, dynamic> data;
  final Map<String, dynamic> columns;

  const EditPage({this.id, this.action, this.data, this.columns});

  @override
  _EditPageState createState() => _EditPageState(
      id: this.id, action: this.action, data: this.data, columns: this.columns);
}

class _EditPageState extends State<EditPage> {
  final int id;
  final String action;
  final Map<String, dynamic> data;
  final Map<String, dynamic> columns;
  bool processing = false;
  _EditPageState({this.id, this.action, this.data, this.columns});

  void initState() {
    super.initState();
  }

  final LocalStorage storage = new LocalStorage('test');
  Future<String> _testSubmit(
      Map<String, TextEditingController> listCtrl) async {
    setState(() {
      processing = true;
    });

    Map<String, dynamic> body = await Utils.postWithCtrl('test', listCtrl);

    setState(() {
      processing = true;
    });
  }

  @override
  Map<String, TextEditingController> listCtrl = {};
  List<Widget> listInputs = [];
  int firstBuild = 0;
  void widgetOnMount() {
    if (firstBuild == 0) {
      this.columns.forEach((columnName, columnTitle) {
        listCtrl[columnName] = TextEditingController();
        listCtrl[columnName].text = (data[columnName] ?? '').toString();
        listInputs.add(Padding(
          padding: EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.width * 0.05,
              vertical: MediaQuery.of(context).size.width * 0.02),
          child: TextField(
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: columnTitle,
            ),
            controller: listCtrl[columnName],
          ),
        ));
      });
      firstBuild++;
    }
  }

  Widget build(BuildContext context) {
    widgetOnMount();

    if (this.processing) {
      return Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Center(
                child: Text(
                  'Đang sửa ...',
                  style: Theme.of(context).textTheme.headline6,
                ),
              ),
              Center(
                child: LinearProgressIndicator(
                  semanticsLabel: 'Linear progress indicator',
                ),
              )
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 26, 115, 232),
        title: Text("Edit data"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 60.0, bottom: 40.0),
              child: Center(
                  child: Text(
                'EDIT DATA',
                style: TextStyle(
                    color: Color.fromARGB(255, 26, 115, 232), fontSize: 15),
              )),
            ),
            Column(
              children: listInputs,
            ),
            Container(
                height: MediaQuery.of(context).size.height * 0.08,
                width: MediaQuery.of(context).size.width * 0.9,
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                      backgroundColor: Color.fromARGB(255, 26, 115, 232),
                      primary: Color.fromARGB(255, 255, 255, 255)),
                  onPressed: () {
                    _testSubmit(listCtrl);
                  },
                  child: const Text('Edit data',
                      style: TextStyle(color: Colors.white, fontSize: 20)),
                )),
            SizedBox(
                height: MediaQuery.of(context).size.height * 0.1,
                child: Image(image: AssetImage('assets/images/logo.png'))),
          ],
        ),
      ),
    );
  }
}
