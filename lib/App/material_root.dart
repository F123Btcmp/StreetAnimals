import 'package:flutter/material.dart';

import 'base_PatiCoin.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const base_PatiCoin(),
      debugShowCheckedModeBanner: false,
    );
  }
}
