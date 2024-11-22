import 'package:flutter/material.dart';
import 'package:my_purchases/Screens/Admin/admin.dart';
import 'package:my_purchases/Screens/Home/Home.dart';
import 'package:my_purchases/Screens/Login/Login.dart';
import 'package:my_purchases/Screens/Login/forget.dart';
import 'package:my_purchases/Screens/Regsister/Register.dart';



Map<String, WidgetBuilder> routes() {
  return {
    '/':(context)=> const Login(),
    'Register': (context) => const Register(),
    'Home': (context) => const Home(),
    'Forget': (context) => const Forget(),
    'Admin':(context)=>const Admin()
  };
}