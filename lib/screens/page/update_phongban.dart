import 'dart:convert';
import 'dart:ui';

import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_demo/controller/MenuController.dart';
import 'package:flutter_demo/controller/UserListController.dart';
import 'package:flutter_demo/models/account.dart';
import 'package:flutter_demo/models/phongban.dart';
import 'package:flutter_demo/screens/navbar/side_menu.dart';
import 'package:flutter_demo/widget/default_container.dart';
import 'package:intl/intl.dart';
import 'package:localstorage/localstorage.dart';
import 'package:flutter_demo/helpers/utils.dart';
import 'package:provider/provider.dart';

import '../../event_bus.dart';

class UpdatePhongBan extends StatefulWidget {
  final PhongBan currentPhongBan;
  UpdatePhongBan(this.currentPhongBan);

  @override
  _UpdatePhongBanState createState() => _UpdatePhongBanState();
}

class _UpdatePhongBanState extends State<UpdatePhongBan> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();
  Account? selectedManager;
  List<Account> listAccount = [];
  bool processing = true;
  static String message = '';

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
    listAccount = context.read<UserListController>().listAccount;

    // widget.currentPhongBan;
    var whereAccount = listAccount
        .where((element) => element.id == widget.currentPhongBan.manager_id);
    selectedManager = whereAccount.isNotEmpty ? whereAccount.first : null;
    nameController.text = widget.currentPhongBan.ten!;
    soPhongController.text = widget.currentPhongBan.so_phong.toString();
    descriptionController.text = widget.currentPhongBan.mo_ta!;
    print(selectedManager);
    setState(() {
      selectedManager;
      processing = false;
    });
  }

  Future<void> createAccount() async {
    setState(() {
      processing = true;
    });
    var body = {
      'id': widget.currentPhongBan.id.toString(),
      'manager_id': selectedManager!.id.toString(),
      'ten': nameController.text.trim(),
      'mo_ta': descriptionController.text.trim(),
      'so_phong': soPhongController.text.trim(),
    };
    var responseMessage = await Utils.updatePhongBan(body);

    setState(() {
      processing = false;
      message = responseMessage;
    });

    Navigator.of(context).restorablePush(showDialog);
  }

  TextEditingController nameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController userNameController = TextEditingController();
  TextEditingController soPhongController = TextEditingController();
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
        // appBar: AppBar(
        //   backgroundColor: Color.fromARGB(255, 26, 115, 232),
        //   title: Text("Thêm đơn hàng"),
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
                              padding: const EdgeInsets.all(12.0),
                              child: Align(
                                alignment: Alignment.topLeft,
                                child: Text(
                                  'Chỉnh sửa thông tin',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyLarge
                                      ?.copyWith(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: TextFormField(
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Vui lòng nhập vào tên phòng ban';
                                  }

                                  if (!validFullName(value.toString())) {
                                    return 'Tên phòng ban không hợp lệ';
                                  }
                                  return null;
                                },
                                decoration: InputDecoration(
                                    border: OutlineInputBorder(),
                                    labelText: 'Tên phòng ban',
                                    hintText: 'Tên phòng ban'),
                                controller: nameController,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: TextFormField(
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Vui lòng nhập vào mô tả phòng ban';
                                  }

                                  return null;
                                },
                                decoration: InputDecoration(
                                    border: OutlineInputBorder(),
                                    labelText: 'Mô tả phòng ban',
                                    hintText: 'Mô tả phòng ban'),
                                controller: descriptionController,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: TextFormField(
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Vui lòng nhập vào số phòng';
                                  }

                                  if (!validNumber(value.toString())) {
                                    return 'Số phòng không hợp lệ';
                                  }
                                  return null;
                                },
                                decoration: InputDecoration(
                                    suffixIcon: Icon(
                                      Icons.person,
                                      size: 18,
                                    ),
                                    border: OutlineInputBorder(),
                                    labelText: 'Số phòng',
                                    hintText: 'Số phòng'),
                                controller: soPhongController,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: DropdownSearch<Account>(
                                  validator: (value) {
                                    if (value == null) {
                                      return 'Vui lòng chọn trưởng phòng';
                                    }
                                    return null;
                                  },
                                  itemAsString: (Account? u) => u.toString(),
                                  onChanged: (Account? data) async {
                                    selectedManager = data;
                                  },
                                  mode: Mode.DIALOG,
                                  dropdownSearchDecoration: InputDecoration(
                                    border: OutlineInputBorder(),
                                    labelText: "Chọn trưởng phòng",
                                    hintText: "Chọn trưởng phòng",
                                  ),
                                  items: listAccount,
                                  selectedItem: selectedManager,
                                  showSearchBox: true),
                            ),
                          ],
                        ),
                        Utils.renderDivider(),
                        GestureDetector(
                          onTap: () async {
                            if (_formKey.currentState!.validate()) {
                              await createAccount();
                            }
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              height: 44,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(3),
                                color: Color.fromARGB(255, 26, 115, 232),
                              ),
                              child: Center(
                                child: Text(
                                  'Lưu',
                                  style: Theme.of(context).textTheme.button!,
                                ),
                              ),
                            ),
                          ),
                        ),
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
