import 'dart:convert';
import 'dart:isolate';
import 'dart:ui';

import 'package:dropdown_search/dropdown_search.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_demo/controller/MenuController.dart';
import 'package:flutter_demo/controller/UserListController.dart';
import 'package:flutter_demo/models/account.dart';
import 'package:flutter_demo/models/phongban.dart';
import 'package:flutter_demo/models/task.dart';
import 'package:flutter_demo/screens/navbar/side_menu.dart';
import 'package:flutter_demo/widget/default_container.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:localstorage/localstorage.dart';
import 'package:flutter_demo/helpers/utils.dart';
import 'package:provider/provider.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

import '../../env.dart';
import '../../event_bus.dart';

class UpdateTask extends StatefulWidget {
  final Task task;
  const UpdateTask(this.task);

  @override
  _UpdateTaskState createState() => _UpdateTaskState();
}

class _UpdateTaskState extends State<UpdateTask> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();
  bool processing = false;
  static String message = '';
  List<String> filePickeds = [];
  late Account selectedAccount;
  late TextEditingController tenController;
  late TextEditingController moTaController;
  var _port;

  void initState() {
    super.initState();
    tenController = TextEditingController(text: widget.task.ten);
    moTaController = TextEditingController(text: widget.task.mo_ta);
    var whereAccount = context
        .read<UserListController>()
        .list
        .where((element) => element.id == widget.task.assign_id);
    if (whereAccount.isNotEmpty) selectedAccount = whereAccount.first;
    loadData();
    eventBus.on<ToggleDrawerEvent>().listen((event) {
      if (!(scaffoldKey.currentState?.isDrawerOpen ?? false))
        scaffoldKey.currentState?.openDrawer();
    });

    if (defaultTargetPlatform == TargetPlatform.iOS ||
        defaultTargetPlatform == TargetPlatform.android) {
      _port = ReceivePort();
      IsolateNameServer.registerPortWithName(
          _port.sendPort, 'downloader_send_port');
      _port.listen(listenIsolateServer);

      FlutterDownloader.registerCallback(downloadCallback);
    }
  }

  static void downloadCallback(
      String id, DownloadTaskStatus status, int progress) {
    final send = IsolateNameServer.lookupPortByName('downloader_send_port');
    send!.send([id, status, progress]);
  }

  void listenIsolateServer(dynamic data) {
    String id = data[0];
    DownloadTaskStatus status = data[1];
    int progress = data[2];
    debugPrint('progress $progress');

    if (status == DownloadTaskStatus.complete) {
      showTopSnackBar(
        Overlay.of(context)!,
        CustomSnackBar.success(
          message: 'Tải xuống thành công!',
        ),
      );
    } else if (status == DownloadTaskStatus.failed) {
      showTopSnackBar(
        Overlay.of(context)!,
        CustomSnackBar.error(
          message: 'Tải xuống thất bại!',
        ),
      );
    } else if (status == DownloadTaskStatus.running) {}
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
                                  selectedItem: selectedAccount,
                                  showSearchBox: true),
                            ),
                            SizedBox(
                              height: 6,
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 15),
                              child: TextFormField(
                                initialValue: widget.task.renderStatus(),
                                decoration: InputDecoration(
                                    contentPadding: EdgeInsets.all(15),
                                    border: OutlineInputBorder(
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(2.0))),
                                    labelText: 'Mức độ hoàn thành',
                                    hintText: 'Mức độ hoàn thành'),
                                enabled: false,
                                readOnly: true,
                              ),
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
                                  if (widget.task.attachment.isNotEmpty)
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
                            if (widget.task.attachment.isNotEmpty)
                              ...widget.task.attachment
                                  .map((e) => GestureDetector(
                                        onTap: () async {
                                          Utils.download('$hostUrl/$e');
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 2.0, horizontal: 8.0),
                                          child: Text(
                                            '${Utils.getFileNameFromUrl('$hostUrl/$e')}',
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
                                      ))
                                  .toList(),
                            if (widget.task.attachment.isEmpty)
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8.0),
                                child: Text(' - Không có tệp đính kèm'),
                              ),
                          ],
                        ),
                        Utils.renderDivider(),
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
