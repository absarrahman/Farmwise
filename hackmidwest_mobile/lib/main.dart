import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hackmidwest_mobile/landing_view.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
        theme: ThemeData(
          textTheme: GoogleFonts.poppinsTextTheme(
            Theme.of(context).textTheme,
          ),
        ),
        home: const LandingView(),
        debugShowCheckedModeBanner: false,
      );
}
