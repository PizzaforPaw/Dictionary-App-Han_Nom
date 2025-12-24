import 'package:flutter/material.dart';
import 'package:modernlogintute/Login/login_page.dart';
import 'package:modernlogintute/Login/register_page.dart';


class LoginOrRegisterPage extends StatefulWidget {
  const LoginOrRegisterPage({super.key});

  @override
  _LoginOrRegisterPageState createState() => _LoginOrRegisterPageState();
}

class _LoginOrRegisterPageState extends State<LoginOrRegisterPage> {
  bool showLogin = true;

  void togglePages() {
    setState(() {
      showLogin = !showLogin;
    });
  }

  @override
  Widget build(BuildContext context) {
    return showLogin ? LoginPage(onTapRegister: togglePages) : RegisterPage(onTapLogin: togglePages);
  }
}
