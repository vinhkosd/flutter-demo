import 'package:flutter/material.dart';
import 'package:flutter_demo/controller/MenuController.dart';
import 'package:flutter_demo/screens/page/dashboard.dart';
import 'package:flutter_demo/helpers/loading.dart';
import 'package:flutter_demo/helpers/utils.dart';
import 'package:provider/provider.dart';

import '../../controller/UserController.dart';
import 'first_login.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();

  initState() {
    super.initState();
    setState(() {
      processing = true;
    });
    checkIsFirst();
  }

  checkIsFirst() async {
    var isFirst = await Utils.checkFirstLogin();
    if (isFirst) {
      Navigator.of(context)
          .pushNamedAndRemoveUntil('firstlogin', (route) => false);
      // Navigator.of(context).pushAndRemoveUntil(
      //     MaterialPageRoute(builder: (context) => FirstLoginScreen()),
      //     (Route<dynamic> route) => false);
    } else {
      if (Utils.isLogin()) {
        Navigator.pushNamed(context, 'home');
      } else {
        setState(() {
          processing = false;
        });
      }
    }
  }

  bool processing = false;
  Future<void> _login(_email, _password) async {
    setState(() {
      processing = true;
    });

    if (await Utils.login(_email, _password)) {
      await context.read<UserController>().setCurrentAccount();
      Navigator.pushNamed(context, 'home');
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
    if (this.processing) {
      return loadingOnlyCircle(context, "", showHeader: false);
    }

    return Scaffold(
      body: FutureBuilder<bool>(
          future: Utils.initConfig(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Utils.initScreen();
            }
            return SingleChildScrollView(
                child: Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(top: 60.0),
                    child: Center(
                      child: Container(
                        child: Image.asset("assets/images/logo.png"),
                      ),
                    ),
                  ),
                  // SizedBox(
                  //   child: Container(
                  //     decoration: BoxDecoration(
                  //         color: Color.fromARGB(255, 25, 178, 216)),
                  //   ),
                  //   height: 200,
                  // ),
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Align(
                          alignment: Alignment.topLeft,
                          child: Text(
                            'Đăng nhập',
                            style: Theme.of(context)
                                .textTheme
                                .bodyLarge
                                ?.copyWith(
                                    fontWeight: FontWeight.bold, fontSize: 20),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 15),
                    child: TextFormField(
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Vui lòng nhập vào Email';
                        }

                        if (!validEmail(value.toString())) {
                          return 'Email không hợp lệ';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                          contentPadding: EdgeInsets.all(15),
                          border: OutlineInputBorder(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(2.0))),
                          labelText: 'Email',
                          hintText: 'Email'),
                      controller: _email,
                    ),
                  ),
                  SizedBox(
                    height: 6,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 15),
                    child: TextFormField(
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Vui lòng nhập vào mật khẩu';
                        }
                        return null;
                      },
                      obscureText: true,
                      decoration: InputDecoration(
                          contentPadding: EdgeInsets.all(15),
                          border: OutlineInputBorder(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(2.0))),
                          labelText: 'Password',
                          hintText: 'Password'),
                      controller: _password,
                    ),
                  ),
                  GestureDetector(
                    onTap: () async {
                      if (_formKey.currentState!.validate()) {
                        _login(_email.text.trim(), _password.text.trim());
                      }
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Container(
                        height: 44,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(3),
                          color: Color.fromARGB(255, 26, 115, 232),
                        ),
                        child: Center(
                          child: Text(
                            'Đăng nhập',
                            style: Theme.of(context).textTheme.button!,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.1,
                  ),
                ],
              ),
            ));
          }),
    );
  }

  static Route<Object?> _dialogBuilder(
      BuildContext context, Object? arguments) {
    return DialogRoute<void>(
      context: context,
      builder: (BuildContext context) => const AlertDialog(
          title: Text('Tài khoản hoặc mật khẩu không chính xác!')),
    );
  }
}
