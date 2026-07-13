import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:instagram/home_screen.dart';

void main() {
  runApp(App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData().copyWith(
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.black,
            padding: EdgeInsets.all(10),
          ),
        ),
        textTheme: GoogleFonts.ubuntuCondensedTextTheme().copyWith(
          titleSmall: GoogleFonts.ubuntuCondensed(fontWeight: FontWeight.bold),
          titleMedium: GoogleFonts.ubuntuCondensed(fontWeight: FontWeight.bold),
          titleLarge: GoogleFonts.ubuntuCondensed(fontWeight: FontWeight.bold),
        ),
      ),
      debugShowCheckedModeBanner: false,
      home: HomeScreen(),
    );
  }
}
