import 'dart:async';
import 'package:currency_converter_models/models.dart';

/// Интерфейс сервиса доступа к валютам
///
/// Объявляет базовые методы досупа к данным.
///
/// Все методы должны быть реализованя в конкретной реализации сервиса для
/// выбранного способа хранения данных.
///
/// Простейшая реализация для хранения данных в оперативной памяти приведена в
/// [MemoryCurrencyService]
abstract class CurrencyService {
  /// Получает весь список валют
  FutureOr<List<Currency>> readAll();

  /// Добавляет новую валюту в список
  ///
  /// Возвращает добавленную валюту
  FutureOr<Currency> add(Currency currency);

  /// Обновляет данные валюты
  ///
  /// Возвращает обновленную валюту
  FutureOr<Currency> update(Currency currency);

  /// Удаляет валюту из списка валют
  ///
  /// Возвращает удаленную валюту
  FutureOr<Currency> remove(Currency currency);
}
