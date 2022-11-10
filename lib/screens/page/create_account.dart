import 'dart:convert';
import 'dart:ui';

import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_demo/controller/MenuController.dart';
import 'package:flutter_demo/models/account.dart';
import 'package:flutter_demo/models/phongban.dart';
import 'package:flutter_demo/screens/navbar/side_menu.dart';
import 'package:flutter_demo/widget/default_container.dart';
import 'package:intl/intl.dart';
import 'package:localstorage/localstorage.dart';
import 'package:flutter_demo/helpers/utils.dart';
import 'package:provider/provider.dart';

class CreateAccount extends StatefulWidget {
  const CreateAccount();

  @override
  _CreateAccountState createState() => _CreateAccountState();
}

class _CreateAccountState extends State<CreateAccount> {
  final _formKey = GlobalKey<FormState>();
  PhongBan selectedPhongBan;
  List<PhongBan> listPhongBan = [];
  bool processing = false;
  static String message = '';

  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    await Utils.initConfig();

    Map<String, dynamic> formData = {};

    List<dynamic> listData =
        await Utils.getListWithForm('phongbanlist.php', formData);

    setState(() {
      listPhongBan = PhongBan.fromJsonList(listData);
      processing = false;
    });
  }

  Future<void> createAccount() async {
    setState(() {
      processing = true;
    });
    var body = {
      'phongban_id': selectedPhongBan.id.toString(),
      'name': fullNameController.text.trim(),
      'username': userNameController.text.trim(),
      'password': passwordController.text.trim(),
      'active': '0'
    };
    var responseMessage = await Utils.createAccount(body);

    setState(() {
      processing = false;
      message = responseMessage;
    });

    Navigator.of(context).restorablePush(showDialog);
  }

  TextEditingController fullNameController = TextEditingController();
  TextEditingController userNameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    if (this.processing) {
      return Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Center(
                child: Text(
                  '',
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
        // appBar: AppBar(
        //   backgroundColor: Color.fromARGB(255, 26, 115, 232),
        //   title: Text("Thêm đơn hàng"),
        // ),
        key: context.read<MenuController>().scaffoldKey,
        drawer: SideMenu(),
        body: DefaultContainer(
            backIcon: true,
            child: Stack(
              children: [
                SingleChildScrollView(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: DropdownSearch<PhongBan>(
                                  validator: (value) {
                                    if (value == null) {
                                      return 'Vui lòng chọn phòng ban';
                                    }
                                    return null;
                                  },
                                  itemAsString: (PhongBan u) => u.toString(),
                                  onChanged: (PhongBan data) async {
                                    selectedPhongBan = data;
                                  },
                                  mode: Mode.DIALOG,
                                  dropdownSearchDecoration: InputDecoration(
                                    border: OutlineInputBorder(),
                                    labelText: "Chọn phòng ban",
                                    hintText: "Chọn phòng ban",
                                  ),
                                  items: listPhongBan,
                                  selectedItem: null,
                                  showSearchBox: true),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: TextFormField(
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Vui lòng nhập vào tên nhân viên';
                                  }

                                  if (!validFullName(value.toString())) {
                                    return 'Tên nhân viên không hợp lệ';
                                  }
                                  return null;
                                },
                                decoration: InputDecoration(
                                    border: OutlineInputBorder(),
                                    labelText: 'Tên nhân viên',
                                    hintText: 'Tên nhân viên'),
                                controller: fullNameController,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: TextFormField(
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Vui lòng nhập vào Email';
                                  }

                                  if (!validEmail(value.toString())) {
                                    return 'Email không hợp lệ';
                                  }
                                  return null;
                                },
                                decoration: InputDecoration(
                                    suffixIcon: Icon(
                                      Icons.person,
                                      size: 18,
                                    ),
                                    border: OutlineInputBorder(),
                                    labelText: 'Tên tài khoản',
                                    hintText: 'Tên tài khoản'),
                                controller: userNameController,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: TextFormField(
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Vui lòng nhập vào mật khẩu';
                                  }

                                  if (value.length < 4) {
                                    return 'Mật khẩu không hợp lệ';
                                  }
                                  return null;
                                },
                                obscureText: true,
                                decoration: InputDecoration(
                                    suffixIcon: Icon(
                                      Icons.password,
                                      size: 18,
                                    ),
                                    border: OutlineInputBorder(),
                                    labelText: 'Mật khẩu',
                                    hintText: 'Mật khẩu'),
                                controller: passwordController,
                              ),
                            ),
                          ],
                        ),
                        Container(
                            padding: const EdgeInsets.all(15.0),
                            height: MediaQuery.of(context).size.height * 0.08,
                            width: MediaQuery.of(context).size.width,
                            child: OutlinedButton(
                              style: OutlinedButton.styleFrom(
                                  backgroundColor:
                                      Color.fromARGB(255, 26, 115, 232),
                                  primary: Color.fromARGB(255, 255, 255, 255)),
                              onPressed: () async {
                                if (_formKey.currentState.validate()) {
                                  await createAccount();
                                }
                              },
                              child: const Text('Lưu',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 20)),
                            )),
                      ],
                    ),
                  ),
                ),
              ],
            )));
  }

  static Route<Object> showDialog(BuildContext context, Object arguments) {
    return DialogRoute<void>(
      context: context,
      builder: (BuildContext context) => AlertDialog(title: Text(message)),
    );
  }
}
