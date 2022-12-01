import 'package:flutter/material.dart';
import 'package:flutter_demo/controller/MenuController.dart';
import 'package:flutter_demo/screens/page/dashboard.dart';
import 'package:flutter_demo/screens/login/login.dart';
import 'package:flutter_demo/screens/page/account_list.dart';
import 'package:flutter_demo/screens/page/phongban_list.dart';
import 'package:flutter_demo/screens/settings/settings.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import '../../helpers/utils.dart';

class SideMenu extends StatelessWidget {
  const SideMenu({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          Column(
            // crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 30.0,
                backgroundImage: Utils.getAccount().imageurl == null
                    ? NetworkImage("https://via.placeholder.com/100x100")
                    : NetworkImage(Utils.getAccount().imageurl!),
              ),
              Divider(),
              Text(Utils.getAccount().name!,
                  style: Theme.of(context)
                      .textTheme
                      .button!
                      .copyWith(fontWeight: FontWeight.bold)),
            ],
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
                  handlePage(context, "edit_profile");
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
          if (Utils.getAccount().role != 'god')
            DrawerListTile(
              title: "Quản lý công việc",
              svgSrc: "assets/icons/menu_doc.svg",
              press: () {
                handlePage(context, "task_list");
              },
            ),
          DrawerListTile(
            title: "Quản lý nghỉ phép",
            svgSrc: "assets/icons/menu_doc.svg",
            press: () {
              handlePage(context, "absent_list");
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
    var routeName;
    switch (page) {
      case "user":
        routeName = "user";
        break;
      case "Dashboard":
        routeName = "home";

        break;
      case "setting":
        routeName = "setting";
        break;
      case "accountlist":
        routeName = "accountlist";
        break;
      case "phongbanlist":
        routeName = "phongbanlist";
        break;
      case "edit_profile":
        routeName = "edit_profile";
        break;
      case "absent_list":
        routeName = "absent_list";
        break;
      case "task_list":
        routeName = "task_list";
        break;
      case "Logout":
        Utils.logout();
        Navigator.of(context)
            .pushNamedAndRemoveUntil('login', (Route<dynamic> route) => false);

        return;
      default:
        routeName = "home";
        break;
    }

    Navigator.of(context).pushNamed(routeName);

    // Navigator.of(context)
    //     .pushNamedAndRemoveUntil(routeName, (Route<dynamic> route) => false);
  }
}

class DrawerListTile extends StatelessWidget {
  const DrawerListTile({
    Key? key,
    required this.title,
    required this.svgSrc,
    required this.press,
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
        color: Theme.of(context).textTheme.button!.color,
        height: 16,
      ),
      title: Text(
        title,
        style: Theme.of(context).textTheme.button!,
      ),
    );
  }
}
