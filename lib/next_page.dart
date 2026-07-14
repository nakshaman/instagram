import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram/bloc/counter_bloc.dart';
// import 'package:instagram/cubit/counter_cubit.dart';

class NextPage extends StatelessWidget {
  const NextPage({super.key});

  @override
  Widget build(BuildContext context) {
    // final counterCubit = BlocProvider.of<CounterCubit>(context);
    final counterBloc = BlocProvider.of<CounterBloc>(context);
    return Scaffold(
      appBar: AppBar(),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          ElevatedButton.icon(
            label: Text('Increment'),
            icon: Icon(Icons.add),
            onPressed: () {
              counterBloc.add(CounterIncremented());
              // counterCubit.increment();
            },
          ),
          ElevatedButton.icon(
            label: Text('Decrement'),
            icon: Icon(Icons.add),
            onPressed: () {
              counterBloc.add(CounterDecremented());
            },
          ),
        ],
      ),
    );
  }
}
