import 'package:flutter/material.dart';

class AppShadows {
  static const List<BoxShadow> normal = [
    BoxShadow(
      color: Color.fromRGBO(0, 0, 0, 0.19),
      blurRadius: 20,
      spreadRadius: 0,
      offset: Offset(0, 10),
    ),
    BoxShadow(
      color: Color.fromRGBO(0, 0, 0, 0.23),
      blurRadius: 6,
      spreadRadius: 0,
      offset: Offset(0, 6),
    ),
  ];

  static const List<BoxShadow> deep = [
    BoxShadow(
      color: Color.fromRGBO(50, 50, 93, 0.25),
      blurRadius: 100,
      spreadRadius: -20,
      offset: Offset(0, 50),
    ),
    BoxShadow(
      color: Color.fromRGBO(0, 0, 0, 0.3),
      blurRadius: 60,
      spreadRadius: -30,
      offset: Offset(0, 30),
    ),
  ];

  static const List<BoxShadow> large = [
    BoxShadow(
      color: Color.fromRGBO(0, 0, 0, 0.3),
      blurRadius: 38,
      spreadRadius: 0,
      offset: Offset(0, 19),
    ),
    BoxShadow(
      color: Color.fromRGBO(0, 0, 0, 0.22),
      blurRadius: 12,
      spreadRadius: 0,
      offset: Offset(0, 15),
    ),
  ];

  static const List<BoxShadow> medium = [
    BoxShadow(
      color: Color.fromRGBO(0, 0, 0, 0.25),
      blurRadius: 28,
      spreadRadius: 0,
      offset: Offset(0, 14),
    ),
    BoxShadow(
      color: Color.fromRGBO(0, 0, 0, 0.22),
      blurRadius: 10,
      spreadRadius: 0,
      offset: Offset(0, 10),
    ),
  ];

  static const List<BoxShadow> light = [
    BoxShadow(
      color: Color.fromRGBO(0, 0, 0, 0.1),
      blurRadius: 15,
      spreadRadius: -3,
      offset: Offset(0, 10),
    ),
    BoxShadow(
      color: Color.fromRGBO(0, 0, 0, 0.05),
      blurRadius: 6,
      spreadRadius: -2,
      offset: Offset(0, 4),
    ),
  ];
}
