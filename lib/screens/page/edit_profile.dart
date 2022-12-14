import 'dart:convert';
import 'dart:io';
import 'dart:ui';

import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_demo/controller/MenuController.dart';
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
  XFile? choosedImage;

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
    if (passwordController.text.isNotEmpty || choosedImage != null) {
      if (passwordController.text.isNotEmpty) {
        body['password'] = passwordController.text;
        body['repassword'] = rePasswordController.text;
      }

      var responseMessage;
      if (choosedImage == null) {
        responseMessage = await Utils.editProfile(body);
      } else {
        responseMessage = await Utils.editProfileWithImage(
            body, await (choosedImage!.readAsBytes()),
            fileName: choosedImage!.name);
      }

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
        // appBar: AppBar(
        //   backgroundColor: Color.fromARGB(255, 26, 115, 232),
        //   title: Text("Sửa tài khoản"),
        // ),
        key: scaffoldKey,
        drawer: SideMenu(),
        body: DefaultContainer(
            headerText: 'Chỉnh sửa hồ sơ',
            backIcon: true,
            child: Stack(
              children: [
                SingleChildScrollView(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        renderImageWidget(),
                        Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Align(
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
                            ],
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 15),
                              child: TextFormField(
                                enabled: false,
                                decoration: InputDecoration(
                                    contentPadding: EdgeInsets.all(15),
                                    border: OutlineInputBorder(
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(2.0))),
                                    labelText: 'Tên nhân viên',
                                    hintText: 'Tên nhân viên'),
                                controller: fullNameController,
                              ),
                            ),
                            SizedBox(
                              height: 8,
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 15),
                              child: TextFormField(
                                enabled: false,
                                decoration: InputDecoration(
                                    suffixIcon: Icon(
                                      Icons.person,
                                      size: 18,
                                    ),
                                    contentPadding: EdgeInsets.all(15),
                                    border: OutlineInputBorder(
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(2.0))),
                                    labelText: 'Tên tài khoản',
                                    hintText: 'Tên tài khoản'),
                                controller: userNameController,
                              ),
                            ),
                            SizedBox(
                              height: 8,
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 15),
                              child: TextFormField(
                                obscureText: true,
                                decoration: InputDecoration(
                                    suffixIcon: Icon(
                                      Icons.password,
                                      size: 18,
                                    ),
                                    contentPadding: EdgeInsets.all(15),
                                    border: OutlineInputBorder(
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(2.0))),
                                    labelText: 'Mật khẩu',
                                    hintText: 'Không cập nhật thì để trống!'),
                                controller: passwordController,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 15, vertical: 6),
                              child: TextFormField(
                                obscureText: true,
                                decoration: InputDecoration(
                                    suffixIcon: Icon(
                                      Icons.password,
                                      size: 18,
                                    ),
                                    contentPadding: EdgeInsets.all(15),
                                    border: OutlineInputBorder(
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(2.0))),
                                    labelText: 'Nhập lại mật khẩu',
                                    hintText: 'Nhập lại mật khẩu'),
                                controller: rePasswordController,
                              ),
                            ),
                          ],
                        ),
                        Utils.renderDivider(),
                        GestureDetector(
                          onTap: () async {
                            if (_formKey.currentState!.validate()) {
                              await updateProfile();
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
                                  'Cập nhật',
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

  renderImageWidget() {
    if (choosedImage != null || Utils.getAccount().imageurl != null) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    'Ảnh đại diện',
                    style: Theme.of(context)
                        .textTheme
                        .bodyLarge
                        ?.copyWith(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                ),
                Expanded(
                  child: Align(
                    alignment: Alignment.topRight,
                    child: GestureDetector(
                      onTap: () async {
                        var file = await ImagePicker.platform.getImage(
                          source: ImageSource.gallery,
                          maxWidth: null,
                          maxHeight: null,
                          imageQuality: null,
                          preferredCameraDevice: CameraDevice.rear,
                        );

                        if (file != null) {
                          setState(() {
                            choosedImage = file;
                          });
                        }
                      },
                      child: Text(
                        'Sửa',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: Colors.blueAccent,
                            fontWeight: FontWeight.normal,
                            fontSize: 14),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: (choosedImage != null)
                  ? CircleAvatar(
                      radius: MediaQuery.of(context).size.width / 5,
                      backgroundImage: FileImage(File(choosedImage!.path)),
                      onBackgroundImageError: (_, __) {},
                    )
                  : CircleAvatar(
                      radius: MediaQuery.of(context).size.width / 5,
                      backgroundImage:
                          NetworkImage(Utils.getAccount().imageurl!),
                      onBackgroundImageError: (_, __) {},
                    ),
            ),
          ),
          Utils.renderDivider(),
        ],
      );
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              Align(
                alignment: Alignment.topLeft,
                child: Text(
                  'Ảnh đại diện',
                  style: Theme.of(context)
                      .textTheme
                      .bodyLarge
                      ?.copyWith(fontWeight: FontWeight.bold, fontSize: 20),
                ),
              ),
              Expanded(
                child: Align(
                  alignment: Alignment.topRight,
                  child: GestureDetector(
                    onTap: () async {
                      var file = await ImagePicker.platform.getImage(
                        source: ImageSource.gallery,
                        maxWidth: null,
                        maxHeight: null,
                        imageQuality: null,
                        preferredCameraDevice: CameraDevice.rear,
                      );

                      if (file != null) {
                        setState(() {
                          choosedImage = file;
                        });
                      }
                    },
                    child: Text(
                      'Sửa',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: Colors.blueAccent,
                          fontWeight: FontWeight.normal,
                          fontSize: 14),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
            child: CircleAvatar(
              radius: MediaQuery.of(context).size.width / 5,
              backgroundImage: AssetImage("assets/images/profile.png"),
              onBackgroundImageError: (_, __) {},
            ),
          ),
        ),
        Utils.renderDivider(),
      ],
    );
  }
}
