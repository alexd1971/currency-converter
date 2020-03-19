import 'package:angular/angular.dart';
import 'package:angular_router/angular_router.dart';
import 'package:currency_converter_bloc/bloc.dart';
import 'package:currency_converter_services/currency_service.dart';

import '../../../components.dart';
import '../../../routes.dart';
import '../../../services.dart';

/// Компонент приложения
///
/// Этот компонент создается первым и ему передается управление при запуске
/// приложения в main.dart
///
/// Oтветственность компонента:
/// - маршрутизация
/// - инициализация компонентов бизнес-логики
///
/// Для реализации инициализации компонентов бизнес-логики при запуске и
/// закрытии их при завершении приложения компонент реализует интерфейсы
/// [OnInit] и [OnDestroy].
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
    // Объявляем провайдеров бизнес-логики и сервиса доступа к данным валют
    // Провайдеры объявленные в компоненте становятся доступны для
    // инжектирования в любом компоненте, расположенном в иерархии компонентов
    // ниже данного
    providers: [
      ClassProvider(CurrencyManagerBloc),
      ClassProvider(CurrencyConverterBloc),
      // Вместо LocalCurrencyService можно поставить MemoryCurrencyService
      // и посмотреть на изменение в поведении
      ClassProvider(CurrencyService, useClass: LocalCurrencyService)
    ],
    // Экспортируем классы и/или глобальные переменные, которые должны быть
    // видимы в шаблоне
    exports: [
      RoutePaths,
      Routes
    ])
class Application implements OnInit, OnDestroy {
  /// Маршрутизатор
  ///
  /// Подключается в конструкторе [Application] посредством механизма Angular DI
  final Router _router;

  /// BLoC менеджера валют
  final CurrencyManagerBloc _currencyManagerBloc;

  /// BLoC конвертера валют
  final CurrencyConverterBloc _currencyConverterBloc;

  /// Активный маршрут в приложении
  ///
  /// При первом запуске приложения по умполчанию открывается конвертер валют
  RoutePath active = RoutePaths.currencyConverter;

  /// Создает компонент приложения
  ///
  /// При создании посредством внутренних механизмов Angular инжетируется
  /// экземпляр маршрутизатора.
  Application(
      this._router, this._currencyManagerBloc, this._currencyConverterBloc) {
    // Устанавливаем обработчик события изменения маршрута, который изменяет
    // состояние аткивного маршрута
    _router.onRouteActivated.listen((routerState) {
      active = routerState.routePath;
    });
  }

  @override
  void ngOnInit() {
    // Инициализируем компоненты бинес-логики
    _currencyManagerBloc.add(InitCurrencyManagerEvent());
    _currencyConverterBloc.add(InitCurrencyConverterEvent());
  }

  @override
  void ngOnDestroy() {
    // Закрываем компоненты бизнес-логики
    _currencyManagerBloc.close();
    _currencyConverterBloc.close();
  }
}
