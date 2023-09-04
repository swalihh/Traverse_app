import 'package:flutter/material.dart';

import 'package:travel_/screens/splashscreen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Trip app',
      theme: ThemeData(
        
     //  brightness: Brightness.dark,
        colorScheme:
            ColorScheme.fromSeed(seedColor: Color.fromARGB(255, 184, 79, 116)
            ),
        // useMaterial3: true,
      ),
      home: splash(),
      debugShowCheckedModeBanner: false,
    );
  }
}
