import 'dart:async';

import 'package:currency_converter_models/models.dart';
import 'package:currency_converter_services/currency_service.dart';
import 'package:localstorage/localstorage.dart';

/// Сервис доступа к данным валют
///
/// Данные валют сохраняются в локальном хранилище
///
/// Благодаря наследованию от [MemoryCurrencyService] получился кэширующий
/// сервис.
class LocalCurrencyService extends MemoryCurrencyService {
  /// Локальное хранилище
  LocalStorage _storage =
      LocalStorage('currencies.json', null, {'currencies': <Currency>[]});

  @override
  FutureOr<List<Currency>> readAll() async {
    await _storage.ready;
    currencies = ((_storage.getItem('currencies') as List) ?? [])
        .map<Currency>((json) => Currency.fromJson(json))
        .toList();
    return super.readAll();
  }

  @override
  FutureOr<Currency> add(Currency currency) async {
    await _storage.ready;
    final addedCurrency = await super.add(currency);
    await _save();
    return addedCurrency;
  }

  @override
  FutureOr<Currency> update(Currency currency) async {
    await _storage.ready;
    final updatedCurrency = await super.update(currency);
    await _save();
    return updatedCurrency;
  }

  @override
  FutureOr<Currency> remove(Currency currency) async {
    await _storage.ready;
    final removedCurrency = await super.remove(currency);
    await _save();
    return removedCurrency;
  }

  /// Сохраняет состояние валют в хранилище
  Future<void> _save() async {
    await _storage.ready;
    return _storage.setItem('currencies', currencies);
  }
}
