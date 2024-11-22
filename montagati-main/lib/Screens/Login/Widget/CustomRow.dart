import 'package:flutter/material.dart';
import 'package:my_purchases/core/Styles.dart';

class CustomRow extends StatelessWidget {
  const CustomRow({super.key, required this.title, required this.navigate, this.onpressed});
  final String title;
  final void Function()?onpressed;
  final String navigate;
  @override
  Widget build(BuildContext context) {
    return   Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(title,style: Styles.text20grey(context).copyWith(fontSize: 18),),
        MaterialButton(onPressed:onpressed ,padding: EdgeInsets.zero,minWidth: 0,child: Text(navigate,style: Styles.text20(context).copyWith(fontSize: 19,color: Colors.white,),),),
      ],);
  }
}
