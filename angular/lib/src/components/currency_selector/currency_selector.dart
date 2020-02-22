import 'dart:async';

import 'package:angular/angular.dart';
import 'package:currency_converter_models/models.dart';

/// Компонент выбора валюты для конверсии
///
/// Поддерживаемые атрибуты:
///
/// * [selected]::[Currency] - текущая выбранная валюта (подсвечивается)
///
/// Поддерживаемые события:
///
/// * [onSelect] - генерируется при клике на выбираемой валюте в списке
///
/// Пример включенияв шаблон:
/// ```
/// <currency-selector
///   [selected]="selectedCurrency"
///   [onSelect]="selectionHandler()"
/// ></currency-selector>
/// ```
@Component(
  selector: 'currency-selector',
  templateUrl: 'currency_selector.html',
  styleUrls: ['currency_selector.css'],
  directives: [coreDirectives],
)
class CurrencySelector implements OnDestroy {
  /// Список валют для выбора
  var currencies = <Currency>[
    Currency(code: 'USD', name: 'Доллар США', rate: 1),
    Currency(code: 'RUR', name: 'Российский рубль'),
    Currency(code: 'BYR', name: 'Белорусский рубль')
  ];

  /// Выбранная валюта
  ///
  /// Может быть инициализирована через атрибуты
  @Input()
  Currency selected;

  /// Устанавливает через [NgClass] css-класс выбранного (активного) эелемента
  /// списка
  Map<String, bool> setActiveCssClass(Currency currency) {
    return {'currency-selector-item_active': currency == selected};
  }

  /// Устанавливает выбранную валюту
  ///
  /// Срабатывает при клике на элемент списка
  void select(currency) {
    selected = currency;
    _selectController.add(selected);
  }

  /// Контроллер потока событий [onSelect]
  final _selectController = StreamController<Currency>.broadcast();

  /// Поток событий [onSelect]
  @Output()
  Stream<Currency> get onSelect => _selectController.stream;

  /// При уничтожении компонента закрывает поток событий [onSelect]
  @override
  void ngOnDestroy() {
    _selectController.close();
  }
}
