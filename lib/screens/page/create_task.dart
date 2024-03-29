import 'dart:convert';
import 'dart:ui';

import 'package:dropdown_search/dropdown_search.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_demo/controller/MenuController.dart';
import 'package:flutter_demo/controller/UserListController.dart';
import 'package:flutter_demo/models/account.dart';
import 'package:flutter_demo/models/phongban.dart';
import 'package:flutter_demo/screens/navbar/side_menu.dart';
import 'package:flutter_demo/widget/default_container.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:localstorage/localstorage.dart';
import 'package:flutter_demo/helpers/utils.dart';
import 'package:provider/provider.dart';

import '../../event_bus.dart';

class CreateTask extends StatefulWidget {
  const CreateTask();

  @override
  _CreateTaskState createState() => _CreateTaskState();
}

class _CreateTaskState extends State<CreateTask> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();
  bool processing = false;
  static String message = '';
  List<String> filePickeds = [];
  late Account selectedAccount;

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
  }

  Future<void> createAbsent() async {
    setState(() {
      processing = true;
    });
    var body = {
      'ten': tenController.text,
      'mo_ta': moTaController.text,
      'assign_id': selectedAccount.id.toString(),
    };
    var responseMessage = await Utils.createTask(body);
    await Utils.resetFile();

    setState(() {
      processing = false;
      message = responseMessage;
    });

    Navigator.of(context).restorablePush(showDialog);
  }

  Future<void> pickFile() async {
    var result = await FilePicker.platform.pickFiles();
    if (result != null) {
      var bytesFile = result.files.single.bytes;
      if (result.files.single.bytes == null &&
          result.files.single.path != null) {
        var filePicked = XFile(result.files.single.path!);
        bytesFile = await filePicked.readAsBytes();
        Utils.uploadFile(bytesFile, fileName: filePicked.name);

        filePickeds.add(filePicked.name);
        setState(() {
          filePickeds;
        });
      }
    } else {
      // User canceled the picker
    }
  }

  TextEditingController tenController = TextEditingController();
  TextEditingController moTaController = TextEditingController();
  @override
  Widget build(BuildContext context) {
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
                                  'Thông tin chi tiết',
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
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 15),
                              child: TextFormField(
                                decoration: InputDecoration(
                                    contentPadding: EdgeInsets.all(15),
                                    border: OutlineInputBorder(
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(2.0))),
                                    labelText: 'Tên',
                                    hintText: 'Tên'),
                                controller: tenController,
                              ),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 15),
                              child: TextFormField(
                                maxLines: null,
                                decoration: InputDecoration(
                                    contentPadding: EdgeInsets.all(15),
                                    border: OutlineInputBorder(
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(2.0))),
                                    labelText: 'Mô tả',
                                    hintText: 'Mô tả'),
                                controller: moTaController,
                              ),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 15),
                              child: DropdownSearch<Account>(
                                  validator: (value) {
                                    if (value == null) {
                                      return 'Vui lòng chọn người được giao';
                                    }
                                    return null;
                                  },
                                  itemAsString: (Account? u) => u.toString(),
                                  onChanged: (Account? data) async {
                                    selectedAccount = data!;
                                  },
                                  mode: Mode.DIALOG,
                                  dropdownSearchDecoration: InputDecoration(
                                    contentPadding: EdgeInsets.all(15),
                                    border: OutlineInputBorder(
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(2.0))),
                                    labelText: "Người được giao",
                                    hintText: "Chọn người được giao",
                                  ),
                                  items:
                                      context.watch<UserListController>().list,
                                  selectedItem: null,
                                  showSearchBox: true),
                            ),
                            SizedBox(
                              height: 6,
                            ),
                            Utils.renderDivider(),
                            Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Align(
                                    alignment: Alignment.topLeft,
                                    child: Text(
                                      'Tệp đính kèm',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyLarge
                                          ?.copyWith(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 20),
                                    ),
                                  ),
                                  if (filePickeds.isNotEmpty)
                                    Expanded(
                                      child: Align(
                                        alignment: Alignment.topRight,
                                        child: GestureDetector(
                                          onTap: () async {
                                            await Utils.resetAbsentFile();
                                            filePickeds.clear();
                                            setState(() {
                                              filePickeds;
                                            });
                                          },
                                          child: Text(
                                            'Xóa tất cả',
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyLarge
                                                ?.copyWith(
                                                    color: Colors.blueAccent,
                                                    fontWeight:
                                                        FontWeight.normal,
                                                    fontSize: 14),
                                          ),
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                            ...filePickeds
                                .map((e) => Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8.0),
                                      child: Text(' - $e'),
                                    ))
                                .toList(),
                            GestureDetector(
                              onTap: pickFile,
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
                                      'Thêm tệp',
                                      style: Theme.of(context)
                                          .textTheme
                                          .button!
                                          .copyWith(
                                            color: Colors.white,
                                          ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Utils.renderDivider(),
                        GestureDetector(
                          onTap: () async {
                            if (_formKey.currentState!.validate()) {
                              await createAbsent();
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
                                  'Tạo công việc',
                                  style: Theme.of(context)
                                      .textTheme
                                      .button!
                                      .copyWith(
                                        color: Colors.white,
                                      ),
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
