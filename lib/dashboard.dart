import 'package:flutter/material.dart';
import 'package:flutter_demo/MenuController.dart';
import 'package:flutter_demo/header.dart';
import 'package:flutter_demo/side_menu.dart';
import 'package:flutter_demo/storage_details.dart';
import 'package:provider/provider.dart';

// class DashboardScreen extends StatelessWidget {
//   const DashboardScreen({ Key key }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       key: context.read<MenuController>().scaffoldKey,
//       drawer: SideMenu(),
//       body: _buildBody(),
//     );
//   }

//   _buildBody() {
//     return SafeArea(child: Column(children: [
//       Header(),
//       StarageDetails()
//     ]),);
//   }
// }
class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key key}) : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: context.read<MenuController>().scaffoldKey,
      drawer: SideMenu(),
      // appBar: AppBar(
      //   title: Text("Suppliers"),
      // ),
      body: _buildBody(),
    );
  }

  _buildBody() {
    return SafeArea(
      child: Column(children: [Header(), StarageDetails()]),
    );
  }
}
