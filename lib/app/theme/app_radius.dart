import 'package:flutter/widgets.dart';

abstract final class AppRadius {
  static const double xs = 4;
  static const double sm = 6;
  static const double md = 8;
  static const double lg = 12;

  static const card = BorderRadius.all(Radius.circular(md));
  static const button = BorderRadius.all(Radius.circular(md));
  static const dialog = BorderRadius.all(Radius.circular(md));
  static const bottomSheet = BorderRadius.all(Radius.circular(lg));
}
