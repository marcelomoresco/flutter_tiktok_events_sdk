import 'package:auto_route/auto_route.dart';
import 'package:counter_auto_route_web/models/route_scoped_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/counter_model.dart';
import '../app_router.dart';

@RoutePage()
class CounterPage extends StatelessWidget implements AutoRouteWrapper {
  const CounterPage({super.key});

  @override
  Widget wrappedRoute(BuildContext context) {
    return RouteScopedProvider<CounterModel>(routeKey: '/', create: () => CounterModel(), child: this);
  }

  @override
  Widget build(BuildContext context) {
    final value = context.watch<CounterModel>().value;

    return Scaffold(
      appBar: AppBar(title: const Text('Page 1')),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Value: $value', style: const TextStyle(fontSize: 32)),
            const SizedBox(height: 16),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                FilledButton(onPressed: () => context.read<CounterModel>().increment(), child: const Text('Add')),
                const SizedBox(width: 12),
                OutlinedButton(
                  onPressed: () => context.router.push(const SecondRoute()),
                  child: const Text('Go Page 2 (push)'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
