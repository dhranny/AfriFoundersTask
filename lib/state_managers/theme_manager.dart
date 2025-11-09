import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';

class ThemeProvider extends ChangeNotifier {
  static const String _themeBoxName = 'themeBox';
  static const String _themeModeKey = 'themeMode';

  ThemeMode _themeMode = ThemeMode.light;

  ThemeMode get themeMode => _themeMode;

  bool get isDarkMode => _themeMode == ThemeMode.dark;

  // Initialize and load saved theme preference
  Future<void> initialize() async {
    final box = await Hive.openBox(_themeBoxName);
    final savedTheme = box.get(_themeModeKey, defaultValue: 'light');
    _themeMode = savedTheme == 'dark' ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }

  // Toggle between light and dark theme
  Future<void> toggleTheme() async {
    _themeMode = _themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;

    // Save preference
    final box = await Hive.openBox(_themeBoxName);
    await box.put(_themeModeKey, _themeMode == ThemeMode.dark ? 'dark' : 'light');

    notifyListeners();
  }

  static ThemeData get lightTheme {
    return ThemeData(
      colorScheme: ColorScheme.fromSeed(seedColor: Color(0xFFDBF9F4)),
      scaffoldBackgroundColor: Colors.white,
      textTheme: TextTheme(
          bodyLarge: GoogleFonts.unbounded(
              color: Colors.black,
              fontSize: 22
          ),
          bodyMedium: GoogleFonts.unbounded(
              color: Colors.black,
              fontSize: 14
          )
      ),
      appBarTheme: AppBarTheme(
        elevation: 0,
        centerTitle: true,
        titleTextStyle: GoogleFonts.unbounded(
            fontSize: 22,
            color: Colors.black
        ),
        backgroundColor: const Color(0xFFDBF9F4),
        foregroundColor: Colors.black,
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: Color(0xFFDBF9F4),
        foregroundColor: Colors.black,
      ),
      cardTheme: CardThemeData(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  // Dark theme configuration
  static ThemeData get darkTheme {
    return ThemeData(
      colorScheme: ColorScheme.fromSeed(seedColor: Color(0xFFDBF9F4)),
      scaffoldBackgroundColor: Colors.grey[900],
      textTheme: TextTheme(
        bodyLarge: GoogleFonts.unbounded(
          color: Colors.white,
          fontSize: 22
        ), bodyMedium: GoogleFonts.unbounded(
          color: Colors.white,
          fontSize: 14
        )
      ),
      appBarTheme: AppBarTheme(
        elevation: 0,
        centerTitle: true,
        titleTextStyle: GoogleFonts.unbounded(
          fontSize: 22,
          color: Colors.white
        ),
        backgroundColor: Colors.grey[850],
        foregroundColor: Colors.white,
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: Color(0xFFDBF9F4),
        foregroundColor: Colors.black,
      ),
      cardTheme: CardThemeData(
        elevation: 2,
        color: Colors.grey[850],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}