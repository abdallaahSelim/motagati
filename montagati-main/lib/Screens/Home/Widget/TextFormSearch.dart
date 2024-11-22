import 'package:flutter/material.dart';

class TextFormSearch extends StatelessWidget {
  const TextFormSearch({super.key,required this.controller});
final TextEditingController controller;
  @override
  Widget build(BuildContext context) {
    return   TextFormField(
      controller: controller,
      decoration: InputDecoration(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(16),borderSide: const BorderSide(color: Colors.white))
          ,focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16),borderSide: const BorderSide(color: Colors.white))
          ,enabledBorder:OutlineInputBorder(borderRadius: BorderRadius.circular(16),borderSide: const BorderSide(color: Colors.white)),
          fillColor: Colors.white,
          filled: true,
          hintText: 'البحث في المتجر',
          hintStyle: const TextStyle(color: Colors.grey,fontSize: 18,fontWeight: FontWeight.w500),
          suffixIcon: const Icon(Icons.search,size: 25,color: Colors.grey,)

      ),
    );
  }
}
