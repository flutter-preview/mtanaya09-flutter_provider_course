import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

Stream<String> getTime() => Stream.periodic(
      const Duration(seconds: 1),
      (_) => DateTime.now().toIso8601String(),
    );

class HooksPage extends HookWidget {
  const HooksPage({super.key});
  @override
  Widget build(BuildContext context) {
    final dateTime = useStream(getTime());

    return Scaffold(
      appBar: AppBar(
        title: Text(dateTime.data ?? 'Home Page'),
      ),
    );
  }
}

/*
HOOKS IN FLUTTER
at most 1 SUPER-CLASS - code reuse

Increase the ability to share code

HOOKS ARE A WAY TO REUSE LOGIC
Logic that otherwise would have been placed inside a class

WHY HOOKS?
We know that components and top-down data flow help us organize a large UI into small, independent, reusable pieces. However, we often can’t break complex components down any further because the logic is stateful and can’t be extracted to a function or another component. Sometimes that’s what people mean when they say React doesn’t let them “separate concerns.”
*/
