import 'package:flutter/material.dart';

import 'screens/characters_page.dart';

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isDark = false;

  void _toggleTheme() {
    setState(() {
      _isDark = !_isDark;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Harry Potter Characters',
      debugShowCheckedModeBanner: false,
      theme: _buildTheme(Brightness.light),
      darkTheme: _buildTheme(Brightness.dark),
      themeMode: _isDark ? ThemeMode.dark : ThemeMode.light,
      themeAnimationDuration: const Duration(milliseconds: 350),
      home: CharactersPage(isDark: _isDark, onThemeToggle: _toggleTheme),
    );
  }

  ThemeData _buildTheme(Brightness brightness) {
    final isDark = brightness == Brightness.dark;
    final colorScheme = ColorScheme.fromSeed(
      seedColor: const Color(0xFF315847),
      brightness: brightness,
      surface: isDark ? const Color(0xFF202B24) : const Color(0xFFFFFCF5),
    );
    return ThemeData(
      brightness: brightness,
      colorScheme: colorScheme.copyWith(
        onSurface: isDark ? const Color(0xFFE7EBDD) : const Color(0xFF263B30),
        surfaceContainer: isDark
            ? const Color(0xFF202B24)
            : const Color(0xFFFFFCF5),
        surfaceContainerHighest: isDark
            ? const Color(0xFF29362E)
            : const Color(0xFFF0EBDD),
        outlineVariant: isDark
            ? const Color(0xFF39483E)
            : const Color(0xFFE9E0D0),
      ),
      scaffoldBackgroundColor: isDark
          ? const Color(0xFF121A16)
          : const Color(0xFFF5F1E8),
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFF17382D),
        foregroundColor: Color(0xFFFFF8E9),
        elevation: 0,
        centerTitle: false,
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: isDark
            ? const Color(0xFF1B251F)
            : const Color(0xFFFFFCF5),
        indicatorColor: isDark
            ? const Color(0xFF34483A)
            : const Color(0xFFE7EEDC),
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          final selected = states.contains(WidgetState.selected);
          return TextStyle(
            color: isDark
                ? (selected ? const Color(0xFFE1D09C) : const Color(0xFFB4BDAF))
                : (selected
                      ? const Color(0xFF244B36)
                      : const Color(0xFF777365)),
            fontSize: 11,
            fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
          );
        }),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          final selected = states.contains(WidgetState.selected);
          return IconThemeData(
            color: isDark
                ? (selected ? const Color(0xFFE1D09C) : const Color(0xFFB4BDAF))
                : (selected
                      ? const Color(0xFF244B36)
                      : const Color(0xFF777365)),
          );
        }),
        elevation: 8,
        shadowColor: const Color(0x1A17382D),
      ),
      chipTheme: ChipThemeData(
        side: BorderSide(
          color: isDark ? const Color(0xFF39483E) : const Color(0xFFE8E1D4),
        ),
      ),
      textTheme: TextTheme(
        headlineSmall: TextStyle(
          color: isDark ? const Color(0xFFE7EBDD) : const Color(0xFF24382D),
          fontFamily: 'Georgia',
          fontWeight: FontWeight.w700,
        ),
        titleLarge: TextStyle(
          color: isDark ? const Color(0xFFE7EBDD) : const Color(0xFF24382D),
          fontWeight: FontWeight.w700,
        ),
        bodyMedium: TextStyle(
          color: isDark ? const Color(0xFFB4BDAF) : const Color(0xFF625C50),
          height: 1.4,
        ),
      ),
      useMaterial3: true,
    );
  }
}
