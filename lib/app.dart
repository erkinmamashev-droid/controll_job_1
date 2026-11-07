import 'package:flutter/material.dart';

import 'screens/characters_page.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    const parchment = Color(0xFFF4EFE4);
    return MaterialApp(
      title: 'Harry Potter Characters',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF315847),
          surface: parchment,
        ),
        scaffoldBackgroundColor: parchment,
        useMaterial3: true,
      ),
      home: const CharactersPage(),
    );
  }
}
