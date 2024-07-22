import 'package:flutter/material.dart';

const Color m = Color(0XFF97144d);
const Color sec = Color(0XFF7e0516);

class Gap {
  static Widget h(double height) => SizedBox(height: height);

  static Widget w(double width) => SizedBox(width: width);
}

void push(BuildContext context, Widget page, {Object? arguments})  {
  Navigator.push(
    context,
    MaterialPageRoute(
        builder: (context) => page,
        settings: RouteSettings(arguments: arguments)),
  );
}

void replace(BuildContext context, Widget page, {Object? arguments}) {
  Navigator.pushReplacement(
    context,
    MaterialPageRoute(
        builder: (context) => page,
        settings: RouteSettings(arguments: arguments)),
  );
}

void remove(BuildContext context, Widget page, {Object? arguments}) {

  Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
          builder: (context) => page,
          settings: RouteSettings(arguments: arguments)),
      (route) => false);
}
