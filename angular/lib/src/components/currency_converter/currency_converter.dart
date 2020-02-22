import 'dart:html';

import 'package:angular/angular.dart';
import 'package:currency_converter_models/models.dart';

import '../../../components.dart' show CurrencyInput;

/// Компонент конвертации валют
@Component(
  selector: 'currency-converter',
  templateUrl: 'currency_converter.html',
  styleUrls: ['currency_converter.css'],
  directives: [coreDirectives, CurrencyInput],
)
class CurrencyConverter {
  /// Элемент DOM, связанный с компонентом
  ///
  /// Элемент используется для анимации при удалении конверсии
  final Element _element;

  /// Создает экземпляр компонента и инжектирует элемент, связанный с
  /// компонентом
  CurrencyConverter(this._element);

  /// Список конверсий, связанных с компонентом
  ///
  /// Количество конверсий управляется методами [add] и [delete]. Изменение
  /// списка конверсий автоматически отражается в браузере благодаря
  /// использованию директивы [NgFor] в шаблоне
  List<CurrencyConversion> conversions = [
    CurrencyConversion(
        currency: Currency(code: 'USD', name: 'Доллар США', rate: 1),
        value: 100),
    CurrencyConversion(
        currency: Currency(code: 'RUR', name: 'Российский рубль', rate: 60),
        value: 6000),
  ];

  /// Добавляет новую конверсию
  void add() {
    conversions.insert(
        0,
        CurrencyConversion(
            currency: Currency(code: 'USD', name: 'Доллар США', rate: 1),
            value: 100));
  }

  /// Удаляет конверсию
  void delete(int i) {
    // Включаем анимацию удаления
    final conversionElements = _element.querySelectorAll('div.conversion');
    conversionElements[i]
        .animate([
          {'transform': 'translateX(0)'},
          {'transform': 'translateX(-100%)'}
        ], 1000)
        .onFinish
        .listen((_) {
          // После завершения анимации удаляем конверсию
          conversions.removeAt(i);
        });
  }

  /// Обработчик изменения состояния конверсии
  ///
  /// Срабатывает при изменении валюты или значения в поле ввода
  void onChange(int i) {
    print(conversions[i]);
  }
}
