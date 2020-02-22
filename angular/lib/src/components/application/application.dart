import 'package:angular/angular.dart';
import 'package:angular_router/angular_router.dart';

import '../../../components.dart';
import '../../../routes.dart';

/// Компонент приложения
///
/// Этот компонент создается первым и ему передается управление при запуске
/// приложения в main.dart
///
/// Основная ответственность компонента - маршрутизация.
///
/// Для вставки компонента в шаблон/html-документ используется элемент
/// `<app></app>`. См. index.html
@Component(
    selector: 'app', // имя тэга html-элемента
    templateUrl: 'application.html', // шаблон компонента
    styleUrls: [
      'application.css' // стили компонента
    ],
    // Список директив, используемых в шаблоне
    directives: [
      TabPanel,
      Tab,
      routerDirectives, // директивы маршрутизатора
    ],
    // Экспортируем классы и/или глобальные переменные, которые должны быть
    // видимы в шаблоне
    exports: [
      RoutePaths,
      Routes
    ])
class Application {
  /// Маршрутизатор
  ///
  /// Подключается в конструкторе [Application] посредством механизма Angular DI
  final Router _router;

  /// Активный маршрут в приложении
  ///
  /// При первом запуске приложения по умполчанию открывается конвертер валют
  RoutePath active = RoutePaths.currencyConverter;

  /// Создает компонент приложения
  ///
  /// При создании посредством внутренних механизмов Angular инжетируется
  /// экземпляр маршрутизатора.
  Application(this._router) {
    // Устанавливаем обработчик события изменения маршрута, который изменяет
    // состояние аткивного маршрута
    _router.onRouteActivated.listen((routerState) {
      active = routerState.routePath;
    });
  }
}
