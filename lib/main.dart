import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:instagram/bloc/counter_bloc.dart';
import 'package:instagram/cubit/counter_cubit.dart';
import 'package:instagram/home_screen.dart';

void main() {
  runApp(App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => CounterCubit()),
        BlocProvider(create: (_) => CounterBloc()),
      ],
      child: MaterialApp(
        theme: ThemeData().copyWith(
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.black,
              padding: EdgeInsets.all(10),
            ),
          ),
          textTheme: GoogleFonts.ubuntuCondensedTextTheme().copyWith(
            titleSmall: GoogleFonts.ubuntuCondensed(
              fontWeight: FontWeight.bold,
            ),
            titleMedium: GoogleFonts.ubuntuCondensed(
              fontWeight: FontWeight.bold,
            ),
            titleLarge: GoogleFonts.ubuntuCondensed(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        debugShowCheckedModeBanner: false,
        home: HomeScreen(),
      ),
    );
  }
}
