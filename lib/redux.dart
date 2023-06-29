import 'package:flutter/material.dart';

void main() {
  runApp(
    MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
      ),
      home: const HomePage(),
    ),
  );
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home page'),
      ),
    );
  }
}

/* 
State, action, reducer - That's really all there is to redux 

What is redux?
Redux is a state management architecture library that successfully distributes data across widgets in a repetitive manner. It manages the state of an application through a unidirectional flow of data.
*/