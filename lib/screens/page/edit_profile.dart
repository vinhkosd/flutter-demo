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

import '../../event_bus.dart';
import '../../models/role.dart';

class EditProfile extends StatefulWidget {
  EditProfile();

  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();
  bool processing = true;
  static String message = '';

  TextEditingController rePasswordController = TextEditingController();

  void initState() {
    super.initState();
    loadData();

    eventBus.on<ToggleDrawerEvent>().listen((event) {
      if (!(scaffoldKey.currentState?.isDrawerOpen ?? false))
        scaffoldKey.currentState?.openDrawer();
    });
  }

  Future<void> loadData() async {
    await Utils.initConfig();

    Map<String, dynamic> formData = {};

    List<dynamic> listData =
        await Utils.getListWithForm('phongbanlist.php', formData);

    var currentAccount = Utils.getAccount();

    fullNameController.text = currentAccount.name!;
    userNameController.text = currentAccount.username!;

    setState(() {
      processing = false;
    });
  }

  Future<void> updateProfile() async {
    setState(() {
      processing = true;
    });
    var currentAccount = Utils.getAccount();

    var body = {'id': currentAccount.id.toString()};
    if (passwordController.text.isNotEmpty) {
      body['password'] = passwordController.text;
      body['repassword'] = rePasswordController.text;

      var responseMessage = await Utils.editProfile(body);

      setState(() {
        processing = false;
        message = responseMessage;
      });

      Navigator.of(context).restorablePush(showDialog);
    } else {
      setState(() {
        processing = false;
        message = 'Vui lòng chỉnh sửa thông tin bạn muốn cập nhật';
      });

      Navigator.of(context).restorablePush(showDialog);
    }
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
        //   title: Text("Sửa tài khoản"),
        // ),
        key: scaffoldKey,
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
                              child: TextFormField(
                                enabled: false,
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
                                enabled: false,
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
                                obscureText: true,
                                decoration: InputDecoration(
                                    suffixIcon: Icon(
                                      Icons.password,
                                      size: 18,
                                    ),
                                    border: OutlineInputBorder(),
                                    labelText: 'Mật khẩu',
                                    hintText: 'Không cập nhật thì để trống!'),
                                controller: passwordController,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: TextFormField(
                                obscureText: true,
                                decoration: InputDecoration(
                                    suffixIcon: Icon(
                                      Icons.password,
                                      size: 18,
                                    ),
                                    border: OutlineInputBorder(),
                                    labelText: 'Nhập lại mật khẩu',
                                    hintText: 'Nhập lại mật khẩu'),
                                controller: rePasswordController,
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
                                if (_formKey.currentState!.validate()) {
                                  await updateProfile();
                                }
                              },
                              child: const Text('Cập nhật',
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

  static Route<Object?> showDialog(BuildContext context, Object? arguments) {
    return DialogRoute<void>(
      context: context,
      builder: (BuildContext context) => AlertDialog(title: Text(message)),
    );
  }
}
