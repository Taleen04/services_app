import 'package:flutter/material.dart';

class AppShadows {
  static const List<BoxShadow> light = [
    BoxShadow(
      color: Colors.black12,
      offset: Offset(0, 2),
      blurRadius: 4,
    ),
  ];
  
  static const List<BoxShadow> medium = [
    BoxShadow(
      color: Colors.black26,
      offset: Offset(0, 4),
      blurRadius: 8,
    ),
  ];
  
  static const List<BoxShadow> heavy = [
    BoxShadow(
      color: Colors.black38,
      offset: Offset(0, 8),
      blurRadius: 16,
    ),
  ];
}