import 'package:flutter/material.dart';
import 'package:flutter_demo/MenuController.dart';
import 'package:flutter_demo/header.dart';
import 'package:flutter_demo/side_menu.dart';
import 'package:provider/provider.dart';

class BaseScreen extends StatelessWidget {
  const BaseScreen({ Key key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: context.read<MenuController>().scaffoldKey,
      drawer: SideMenu(),
      body: _buildBody(),
    );
  }

  _buildBody() {
    return SafeArea(child: Column(children: [
      Header(),
    ]),);
  }
}