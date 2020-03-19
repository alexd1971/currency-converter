import 'package:currency_converter_models/models.dart';

/// Событие конвертера валют
///
/// Базовый класс для всех событий конвертера валют
class CurrencyConverterEvent {}

/// Событие инициализации конвертера валют
///
/// При этом событии BLoC инициализирует начальное состояние конвертера валют
class InitCurrencyConverterEvent extends CurrencyConverterEvent {}

/// Событие добавления конверсии
class AddConversionEvent extends CurrencyConverterEvent {}

/// Событие изменения валюты конверсии
class ChangeConversionCurrencyEvent extends CurrencyConverterEvent {
  /// Индекс измененной конверсии
  final int index;

  /// Новое значение валюты конверсии
  final Currency currency;
  ChangeConversionCurrencyEvent(this.index, this.currency);
}

/// Событие изменения значения суммы конверсии
class ChangeConversionValueEvent extends CurrencyConverterEvent {
  /// Индекс измененнной конверсии
  final int index;

  /// Новое значение суммы конверсии
  final num value;
  ChangeConversionValueEvent(this.index, this.value);
}

/// Событие удаления конверсии
class RemoveConversionEvent extends CurrencyConverterEvent {
  /// Индекс удаляемой конверсии
  final int index;
  RemoveConversionEvent(this.index);
}
