import 'dart:async';
import 'package:meta/meta.dart';
import 'package:currency_converter_models/models.dart';

import 'currency_service.dart';

/// Сервис доступа к валютам, хранящимся в оперативной памяти
///
/// Данный сервис можно использовать не только как самостоятельный сервис для
/// отладки приложения, но и в качестве базового класса для создания
/// кэширующего сервиса с другим хранилищем. Примеры реализации таких сервисов
/// для локального хранилища см. в пакетах `currency_converter_web` (каталог
/// `angular`) и `currency_converter_mobile` (каталог `flutter`)
class MemoryCurrencyService implements CurrencyService {
  /// Начальное состояние хранилища валют
  ///
  /// Свойство объявлено `@protected`, так как в классах наследниках оно может
  /// использоваться в качестве кэша валют.
  @protected
  var currencies = <Currency>[
    Currency(code: 'USD', name: 'Доллар США', rate: 1),
    Currency(code: 'RUR', name: 'Российский рубль', rate: 60),
  ];

  @override
  FutureOr<List<Currency>> readAll() => currencies;

  @override
  FutureOr<Currency> add(Currency currency) {
    currencies.add(currency);
    return currency;
  }

  @override
  FutureOr<Currency> update(Currency currency) {
    final updatedIndex = currencies.indexWhere((c) => c == currency);
    if (updatedIndex == null) {
      throw (Exception(
          'Updated currency not found: $currency. Try to create it first.'));
    }
    currencies[updatedIndex] = currency;
    return currency;
  }

  @override
  FutureOr<Currency> remove(Currency currency) {
    currencies.removeWhere((c) => c == currency);
    return currency;
  }
}
