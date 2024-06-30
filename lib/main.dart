import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/fixed_cost_provider.dart';
import 'screens/fixed_cost_list_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => FixedCostProvider(),
      child: MaterialApp(
        title: '固定費計算アプリ',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: FixedCostListScreen(),
      ),
    );
  }
}