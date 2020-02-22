import 'package:angular_router/angular_router.dart';

/// Пути маршрутов приложения
class RoutePaths {
  /// Путь к конвертеру валют
  ///
  /// Этот маршрут используется в качестве маршрута по умолчанию
  static final currencyConverter =
      RoutePath(path: 'converter', useAsDefault: true);

  /// Путь к управлению валютами
  static final currencyManager = RoutePath(path: 'manager');
}
