 import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:my_purchases/Screens/Home/Widget/PaymentProcess.dart';
import 'package:my_purchases/Screens/Home/Widget/Shopping.dart';
import 'package:my_purchases/Screens/Home/Widget/favourite.dart';
import 'package:my_purchases/Screens/Home/Widget/homepage.dart';
import 'package:my_purchases/Screens/Home/Widget/person.dart';
import 'package:my_purchases/const.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int current_index=1;
  List<Widget> Pages=[const Profile(),const Homepage(),const Favourite(),const Shopping(),const PaymentProcess()];
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      bottomNavigationBar: CurvedNavigationBar(
          backgroundColor: Colors.transparent,
          color: Kprimary.withOpacity(0.4),
          index: current_index,
          animationDuration: const Duration(milliseconds: 300),
          onTap: (index) {
            setState(() {
              current_index=index;
            });
          },
          items:const [
        Icon(Icons.person,color: Colors.white,size: 26,),
        Icon(Icons.home,color: Colors.white,size: 26,),
        Icon(Icons.favorite,color: Colors.white,size: 26,),
        Icon(Icons.shopping_cart,color: Colors.white,size: 26,),
        Icon(Icons.payment,color: Colors.white,size: 26,)
      ]),
      body:Pages[current_index] ,
    );
  }
}
