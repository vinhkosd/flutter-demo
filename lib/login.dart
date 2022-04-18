import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';
import 'package:flutter_demo/detail_page.dart';
import 'package:flutter_demo/home_page.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_demo/suppliers.dart';
import 'package:flutter_demo/utils.dart';

class LoginDemo extends StatefulWidget {
  @override
  _LoginDemoState createState() => _LoginDemoState();
}

class _LoginDemoState extends State<LoginDemo> {
  final LocalStorage storage = new LocalStorage('test');

  bool processing = false;
  Future<String> _login(_email, _password) async {
    setState(() {
      processing = true;
    });
    if (await Utils.login(_email, _password)) {
      Navigator.push(context, MaterialPageRoute(builder: (_) => Suppliers()));
    } else {
      Navigator.of(context).restorablePush(_dialogBuilder);
    }

    setState(() {
      processing = false;
    });
  }

  TextEditingController _email = TextEditingController();
  TextEditingController _password = TextEditingController();

  @override
  Widget build(BuildContext context) {
    _email.text = "gh@robustaeng.com";
    _password.text = "1";
    if (this.processing) {
      return Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Center(
                child: Text(
                  'Đang đăng nhập ...',
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

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 26, 115, 232),
        title: Text("Login Page"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 60.0),
              child: Center(
                child: Container(
                  width: 200,
                  height: MediaQuery.of(context).size.height * 0.1,
                  /*decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(50.0)),*/
                  child: Image.asset("assets/images/logo.png"),
                ),
              ),
            ),
            Padding(
              //padding: const EdgeInsets.only(left:15.0,right: 15.0,top:0,bottom: 0),
              padding: EdgeInsets.symmetric(
                  horizontal: MediaQuery.of(context).size.width * 0.05),
              child: TextField(
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Email',
                    hintText: 'Enter valid email id as abc@gmail.com'),
                controller: _email,
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: MediaQuery.of(context).size.width * 0.05,
                  vertical: MediaQuery.of(context).size.width * 0.05),
              // padding: const EdgeInsets.only(
              //     left: 15.0, right: 15.0, top: 15, bottom: MediaQuery.of(context).size.width * 0.05),
              //padding: EdgeInsets.symmetric(horizontal: 15),
              child: TextField(
                obscureText: true,
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Password',
                    hintText: 'Enter secure password'),
                controller: _password,
              ),
            ),
            TextButton(
              style: TextButton.styleFrom(
                textStyle:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              onPressed: () {
                print("Forgot password?");
              },
              child: Text(
                'Forgot password?',
                style: TextStyle(
                    color: Color.fromARGB(255, 26, 115, 232), fontSize: 15),
              ),
            ),
            Container(
                height: MediaQuery.of(context).size.height * 0.08,
                width: MediaQuery.of(context).size.width * 0.9,
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                      backgroundColor: Color.fromARGB(255, 26, 115, 232),
                      primary: Color.fromARGB(255, 255, 255, 255)),
                  onPressed: () {
                    print('Sign in');
                    _login(_email.text.trim(), _password.text.trim());
                  },
                  child: const Text('Sign in',
                      style: TextStyle(color: Colors.white, fontSize: 20)),
                )),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.1,
            ),
            TextButton(
              style: TextButton.styleFrom(
                textStyle:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              onPressed: () {
                print("onCreateAccount");
              },
              child: Text(
                'Create account',
                style: TextStyle(
                    color: Color.fromARGB(255, 26, 115, 232), fontSize: 15),
              ),
            )
          ],
        ),
      ),
    );
  }

  static Route<Object> _dialogBuilder(BuildContext context, Object arguments) {
    return DialogRoute<void>(
      context: context,
      builder: (BuildContext context) => const AlertDialog(
          title: Text('Tài khoản hoặc mật khẩu không chính xác!')),
    );
  }
}
