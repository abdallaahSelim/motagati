
import 'package:flutter/material.dart';
class CategoryModel{
 final String title;
 final AssetImage image;
 final void Function()?onpressed;

 CategoryModel({required this.onpressed,required this.title,required this.image});
}