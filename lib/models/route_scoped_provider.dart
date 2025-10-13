import 'package:counter_auto_route_web/route_scoped_cache.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

class RouteScopedProvider<T extends ChangeNotifier> extends StatelessWidget {
  const RouteScopedProvider({super.key, required this.routeKey, required this.create, required this.child});

  final String routeKey;
  final T Function() create;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final instance = RouteScopedCache.instance.getOrCreate<T>(routeKey, create);

    return ChangeNotifierProvider<T>.value(value: instance, child: child);
  }
}
