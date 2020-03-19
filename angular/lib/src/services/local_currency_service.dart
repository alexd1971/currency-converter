import 'dart:async';
import 'dart:convert';
import 'dart:html';

import 'package:currency_converter_models/models.dart';
import 'package:currency_converter_services/currency_service.dart';

/// Сервис доступа к данным валют
///
/// Реализует хранение данных валют в локальном хранилище
///
/// Благодаря наследованию от [MemoryCurrencyService] реализует кэширование
/// данных в оперативной памяти
class LocalCurrencyService extends MemoryCurrencyService {
  @override
  FutureOr<List<Currency>> readAll() {
    currencies =
        (json.decode(window.localStorage['currencies'] ?? '[]') as List)
            .map<Currency>((json) => Currency.fromJson(json))
            .toList();
    return super.readAll();
  }

  @override
  FutureOr<Currency> add(Currency currency) async {
    final addedCurrency = await super.add(currency);
    _save();
    return addedCurrency;
  }

  @override
  FutureOr<Currency> update(Currency currency) async {
    final updatedCurrency = await super.update(currency);
    _save();
    return updatedCurrency;
  }

  @override
  FutureOr<Currency> remove(Currency currency) async {
    final removedCurrency = await super.remove(currency);
    _save();
    return removedCurrency;
  }

  /// Сохраняет состояние валют в хранилище
  void _save() {
    window.localStorage['currencies'] = json.encode(currencies);
  }
}
