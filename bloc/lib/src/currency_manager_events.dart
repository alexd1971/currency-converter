import 'package:currency_converter_models/models.dart';

/// Событие менеджера валют
///
/// Базовый класс для всех событий менеджера валют
class CurrencyManagerEvent {}

/// Событие инициализации начального состояния менеджера валют
class InitCurrencyManagerEvent extends CurrencyManagerEvent {}

/// Событие добавления новой валюты
class AddCurrencyEvent extends CurrencyManagerEvent {
  /// Добавляемая валюта
  final Currency currency;
  AddCurrencyEvent(this.currency);
}

/// Событие обновления параметров валюты
class UpdateCurrencyEvent extends CurrencyManagerEvent {
  /// Обновленная валюта
  final Currency currency;
  UpdateCurrencyEvent(this.currency);
}

/// Событие удаления валюты
class RemoveCurrencyEvent extends CurrencyManagerEvent {
  /// Удаляемая валюта
  final Currency currency;
  RemoveCurrencyEvent(this.currency);
}
