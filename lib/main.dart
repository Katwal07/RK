import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'screens/home_screen.dart';

class AppColors {
  static Color primaryColor = const Color(0xFF196BA6);
  static Color secondaryColor = const Color(0xFFFAAC24);
  static Color lightBgColor = const Color(0XFFFFFFFF);
  static Color lightContainerColor = const Color(0XFFF4F4F4);
  static Color lightFontColor = const Color(0XFF272727);
  static Color lightLabelColor = const Color(0XFF272727);

  /// Dark Color Theme
  static Color darkBgColor = const Color(0XFF1D182A);
  static Color darkContainerColor = const Color(0XFF342F3F);
  static Color darkFontColor = const Color(0XFFFFFFFF);
  static Color darkLabelColor = const Color(0XFFFFFFFF).withOpacity(0.5);
}

void main() {
  runApp(const MyPortfolio());
}

class MyPortfolio extends StatefulWidget {
  const MyPortfolio({super.key});

  @override
  State<MyPortfolio> createState() => _MyPortfolioState();
}

class _MyPortfolioState extends State<MyPortfolio> {
  bool isDarkMode = false;

  void toggleTheme() {
    setState(() {
      isDarkMode = !isDarkMode;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Rohan Katwal - Portfolio',
      debugShowCheckedModeBanner: false,
      themeMode: isDarkMode ? ThemeMode.dark : ThemeMode.light,
      theme: ThemeData(
        colorScheme: ColorScheme(
          brightness: Brightness.light,
          primary: AppColors.primaryColor,
          secondary: AppColors.secondaryColor,
          onPrimary: Colors.white,
          onSecondary: Colors.white,
          error: Colors.red,
          onError: Colors.white,
          background: AppColors.lightBgColor,
          onBackground: AppColors.lightFontColor,
          surface: AppColors.lightContainerColor,
          onSurface: AppColors.lightFontColor,
        ),
        textTheme: GoogleFonts.poppinsTextTheme().apply(
          bodyColor: AppColors.lightFontColor,
          displayColor: AppColors.lightFontColor,
        ),
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme(
          brightness: Brightness.dark,
          primary: AppColors.primaryColor,
          secondary: AppColors.secondaryColor,
          onPrimary: Colors.white,
          onSecondary: Colors.white,
          error: Colors.red,
          onError: Colors.white,
          background: AppColors.darkBgColor,
          onBackground: AppColors.darkFontColor,
          surface: AppColors.darkContainerColor,
          onSurface: AppColors.darkFontColor,
        ),
        textTheme: GoogleFonts.poppinsTextTheme().apply(
          bodyColor: AppColors.darkFontColor,
          displayColor: AppColors.darkFontColor,
        ),
        useMaterial3: true,
      ),
      home: HomeScreen(onThemeToggle: toggleTheme, isDarkMode: isDarkMode),
    );
  }
}
