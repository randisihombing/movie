import 'package:flutter/material.dart';
import 'package:video_project/provider/movie_provider.dart';
import 'package:provider/provider.dart';
import 'package:video_project/splash_screen.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        //if you have new provider, add the new provider down below.
        ChangeNotifierProvider(create: (_) => MovieProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const SplashScreen(),
    );
  }
}
