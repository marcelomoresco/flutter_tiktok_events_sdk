import 'package:flutter/foundation.dart';

/// Cache tipado por Type:
/// - Para cada T (ChangeNotifier), mantém um mapa: routeKey -> T
class RouteScopedCache {
  RouteScopedCache._();
  static final RouteScopedCache instance = RouteScopedCache._();

  final Map<Type, Map<String, ChangeNotifier>> _typedStores = {};

  Map<String, ChangeNotifier> _storeFor(Type t) => _typedStores.putIfAbsent(t, () => <String, ChangeNotifier>{});

  T getOrCreate<T extends ChangeNotifier>(String key, T Function() create) {
    final store = _storeFor(T);
    final existing = store[key];
    if (existing is T) return existing;
    final created = create();
    store[key] = created;
    return created;
  }

  /// Remove e dá dispose do T associado à chave.
  void remove<T extends ChangeNotifier>(String key) {
    final store = _storeFor(T);
    final obj = store.remove(key);
    obj?.dispose();
  }

  void clearType<T extends ChangeNotifier>() {
    final store = _storeFor(T);
    for (final v in store.values) {
      v.dispose();
    }
    store.clear();
  }

  void clearAll() {
    for (final store in _typedStores.values) {
      for (final v in store.values) {
        v.dispose();
      }
      store.clear();
    }
    _typedStores.clear();
  }
}
