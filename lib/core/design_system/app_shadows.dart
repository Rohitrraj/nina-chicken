import 'package:flutter/material.dart';

class AppShadows {
  const AppShadows._();

  static const List<BoxShadow> none = <BoxShadow>[];

  static const List<BoxShadow> sm = <BoxShadow>[
    BoxShadow(color: Color(0x14000000), blurRadius: 8, offset: Offset(0, 2)),
  ];

  static const List<BoxShadow> md = <BoxShadow>[
    BoxShadow(color: Color(0x1A000000), blurRadius: 18, offset: Offset(0, 6)),
  ];

  static const List<BoxShadow> lg = <BoxShadow>[
    BoxShadow(color: Color(0x1F000000), blurRadius: 32, offset: Offset(0, 12)),
  ];

  static const List<BoxShadow> elevated = <BoxShadow>[
    BoxShadow(color: Color(0x24000000), blurRadius: 40, offset: Offset(0, 16)),
  ];
}
