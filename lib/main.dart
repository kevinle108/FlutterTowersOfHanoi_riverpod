import 'package:flutter/material.dart';
import 'widgets/tower_of_hanoi.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Animations Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: TowerOfHanoi(),
    );
  }
}
