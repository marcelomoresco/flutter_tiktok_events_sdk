import 'package:auto_route/auto_route.dart';
import 'package:counter_auto_route_web/pages/shell_page.dart';
import 'pages/counter_page.dart';
import 'pages/second_page.dart';

part 'app_router.gr.dart';

@AutoRouterConfig(replaceInRouteName: 'Page,Route')
class AppRouter extends RootStackRouter {
  @override
  RouteType get defaultRouteType => const RouteType.material();

  @override
  List<AutoRoute> get routes => [
    AutoRoute(page: CounterRoute.page, path: '/', initial: true),
    AutoRoute(page: SecondRoute.page, path: '/second'),
  ];
}
