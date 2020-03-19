import 'package:angular/angular.dart';
// Модуль application.template.dart генерируется при сборке приложения автоматически
// на основе компонента Application. В нем находится фабрика компонента Application,
// который используется при запуске приложения. Имя фабрики формируется так:
// <имя компонента>+NgFactory
import 'package:currency_converter_web/src/components/application/application.template.dart'
    as ng;
import 'package:angular_router/angular_router.dart';
// Модуль main.template.dart генерируется автоматически по аннотации @GenerateInjector
// В нем находится инжектор первого уровня иерархии с сервисом, предоставляющим
// функционал маршрутизации для приложения. В последствии наличие такого инжектора
// позволяет легко (автоматически) получать доступ к маршрутизатору в компонентах.
import 'main.template.dart' as self;

/// Сгенерированный инжектор
@GenerateInjector(
  /// Вместо routerProviderHash можно указать routerProvider. Тогда маршрутизация
  /// будет осуществляться без хэша (#).
  ///
  /// Для отладки удобнее использовать routerProviderHash, так как не предъявляет
  /// дополнительных требований к серверу
  ///
  /// Для продакшена обычно используют routerProvider. Но это требует, чтобы сервер
  /// перенаправлял все запросы на index.html для корректной работы маршрутизатора
  routerProvidersHash,
)
// ignore: undefined_prefixed_name
// До сборки приложения переменной `self.injector$Injector` не существует.
// Чтобы анализатор не показывал ошбику в этом месте, устанавливаем локальный
// ignore этой ошибки
final InjectorFactory injector = self.injector$Injector;

/// Запускает приложение
void main() {
  // Здесь запускается корневой компонент приложения. В нашем случае это
  // компонент Application. Где будет выводится этот компонент на странице
  // определяется расположением элемента <app></app> в файле web/index.html
  // Сам тэг app связывается с компонентом Application в аннотации к компоненту
  // (см. параметр selector)
  runApp(ng.ApplicationNgFactory, createInjector: injector);
}
