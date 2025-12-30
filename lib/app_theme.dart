import "package:flutter/material.dart";
import "package:google_fonts/google_fonts.dart";

class AppTheme {
  // Tema claro
  static final ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: Colors.green,
    scaffoldBackgroundColor: Colors.white,
    textTheme: GoogleFonts.poppinsTextTheme(
      ThemeData.light().textTheme.copyWith(
          headlineMedium: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF025810), // Color verde oscuro
          ),
          bodyMedium: TextStyle(
            fontSize: 19,
            fontWeight: FontWeight.normal,
            color: const Color(0xFF025810), // Color verde oscuro
          ),
          headlineLarge: TextStyle(
            fontSize: 35,
            fontWeight: FontWeight.w800,
            color: const Color(0xFF025810), // Color verde oscuro
          ),
          headlineSmall: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF025810), // Color verde oscuro
          ),
          bodyLarge: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.normal,
            color: const Color(0xFF025810), // Color verde oscuro
          ),
          bodySmall: TextStyle(
            fontSize: 19,
            fontWeight: FontWeight.normal,
            color: const Color(0xFF025810), // Color verde oscuro
          ),
          titleSmall: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w600,
            color:
                const Color.fromARGB(255, 255, 255, 255), // Color verde oscuro
          ),
          titleMedium: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF025810), // Color verde oscuroS
          )),
    ),
  );

  // Tema oscuro
  static final ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: Colors.green,
    scaffoldBackgroundColor: Colors.grey[900],
    textTheme: GoogleFonts.poppinsTextTheme(
      ThemeData.dark().textTheme.copyWith(
            headlineMedium: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.w600,
              color:
                  const Color.fromARGB(255, 151, 176, 155), // Color verde claro
            ),
            bodyMedium: TextStyle(
              fontSize: 19,
              fontWeight: FontWeight.normal,
              color:
                  const Color.fromARGB(255, 151, 176, 155), // Color verde claro
            ),
            headlineLarge: TextStyle(
              fontSize: 35,
              fontWeight: FontWeight.w800,
              color:
                  const Color.fromARGB(255, 151, 176, 155), // Color verde claro
            ),
          ),
    ),
  );
}
