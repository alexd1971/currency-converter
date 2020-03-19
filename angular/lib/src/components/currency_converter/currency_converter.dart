import 'dart:html';

import 'package:angular/angular.dart';
import 'package:angular_bloc/angular_bloc.dart';
import 'package:currency_converter_models/models.dart';
import 'package:currency_converter_bloc/bloc.dart';

import '../../../components.dart' show ConversionInput;

/// Компонент конвертации валют
@Component(
  selector: 'currency-converter',
  templateUrl: 'currency_converter.html',
  styleUrls: ['currency_converter.css'],
  directives: [
    coreDirectives,
    ConversionInput, // в шаблоне используется этот компонент
  ],
  // BlocPipe используется в шаблоне для получения состояния BLoC
  pipes: [BlocPipe],
)
class CurrencyConverter {
  /// Элемент DOM, связанный с компонентом
  ///
  /// Элемент используется для анимации при удалении конверсии
  final Element _element;

  /// BLoC конвертера валют
  final CurrencyConverterBloc bloc;

  /// Создает экземпляр компонента и инжектирует элемент, связанный с
  /// компонентом, и BLoC
  CurrencyConverter(this._element, this.bloc);

  /// Индекс конверсии, на которой находится фокус ввода
  ///
  /// Используется для восстановления фокуса ввода после обновления состояния
  /// конверсий
  int focusedConversionIndex;

  /// Добавляет новую конверсию
  void add() {
    // генерируем событие добавления конверсии
    bloc.add(AddConversionEvent());
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
          bloc.add(RemoveConversionEvent(i));
        });
  }

  /// Обработчик изменения состояния конверсии
  ///
  /// Срабатывает при изменении валюты или значения в поле ввода
  void onValueChange(int i, num value) {
    bloc.add(ChangeConversionValueEvent(i, value));
  }

  void onCurrencyChange(int i, Currency currency) {
    bloc.add(ChangeConversionCurrencyEvent(i, currency));
  }
}
