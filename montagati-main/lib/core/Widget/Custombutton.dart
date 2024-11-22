 import 'package:flutter/material.dart';
import 'package:my_purchases/const.dart';

import '../Styles.dart';

class Custombutton extends StatelessWidget {
  const Custombutton({super.key, required this.title, this.onpressed});
final String title;
final void Function()?onpressed;
  @override
  Widget build(BuildContext context) {
    return   Container(
      width: double.infinity,
      decoration: BoxDecoration(color:Kprimary ,borderRadius: BorderRadius.circular(12)),
      child: MaterialButton(onPressed:onpressed,child: Text(title,style: Styles.text20(context),),),);
  }
}
