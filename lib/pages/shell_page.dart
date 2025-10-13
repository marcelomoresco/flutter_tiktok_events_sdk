import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/counter_model.dart';

@RoutePage()
class ShellPage extends StatelessWidget implements AutoRouteWrapper {
  const ShellPage({super.key});

  @override
  Widget wrappedRoute(BuildContext context) {
    return ChangeNotifierProvider(create: (_) => CounterModel(), child: this);
  }

  @override
  Widget build(BuildContext context) {
    return const AutoRouter();
  }
}
