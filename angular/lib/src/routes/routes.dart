import 'package:angular_router/angular_router.dart';

import '../components/currency_converter/currency_converter.template.dart' as c;
import '../components/currency_manager/currency_manager.template.dart' as cm;
import 'route_paths.dart';

/// Маршруты
///
/// Здесь содержатся определения маршрутов приложения
class Routes {
  /// Маршрут к конвертеру валют
  static final currencyConverter = RouteDefinition(
      routePath: RoutePaths.currencyConverter, // путь
      component: c.CurrencyConverterNgFactory); // компонент

  /// Маршрут к менеджеру валют
  static final currencyManager = RouteDefinition(
      routePath: RoutePaths.currencyManager, // путь
      component: cm.CurrencyManagerNgFactory); // компонент

  /// Список всех маршрутов
  static final all = <RouteDefinition>[currencyConverter, currencyManager];
}
