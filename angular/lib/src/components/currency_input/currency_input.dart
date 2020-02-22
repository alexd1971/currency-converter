import 'dart:async';
import 'dart:html';

import 'package:angular/angular.dart';
import 'package:currency_converter_models/models.dart';

import '../../../components.dart' show CurrencySelector;

/// Компонент ввода параметров валюты для конвертации
///
/// Поддержиаемые атрибуты:
///
/// * [conversion]::[CurrencyConversion]
///
/// Поддерживаемые события:
///
/// * [onChange] - генерируется при изменении параметров поля (изменение
/// валюты или изменение значения в поле ввода)
///
/// Добавление в шаблон:
/// ```
/// <currency-input
///   [converstion]="initialConversion",
///   (onChange)="changeHandler()"
/// ></currency-input>
/// ```
@Component(
    selector: 'currency-input',
    templateUrl: 'currency_input.html',
    styleUrls: ['currency_input.css'],
    directives: [coreDirectives, CurrencySelector])
class CurrencyInput implements OnInit, OnDestroy {
  /// Конверсия, привязанная к полю
  ///
  /// Если для имени атрибута хочется использовать значение, отличное от имени
  /// переменной, то его можно указать в качестве параметра аннотации `@Input`.
  /// В нашем случае значение атрибута `conversion` будет связано с переменной
  /// класса [currencyConversion].
  @Input('conversion')
  var currencyConversion = CurrencyConversion();

  /// Элемент `input` из шаблона компонента
  ///
  /// Необходим для обработки событий поля ввода и получения его значения
  @ViewChild('input')
  InputElement input;

  /// Признак открытия селектора валют
  bool selectorIsOpen = false;

  /// Классы добавляемые при изменении отображения селектора валют
  ///
  /// При открытом селекторе показывается стрелочка вверх, при закрытом -
  /// стрелка вниз.
  ///
  /// Используется в шаблоне в атрибуте [NgClass]
  Map<String, bool> get selectorButtonCssClass => {
        'fa-angle-up': selectorIsOpen,
        'fa-angle-down': !selectorIsOpen,
      };

  /// Обработчик выбора валюты в селекторе валют
  void changeCurrency(currency) {
    currencyConversion.currency = currency;
    // после изменения генерируем onChange
    _changeController.add(currencyConversion);
  }

  /// Признак игнорирования клика по документу
  ///
  /// Клик по документу обрабатывается для закрытия селектора валют. Чтобы
  /// при открытии селектора он сразу же не закрывался, для компонента
  /// [CurrencyInput], у которого открывается селектор нужно игнорировать
  /// клик по документу. Поскольку для остальных компонентов [CurrencyInput]
  /// клик по документу игнорироваться не будет, то у них селектор закроется.
  bool _ignoreDocumentClick = false;

  /// Обработчик клика по кнопке открытия селектора валют
  void toggleSelector(MouseEvent event) {
    // Включаем игнорирование клика по документу для этого компонента.
    _ignoreDocumentClick = true;
    selectorIsOpen = !selectorIsOpen;
  }

  /// Контроллер потока событий изменения компонента
  final _changeController = StreamController<CurrencyConversion>.broadcast();

  /// Поток событий изменения компонента
  @Output()
  Stream<CurrencyConversion> get onChange => _changeController.stream;

  /// Подписка на события клика по документу
  StreamSubscription _documentClickSubscribtion;

  /// Подписка на события ввода в поле ввода
  StreamSubscription _inputInputSubscription;

  /// Инициализирует компонент
  @override
  void ngOnInit() {
    // Подписываемся на события клика по документу
    _documentClickSubscribtion = document.onClick.listen((_) {
      // Если установлен признак игнорирования, только сбрасываем этот признак
      if (_ignoreDocumentClick) {
        _ignoreDocumentClick = false;
        return;
      }
      // Закрываем селектор валют, если он открыт
      if (selectorIsOpen) {
        selectorIsOpen = false;
      }
    });
    // Подписываемся на изменения значения поля ввода
    _inputInputSubscription = input.onInput.listen((_) {
      // При изменении значения сохраняем его в текущей конверсии
      currencyConversion.value = num.tryParse(input.value);
      // Генерируем событие `onChange`
      _changeController.add(currencyConversion);
    });
  }

  /// Выполняет необходимые операции при удалении компонента
  ///
  /// При удалении отменяются все подписки.
  @override
  void ngOnDestroy() {
    _documentClickSubscribtion.cancel();
    _inputInputSubscription.cancel();
    _changeController.close();
  }
}
