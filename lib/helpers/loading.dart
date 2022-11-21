import 'package:flutter/material.dart';
import 'package:flutter_demo/helpers/responsive.dart';
import 'package:flutter_demo/screens/navbar/header.dart';
import 'package:flutter_demo/screens/navbar/side_menu.dart';

Scaffold loadingCircleProcess(BuildContext context, String processText) {
  return Scaffold(
    body: SafeArea(
        child: Column(children: [
      Header(),
      Padding(
        padding: const EdgeInsets.all(40.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Center(
              child: Text(
                processText,
                style: Theme.of(context).textTheme.headline6,
              ),
            ),
            Center(
              child: CircularProgressIndicator(
                semanticsLabel: 'Linear progress indicator',
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
    ])),
  );
}

Scaffold loadingOnlyCircle(BuildContext context, String processText) {
  return Scaffold(
    body: SafeArea(
        child: Column(children: [
      Header(),
      Padding(
        padding: const EdgeInsets.all(40.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Center(
              child: Text(
                processText,
                style: Theme.of(context).textTheme.headline6,
              ),
            ),
            Center(
              child: CircularProgressIndicator(
                semanticsLabel: 'Linear progress indicator',
              ),
            ),
          ],
        ),
      ),
    ])),
  );
}

Scaffold loadingLoginProcess(BuildContext context, String processText) {
  return Scaffold(
    body: Padding(
      padding: const EdgeInsets.all(40.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Center(
            child: Text(
              processText,
              style: Theme.of(context).textTheme.headline6,
            ),
          ),
          Center(
            child: CircularProgressIndicator(
              semanticsLabel: 'Linear progress indicator',
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
