import 'package:flutter/material.dart';

class AppRadius {
  const AppRadius._();

  static const double xsValue = 6;
  static const double smValue = 10;
  static const double mdValue = 16;
  static const double lgValue = 24;
  static const double xlValue = 32;
  static const double pillValue = 999;

  static const BorderRadius xs = BorderRadius.all(Radius.circular(xsValue));

  static const BorderRadius sm = BorderRadius.all(Radius.circular(smValue));

  static const BorderRadius md = BorderRadius.all(Radius.circular(mdValue));

  static const BorderRadius lg = BorderRadius.all(Radius.circular(lgValue));

  static const BorderRadius xl = BorderRadius.all(Radius.circular(xlValue));

  static const BorderRadius pill = BorderRadius.all(Radius.circular(pillValue));
}
