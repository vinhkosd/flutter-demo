import 'package:flutter/material.dart';
import 'package:flutter_demo/controller/MenuController.dart';
import 'package:flutter_demo/screens/page/dashboard.dart';
import 'package:flutter_demo/screens/login/login.dart';
import 'package:flutter_demo/screens/page/account_list.dart';
import 'package:flutter_demo/screens/page/phongban_list.dart';
import 'package:flutter_demo/screens/page/user.dart';
import 'package:flutter_demo/screens/settings/settings.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import '../../helpers/utils.dart';

class SideMenu extends StatelessWidget {
  const SideMenu({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          DrawerHeader(
            child: Image.asset("assets/images/logo.png"),
          ),
          ExpansionTile(
            title: Text('Quản lý'),
            children: <Widget>[
              if (Utils.getAccount().role == 'god')
                DrawerListTile(
                  title: "Quản lý tài khoản",
                  svgSrc: "assets/icons/menu_store.svg",
                  press: () {
                    handlePage(context, "accountlist");
                  },
                ),
              if (Utils.getAccount().role == 'god')
                DrawerListTile(
                  title: "Quản lý phòng ban",
                  svgSrc: "assets/icons/menu_store.svg",
                  press: () {
                    handlePage(context, "phongbanlist");
                  },
                ),
              DrawerListTile(
                title: "Sửa thông tin tài khoản",
                svgSrc: "assets/icons/menu_store.svg",
                press: () {
                  handlePage(context, "orders");
                },
              ),
            ],
          ),
          DrawerListTile(
            title: "Settings",
            svgSrc: "assets/icons/menu_setting.svg",
            press: () {
              handlePage(context, "setting");
            },
          ),
          if (Utils.getAccount().role == 'god')
            DrawerListTile(
              title: "Quản lý nghỉ phép",
              svgSrc: "assets/icons/menu_doc.svg",
              press: () {
                handlePage(context, "trello");
              },
            ),
          DrawerListTile(
            title: "Logout",
            svgSrc: "assets/icons/logout.svg",
            press: () {
              handlePage(context, "Logout");
            },
          ),
        ],
      ),
    );
  }

  void handlePage(BuildContext context, String page) {
    var childPage;
    switch (page) {
      case "user":
        childPage = Users();
        break;
      case "Dashboard":
        childPage = DashboardScreen();
        break;
      case "setting":
        childPage = SettingsPage();
        break;
      case "accountlist":
        childPage = AccountList();
        break;
      case "phongbanlist":
        childPage = PhongBanList();
        break;
      case "Logout":
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => LoginScreen()),
            (Route<dynamic> route) => false);
        childPage = LoginScreen();
        return;
        break;
      default:
        childPage = DashboardScreen();
        break;
    }

    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (_) => MultiProvider(
                  providers: [
                    ChangeNotifierProvider(
                      create: (context) => MenuController(),
                    ),
                  ],
                  child: childPage,
                )));
  }
}

class DrawerListTile extends StatelessWidget {
  const DrawerListTile({
    Key key,
    @required this.title,
    @required this.svgSrc,
    @required this.press,
  }) : super(key: key);

  final String title, svgSrc;
  final VoidCallback press;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: press,
      horizontalTitleGap: 0.0,
      leading: SvgPicture.asset(
        svgSrc,
        color: Color.fromARGB(255, 0, 0, 0),
        height: 16,
      ),
      title: Text(
        title,
        style: TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
      ),
    );
  }
}
