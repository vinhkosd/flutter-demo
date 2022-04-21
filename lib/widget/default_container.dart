import 'package:flutter/material.dart';
import 'package:flutter_demo/helpers/responsive.dart';
import 'package:flutter_demo/screens/navbar/header.dart';
import 'package:flutter_demo/screens/navbar/side_menu.dart';

class DefaultContainer extends StatelessWidget {
  DefaultContainer(
      {@required this.child, this.height, this.width, this.onTap, this.color});
  final Function onTap;
  final Widget child;
  final double height;
  final double width;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      child: SafeArea(
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
                Expanded(
                  child: child,
                )
                // this.child
              ]),
            ),
          ],
        ),
      ),
    );
  }
}
