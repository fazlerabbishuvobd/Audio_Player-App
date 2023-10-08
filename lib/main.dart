import 'package:audioplayer_app/screens/home_page.dart';
import 'package:audioplayer_app/screens/playlist.dart';
import 'package:audioplayer_app/screens/splash_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Music Player',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      //home: HomePage(),
      //home: PlayList(),
      home: SplashScreen(),
    );
  }
}
