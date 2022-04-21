import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_demo/controller/MenuController.dart';
import 'package:flutter_demo/screens/page/detail_page.dart';
import 'package:flutter_demo/screens/login/login.dart';
import 'package:flutter_demo/widget/tablebutton.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        textTheme: GoogleFonts.poppinsTextTheme(Theme.of(context).textTheme)
            .apply(bodyColor: Color.fromARGB(255, 0, 0, 0)),
      ),
      // theme: ThemeData.dark().copyWith(
      //   scaffoldBackgroundColor: Color.fromARGB(255, 0, 0, 0),
      //   textTheme: GoogleFonts.poppinsTextTheme(Theme.of(context).textTheme)
      //       .apply(bodyColor: Color.fromARGB(255, 255, 255, 255)),
      //   canvasColor: Color.fromARGB(255, 0, 188, 245),
      // ),
      debugShowCheckedModeBanner: false,
      // home: LoginDemo(),
      home: MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (context) => MenuController(),
          ),
        ],
        child: LoginScreen(),
      ),
    );
  }
}
