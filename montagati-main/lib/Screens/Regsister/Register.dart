import 'package:flutter/material.dart';
import 'package:my_purchases/Screens/Regsister/Widget/RegisterView.dart';

class Register extends StatelessWidget {
  const Register({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: SafeArea(child: RegisterView()));
  }
}
