import 'package:flutter/material.dart';

class Category{
final  String name;
final  String price;
final  Image image;
final  String desription;
final bool favourite;

  Category({required this.favourite,required this.name, required this.price, required this.image, required this.desription});
}