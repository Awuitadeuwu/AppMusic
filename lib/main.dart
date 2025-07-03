  import 'package:flutter/material.dart';
  import 'package:shared_preferences/shared_preferences.dart';
  import 'home.dart';

  void main() {
    runApp(const MyApp());
  }

  class MyApp extends StatefulWidget {
    const MyApp({super.key});

    @override
    State<MyApp> createState() => _MyAppState();
  }

  class _MyAppState extends State<MyApp> {
    ThemeData _currentTheme = _buildDefaultTheme();

    @override
    void initState() {
      super.initState();
      _loadTheme();
    }

    Future<void> _loadTheme() async {
      final prefs = await SharedPreferences.getInstance();
      final colorValue = prefs.getInt('primary_color') ?? 0xFF4FC3F7;

      setState(() {
        _currentTheme = _buildTheme(Color(colorValue));
      });
    }

    void _changeTheme(Color newColor) async {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt('primary_color', newColor.value);

      setState(() {
        _currentTheme = _buildTheme(newColor);
      });
    }

    static ThemeData _buildDefaultTheme() {
      return _buildTheme(const Color(0xFF4FC3F7));
    }

    static ThemeData _buildTheme(Color primaryColor) {
      return ThemeData.dark().copyWith(
        colorScheme: ColorScheme.fromSeed(
          seedColor: primaryColor,
          brightness: Brightness.dark,
        ),
        scaffoldBackgroundColor: const Color(0xFF121212), // Fondo negro permanente
        appBarTheme: AppBarTheme(
          backgroundColor: primaryColor,
          elevation: 0,
        ),
        navigationBarTheme: NavigationBarThemeData(
          backgroundColor: primaryColor.withOpacity(0.8),
          indicatorColor: primaryColor.withOpacity(0.5),
          labelTextStyle: MaterialStateProperty.all(
            const TextStyle(color: Colors.white),
          ),
        ),
        navigationDrawerTheme: NavigationDrawerThemeData(
          backgroundColor: primaryColor.withOpacity(0.8),
          indicatorColor: primaryColor.withOpacity(0.5),
        ),
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
        ),
        textTheme: ThemeData.dark().textTheme.apply(
          bodyColor: Colors.white,
          displayColor: Colors.white,
        ),
      );
    }

    @override
    Widget build(BuildContext context) {
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Musica',
        theme: _currentTheme,
        home: HomeScreen(changeTheme: _changeTheme),
      );
    }
  }