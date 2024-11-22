import 'package:flutter/material.dart';

abstract class Styles{
  static TextStyle text20(context) =>const TextStyle(
    color: Colors.white,
    fontSize: 20,
    fontWeight: FontWeight.w500
  );
  static TextStyle text20bold(context) =>const TextStyle(
      color: Colors.white,
      fontSize: 20,
      fontWeight: FontWeight.w700,

  );
  static TextStyle text20grey(context) =>const TextStyle(
      color: Colors.grey,
      fontSize: 20,
      fontWeight: FontWeight.w500
  );
  static TextStyle text22(context) =>const TextStyle(
      color: Colors.white,
      fontSize: 22,
      fontWeight: FontWeight.w500,
    overflow: TextOverflow.ellipsis
  );
  static TextStyle text22bold(context) =>const TextStyle(
    color: Colors.white,
    fontSize: 20,
    fontWeight: FontWeight.w700,

  );
}