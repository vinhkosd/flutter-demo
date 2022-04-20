import 'package:flutter/material.dart';
import 'package:flutter_demo/controller/MenuController.dart';
import 'package:flutter_demo/screens/page/WareHouses.dart';
import 'package:flutter_demo/screens/page/companies.dart';
import 'package:flutter_demo/screens/page/customers.dart';
import 'package:flutter_demo/screens/page/dashboard.dart';
import 'package:flutter_demo/screens/page/home_page.dart';
import 'package:flutter_demo/screens/login/login.dart';
import 'package:flutter_demo/screens/page/projects.dart';
import 'package:flutter_demo/screens/page/suppliers.dart';
import 'package:flutter_demo/screens/page/user.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

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
            title: Text('Thiết lập'),
            children: <Widget>[
              DrawerListTile(
                title: "Kho",
                svgSrc: "assets/icons/menu_store.svg",
                press: () {
                  handlePage(context, "warehouses");
                },
              ),
              DrawerListTile(
                title: "Nhà cung cấp",
                svgSrc: "assets/icons/menu_store.svg",
                press: () {
                  handlePage(context, "Suppliers");
                },
              ),
              DrawerListTile(
                title: "Nhóm sản phẩm",
                svgSrc: "assets/icons/menu_store.svg",
                press: () {
                  handlePage(context, "product-groups");
                },
              ),
              DrawerListTile(
                title: "Sản phẩm",
                svgSrc: "assets/icons/menu_store.svg",
                press: () {
                  handlePage(context, "products");
                },
              ),
              DrawerListTile(
                title: "Doanh nghiệp",
                svgSrc: "assets/icons/menu_store.svg",
                press: () {
                  handlePage(context, "companies");
                },
              ),
            ],
          ),
          ExpansionTile(
            title: Text('Kiểm kê'),
            children: <Widget>[
              DrawerListTile(
                title: "Tồn kho",
                svgSrc: "assets/icons/menu_store.svg",
                press: () {
                  handlePage(context, "product-stock");
                },
              ),
              DrawerListTile(
                title: "Giao dịch nhà cung cấp",
                svgSrc: "assets/icons/menu_tran.svg",
                press: () {
                  handlePage(context, "supplier-transactions");
                },
              ),
              DrawerListTile(
                title: "Chuyển nội bộ",
                svgSrc: "assets/icons/menu_store.svg",
                press: () {
                  handlePage(context, "internal-transfer");
                },
              ),
              DrawerListTile(
                title: "Giao dịch khách hàng",
                svgSrc: "assets/icons/menu_tran.svg",
                press: () {
                  handlePage(context, "customer-transactions");
                },
              ),
              DrawerListTile(
                title: "Xuất nhập tồn kho ngay",
                svgSrc: "assets/icons/menu_store.svg",
                press: () {
                  handlePage(context, "stock-daily");
                },
              ),
            ],
          ),
          ExpansionTile(
            title: Text('Kế toán'),
            children: <Widget>[
              DrawerListTile(
                title: "Duyệt đơn hàng nhà cung cấp",
                svgSrc: "assets/icons/menu_file.svg",
                press: () {
                  handlePage(context, "approve-order-suppliers");
                },
              ),
              DrawerListTile(
                title: "Thu ngân",
                svgSrc: "assets/icons/menu_store.svg",
                press: () {
                  handlePage(context, "cashier");
                },
              ),
            ],
          ),
          ExpansionTile(
            title: Text('Bán hàng'),
            children: <Widget>[
              DrawerListTile(
                title: "Đơn hàng",
                svgSrc: "assets/icons/menu_store.svg",
                press: () {
                  handlePage(context, "orders");
                },
              ),
              DrawerListTile(
                title: "Phiếu thu",
                svgSrc: "assets/icons/menu_store.svg",
                press: () {
                  handlePage(context, "receipts");
                },
              ),
              DrawerListTile(
                title: "Giao hàng",
                svgSrc: "assets/icons/menu_store.svg",
                press: () {
                  handlePage(context, "delivery");
                },
              ),
            ],
          ),
          ExpansionTile(
            title: Text('Danh mục'),
            children: <Widget>[
              DrawerListTile(
                title: "Người dùng",
                svgSrc: "assets/icons/menu_profile.svg",
                press: () {
                  handlePage(context, "user");
                },
              ),
              DrawerListTile(
                title: "Khách hàng",
                svgSrc: "assets/icons/menu_store.svg",
                press: () {
                  handlePage(context, "customers");
                },
              ),
              DrawerListTile(
                title: "Dự án",
                svgSrc: "assets/icons/menu_store.svg",
                press: () {
                  handlePage(context, "projects");
                },
              ),
              DrawerListTile(
                title: "Hành chính",
                svgSrc: "assets/icons/menu_store.svg",
                press: () {
                  handlePage(context, "national-administrative-directory");
                },
              ),
            ],
          ),
          DrawerListTile(
            title: "Settings",
            svgSrc: "assets/icons/menu_setting.svg",
            press: () {
              handlePage(context, "Settings");
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
      case "companies":
        childPage = Companies();
        break;
      case "customers":
        childPage = Customers();
        break;
      case "user":
        childPage = Users();
        break;
      case "Dashboard":
        childPage = DashboardScreen();
        break;
      case "warehouses":
        childPage = WareHouses();
        break;
      case "projects":
        childPage = Projects();
        break;
      case "Suppliers":
        childPage = Suppliers();
        break;
      case "Logout":
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => LoginDemo()),
            (Route<dynamic> route) => false);
        childPage = LoginDemo();
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
    // For selecting those three line once press "Command+D"
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
