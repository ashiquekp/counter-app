import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../viewmodels/auth_viewmodel.dart';
import '../viewmodels/counter_viewmodel.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authViewModelProvider);
    final count = ref.watch(counterViewModelProvider);
    return Scaffold(
      backgroundColor: Color(0xFF111521),
      appBar: AppBar(
        backgroundColor: Color(0xFF111521),
        title: const Text('Home', style: TextStyle(color: Colors.white)),
        actions: [
          Transform.translate(
            offset: const Offset(-10, 0),
            child: ElevatedButton(
              style: ButtonStyle(
                backgroundColor: WidgetStatePropertyAll(Colors.red),
              ),
              onPressed:
                  () => ref.read(authViewModelProvider.notifier).logout(),
              child: Row(
                children: [
                  const Icon(Icons.logout, color: Colors.white),
                  const SizedBox(width: 4),
                  const Text('Logout', style: TextStyle(color: Colors.white)),
                ],
              ),
            ),
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Welcome, ${user?.name ?? 'User'}',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 100),
            Text(
              'Counter: $count',
              style: TextStyle(
                color: Colors.white,
                fontSize: 52,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 74),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                CounterButton(
                  onPressed:
                      () =>
                          ref
                              .read(counterViewModelProvider.notifier)
                              .increment(),
                  icon: CupertinoIcons.add,
                ),
                CounterButton(
                  onPressed:
                      () =>
                          ref
                              .read(counterViewModelProvider.notifier)
                              .decrement(),
                  icon: CupertinoIcons.minus,
                ),
                CounterButton(
                  onPressed:
                      () => ref.read(counterViewModelProvider.notifier).reset(),
                  icon: CupertinoIcons.restart,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class CounterButton extends StatelessWidget {
  final dynamic onPressed;
  final IconData icon;
  const CounterButton({super.key, this.onPressed, required this.icon});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(onPressed: onPressed, child: Icon(icon));
  }
}
