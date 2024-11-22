import 'package:flutter/material.dart';
import 'package:my_purchases/Screens/Login/Widget/LoginView.dart';

class Login extends StatelessWidget {
  const Login({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: SafeArea(
        child:  LoginView()));
  }
}
