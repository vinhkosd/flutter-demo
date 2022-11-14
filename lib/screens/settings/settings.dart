import 'package:flutter/material.dart';
import 'package:flutter_demo/controller/MenuController.dart';
import 'package:flutter_demo/helpers/loading.dart';
import 'package:flutter_demo/screens/navbar/side_menu.dart';
import 'package:flutter_demo/widget/default_container.dart';
import 'package:provider/provider.dart';
import 'package:dropdown_search/dropdown_search.dart';

import '../../event_bus.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  bool processing = false;

  TextEditingController _language = TextEditingController();
  TextEditingController _password = TextEditingController();

  @override
  void initState() {
    super.initState();

    eventBus.on<ToggleDrawerEvent>().listen((event) {
      if (!scaffoldKey.currentState.isDrawerOpen)
        scaffoldKey.currentState.openDrawer();
    });
  }

  @override
  Widget build(BuildContext context) {
    if (this.processing) {
      return loadingLoginProcess(context, "Đang đăng nhập");
    }

    return Scaffold(
      key: scaffoldKey,
      drawer: SideMenu(),
      backgroundColor: Colors.white,
      body: DefaultContainer(
          child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 60.0),
              child: Center(
                child: Container(
                  width: 200,
                  height: MediaQuery.of(context).size.height * 0.1,
                  child: Image.asset("assets/images/logo.png"),
                ),
              ),
            ),
            Padding(
              //padding: const EdgeInsets.only(left:15.0,right: 15.0,top:0,bottom: 0),
              padding: EdgeInsets.symmetric(
                  horizontal: MediaQuery.of(context).size.width * 0.05),
              child: DropdownSearch<String>(
                mode: Mode.MENU,
                showSelectedItems: true,
                items: ["English", "Japanese", "Chinese", 'Vietnamese'],
                dropdownSearchDecoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Chọn ngôn ngữ",
                  hintText: "choose your language display",
                ),
                // popupItemDisabled: (String s) => s.startsWith('I'),
                onChanged: (String value) {
                  _language.text = value;
                },
                selectedItem: _language.text,
                // searchBoxController: _language,
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: MediaQuery.of(context).size.width * 0.05,
                  vertical: MediaQuery.of(context).size.width * 0.05),
              child: TextField(
                // obscureText: true,
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Enter smthing',
                    hintText: 'Enter somethings'),
                controller: _password,
              ),
            ),
            Container(
                height: MediaQuery.of(context).size.height * 0.08,
                width: MediaQuery.of(context).size.width * 0.9,
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                      backgroundColor: Color.fromARGB(255, 26, 115, 232),
                      primary: Color.fromARGB(255, 255, 255, 255)),
                  onPressed: () {
                    print(_language.text.trim());
                    print(_password.text.trim());
                  },
                  child: const Text('Update',
                      style: TextStyle(color: Colors.white, fontSize: 20)),
                )),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.1,
            ),
          ],
        ),
      )),
    );
  }

  static Route<Object> _dialogBuilder(BuildContext context, Object arguments) {
    return DialogRoute<void>(
      context: context,
      builder: (BuildContext context) => const AlertDialog(
          title: Text('Tài khoản hoặc mật khẩu không chính xác!')),
    );
  }
}
