import 'package:flutter/material.dart';
import 'package:flutter_demo/controller/MenuController.dart';
import 'package:flutter_demo/screens/page/dashboard.dart';
import 'package:flutter_demo/helpers/loading.dart';
import 'package:flutter_demo/helpers/utils.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();

  initState() {
    super.initState();
    // checkLogin();
  }

  Future checkLogin() async {
    print(Utils.getToken() + 'token');
    if (Utils.getToken() != '') {
      setState(() {
        processing = true;
      });

      await Utils.me(Utils.getToken());
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (_) => MultiProvider(
                    providers: [
                      ChangeNotifierProvider(
                        create: (context) => MenuController(),
                      ),
                    ],
                    child: DashboardScreen(),
                  )));

      setState(() {
        processing = false;
      });
    }
  }

  bool processing = false;
  Future<void> _login(_email, _password) async {
    setState(() {
      processing = true;
    });

    if (await Utils.login(_email, _password)) {
      await Utils.me(Utils.getToken());
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (_) => MultiProvider(
                    providers: [
                      ChangeNotifierProvider(
                        create: (context) => MenuController(),
                      ),
                    ],
                    child: DashboardScreen(),
                  )));
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
      return loadingLoginProcess(context, "??ang ????ng nh???p");
    }

    return Scaffold(
      backgroundColor: Colors.white,
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
                        width: 200,
                        height: MediaQuery.of(context).size.height * 0.1,
                        child: Image.asset("assets/images/logo.png"),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: MediaQuery.of(context).size.width * 0.05),
                    child: TextFormField(
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Vui l??ng nh???p v??o Email';
                        }

                        if (!validEmail(value.toString())) {
                          return 'Email kh??ng h???p l???';
                        }
                        return null;
                      },
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
                    child: TextFormField(
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Vui l??ng nh???p v??o m???t kh???u';
                        }
                        return null;
                      },
                      obscureText: true,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Password',
                          hintText: 'Enter secure password'),
                      controller: _password,
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
                          if (_formKey.currentState.validate()) {
                            _login(_email.text.trim(), _password.text.trim());
                          }
                        },
                        child: const Text('Sign in',
                            style:
                                TextStyle(color: Colors.white, fontSize: 20)),
                      )),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.1,
                  ),
                ],
              ),
            ));
          }),
    );
  }

  static Route<Object> _dialogBuilder(BuildContext context, Object arguments) {
    return DialogRoute<void>(
      context: context,
      builder: (BuildContext context) => const AlertDialog(
          title: Text('T??i kho???n ho???c m???t kh???u kh??ng ch??nh x??c!')),
    );
  }
}
