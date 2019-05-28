import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:xchange/pages/main.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays([]);

    return MaterialApp(
      title: 'Exchange',
      home: MainPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

