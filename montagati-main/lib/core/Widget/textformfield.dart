
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class textFormField extends StatelessWidget {
  const textFormField({super.key,required this.title,required this.enable,this.inputformat,this.max,this.counter,this.iconata, this.keyboard, required this.obsure, this.controller, this.onchanged});
final String title;
final Widget? iconata;
final TextInputType?keyboard;
final bool obsure;
final TextEditingController? controller;
final void Function(String)? onchanged;
final List<TextInputFormatter>? inputformat;
final String? counter;
final int?max;
final bool enable;
  @override
  Widget build(BuildContext context) {
    return  TextFormField(
      keyboardType:keyboard ,
      maxLines: max,
      validator: (value) {
        if(value!.isEmpty){
          return 'برجاء كتابة البيانات';
        }
        return null;
      },
      obscureText: obsure,
      onChanged: onchanged,
      inputFormatters:inputformat ,
      controller: controller,
      decoration: InputDecoration(
        filled: true,
fillColor: Colors.white,
enabled: enable,
        counterText: counter,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          focusedBorder:OutlineInputBorder(borderRadius: BorderRadius.circular(12),borderSide: const BorderSide(color: Colors.grey)), 
          hintText: title,
          hintStyle: TextStyle(color: Colors.grey[400],fontSize: 16),
        suffixIcon: iconata,

      ),
    );
  }
}
