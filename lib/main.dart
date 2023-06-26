import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => ObjectProvider(),
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        ),
        home: const HomePage(),
      ),
    ),
  );
}

@immutable
class BaseObject {
  final String id;
  final String lastUpdated;
  BaseObject()
      : id = const Uuid().v4(),
        lastUpdated = DateTime.now().toIso8601String();

  @override
  bool operator ==(covariant BaseObject other) => id == other.id;

  @override
  int get hashCode => id.hashCode;
}

//expensive object that changes every 10 seconds
@immutable
class ExpensiveObject extends BaseObject {}

//cheap object that changes every second
@immutable
class CheapObject extends BaseObject {}

//provider
class ObjectProvider extends ChangeNotifier {
  late String id;
  late CheapObject _cheapObject;
  late ExpensiveObject _expensiveObject;
  late StreamSubscription _cheapObjectSubscription;
  late StreamSubscription _expensiveObjectSubscription;

  CheapObject get cheapObject => _cheapObject;
  ExpensiveObject get expensiveObject => _expensiveObject;

  //constructor
  ObjectProvider()
      : id = const Uuid().v4(),
        _cheapObject = CheapObject(),
        _expensiveObject = ExpensiveObject() {
    start();
  }

  @override
  void notifyListeners() {
    id = const Uuid().v4();
    super.notifyListeners();
  }

  //function that will start the stream
  void start() {
    _cheapObjectSubscription = Stream.periodic(
      const Duration(seconds: 1),
    ).listen((_) {
      _cheapObject = CheapObject();
      notifyListeners();
    });
    _expensiveObjectSubscription = Stream.periodic(
      const Duration(seconds: 10),
    ).listen((_) {
      _expensiveObject = ExpensiveObject();
      notifyListeners();
    });
  }

  //function that will stop the stream
  void stop() {
    _cheapObjectSubscription.cancel();
    _expensiveObjectSubscription.cancel();
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Home page'),
        ),
        body: Column(
          children: [
            const Row(
              children: [
                Expanded(child: CheapWidget()),
                Expanded(child: ExpensiveWidget()),
              ],
            ),
            const Row(
              children: [
                Expanded(child: ObjectProviderWidget()),
              ],
            ),
            Row(
              children: [
                TextButton(
                  onPressed: () {
                    context.read<ObjectProvider>().stop();
                  },
                  child: const Text("Stop"),
                ),
                TextButton(
                  onPressed: () {
                    context.read<ObjectProvider>().start();
                  },
                  child: const Text("Start"),
                ),
              ],
            )
          ],
        ));
  }
}

//VIEW
class CheapWidget extends StatelessWidget {
  const CheapWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final cheapObject = context.select<ObjectProvider, CheapObject>(
      (provider) => provider.cheapObject,
    );
    return Container(
      height: 100,
      color: Colors.yellow,
      child: Column(
        children: [
          const Text("Expensive Widget"),
          const Text("Last updated"),
          Text(cheapObject.lastUpdated),
        ],
      ),
    );
  }
}

class ExpensiveWidget extends StatelessWidget {
  const ExpensiveWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final expensiveObject = context.select<ObjectProvider, ExpensiveObject>(
      (provider) => provider.expensiveObject,
    );
    return Container(
      height: 100,
      color: Colors.green,
      child: Column(
        children: [
          const Text("Expensive Widget"),
          const Text("Last updated"),
          Text(expensiveObject.lastUpdated),
        ],
      ),
    );
  }
}

class ObjectProviderWidget extends StatelessWidget {
  const ObjectProviderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ObjectProvider>();

    return Container(
      height: 100,
      color: Colors.purple,
      child: Column(
        children: [
          const Text("Object Provider Widget"),
          const Text("ID"),
          Text(provider.id),
        ],
      ),
    );
  }
}

// 27-06-23: Details of provider course
