import 'package:flutter/material.dart';
import 'package:flutter_demo/controller/MenuController.dart';
import 'package:flutter_demo/helpers/responsive.dart';
import 'package:flutter_demo/screens/navbar/header.dart';
import 'package:flutter_demo/screens/navbar/side_menu.dart';
import 'package:provider/provider.dart';

class DefaultContainer extends Container {
  // final Widget child;

  // const DefaultContainer(
  //     {this.child});
  // const DefaultContainer({ Key key, this.child }) : super(key: key);

 DefaultContainer({
  Key key,
  child,
}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: context.read<MenuController>().scaffoldKey,
      drawer: SideMenu(),
      // appBar: AppBar(
      //   title: Text("Suppliers"),
      // ),
      body: _buildBody(context),
    );
  }

  _buildBody(context) {
    return SafeArea(
      child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // We want this side menu only for large screen
            if (Responsive.isDesktop(context))
              Expanded(
                // default flex = 1
                // and it takes 1/6 part of the screen
                child: SideMenu(),
              ),
            Expanded(
              // It takes 5/6 part of the screen
              flex: 5,
              child: Column(children: [
                Header(), 
                child
                // this.child
              ]),
            ),
          ],
        ),
    );
  }
}