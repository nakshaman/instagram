import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram/cubit/counter_cubit.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final counterCubit = CounterCubit();
    return Scaffold(
      appBar: AppBar(
        title: Text('Cubit Tutorial'),
        foregroundColor: Colors.white,
        backgroundColor: Colors.blueAccent,
      ),
      body: Center(
        child: Column(
          spacing: 20,
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            BlocBuilder(
              bloc: counterCubit,
              builder: (context, counter) {
                return Text('Counter value is : $counter');
              },
            ),
            ElevatedButton.icon(
              label: Text('Increment'),
              icon: Icon(Icons.add),
              onPressed: () {
                counterCubit.increment();
              },
            ),
            ElevatedButton.icon(
              label: Text('Decrement'),
              icon: Icon(Icons.add),
              onPressed: () {
                counterCubit.decrement();
              },
            ),
          ],
        ),
      ),
    );
  }
}
