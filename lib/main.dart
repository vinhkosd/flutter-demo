import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_demo/controller/MenuController.dart';
import 'package:flutter_demo/screens/login/first_login.dart';
import 'package:flutter_demo/screens/login/login.dart';
import 'package:flutter_demo/screens/page/account_list.dart';
import 'package:flutter_demo/screens/page/dashboard.dart';
import 'package:flutter_demo/screens/page/phongban_list.dart';
import 'package:flutter_demo/screens/settings/settings.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';

void main() => runApp(MyApp());

//
//                       _oo0oo_
//                      o8888888o
//                      88" . "88
//                      (| -_- |)
//                      0\  =  /0
//                    ___/`---'\___
//                  .' \\|     |// '.
//                 / \\|||  :  |||// \
//                / _||||| -:- |||||- \
//               |   | \\\  -  /// |   |
//               | \_|  ''\---/''  |_/ |
//               \  .-\__  '-'  ___/-. /
//             ___'. .'  /--.--\  `. .'___
//          ."" '<  `.___\_<|>_/___.' >' "".
//         | | :  `- \`.;`\ _ /`;.`/ - ` : | |
//         \  \ `_.   \_ __\ /__ _/   .-` /  /
//     =====`-.____`.___ \_____/___.-`___.-'=====
//                       `=---='
//
//
//     ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
//
//               佛祖保佑         永无BUG
//

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => MenuController(),
        ),
      ],
      child: MaterialApp(
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
        home: LoginScreen(),
        routes: {
          'home': (context) => const DashboardScreen(),
          'login': (context) => LoginScreen(),
          'firstlogin': (context) => FirstLoginScreen(),
          'accountlist': (context) => AccountList(),
          'phongbanlist': (context) => PhongBanList(),
          'setting': (context) => SettingsPage(),
        },
      ),
    );
  }
}
