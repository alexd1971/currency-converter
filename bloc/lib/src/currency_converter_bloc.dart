import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:currency_converter_models/models.dart';
import 'package:currency_converter_services/currency_service.dart';

import 'currency_converter_events.dart';

/// Компонент бизнес-логики конвертера валют
///
/// В качестве событий принимает варианты [CurrencyConverterEvent]
/// Возвращаемое состояние - список конверсий [List<Conversion>]
///
/// Компонент является расширением базового компонента [Bloc] из пакета `bloc`
class CurrencyConverterBloc
    extends Bloc<CurrencyConverterEvent, List<Conversion>> {
  /// Сервис доступа к данным валют
  final CurrencyService _service;

  /// Создает BLoC конвертера валют
  ///
  /// [service] - сервис, реализующий интерфейс [CurrencyService]
  ///
  /// В данной реализации состояние конвертера валют не сохраняется в постянном
  /// хранилище, поэтому при перезапуске приложения мы будем получать всегда
  /// начальное состояние конвертера, определяемое логикой инициализации
  CurrencyConverterBloc(CurrencyService service) : _service = service;

  @override
  List<Conversion> get initialState => [];

  @override
  Stream<List<Conversion>> mapEventToState(
      CurrencyConverterEvent event) async* {
    // Логика инициализации конвертера валют
    if (event is InitCurrencyConverterEvent) {
      final currencies = await _service.readAll();
      switch (currencies.length) {
        // если список валют пустой, то ничего не можем сконвертировать =>
        // возвращаем пустой список
        case 0:
          yield [];
          break;
        // если есть только одна валюта, то возвращаем список с конверсией,
        // содержащей эту валюту
        case 1:
          yield [Conversion(currency: currencies.first, value: 1)];
          break;
        // в остальных случаях возвращаем две конверсии с двумя первыми валютами
        // в списке
        default:
          // формируем первую конверсию со значением 1
          final first = Conversion(currency: currencies[0], value: 1);
          // формируем вторую конверсию сконвертированную в соответствии с курсами валют
          final second = _convert(
              value: first.value, from: first.currency, to: currencies[1]);
          // возвращаем начальное состояние конвертера
          yield [first, second];
      }
    }

    // Логика добавления новой конверсии
    if (event is AddConversionEvent) {
      // возвращаем новое состояние с добавленной пустой конверсией
      yield _state..add(Conversion());
    }

    // Логика изменения значения суммы конверсии
    if (event is ChangeConversionValueEvent) {
      // валюта измененной конверсии принимается за базовую, относительно
      // которой будут пересчитаны все остальные конверсии
      final fromCurrency = state[event.index].currency;
      // формируем и возвращаем новое состояние с пересчитанными значениями
      // конверсий
      yield state.asMap().entries.fold<List<Conversion>>([], (list, entry) {
        if (entry.key == event.index) {
          list.add(entry.value);
        } else {
          list.add(_convert(
              value: event.value,
              from: fromCurrency,
              to: entry.value.currency));
        }
        return list;
      });
    }

    // Логика изменения валюты конверсии
    if (event is ChangeConversionCurrencyEvent) {
      switch (state.length) {
        // если конверсий нет, то возвращаем пустой список
        case 0:
          yield [];
          break;
        // если конверсия только одна, то возвращаем конверсию с измененной валютой
        case 1:
          yield [
            Conversion(currency: event.currency, value: state.first.value)
          ];
          break;
        // во всех остальных случаях возвращаем новое состояние с пересчитанным
        // значением измененной конверсии относительно ближайшей соседней
        default:
          final sourceConversion = event.index == 0 ? state[1] : state[0];
          yield _state
            ..[event.index] = _convert(
                value: sourceConversion.value,
                from: sourceConversion.currency,
                to: event.currency);
      }
    }

    // Логика удаления конверсии
    if (event is RemoveConversionEvent) {
      // возвращаем новое состояние без удаленной конверсии
      yield _state..removeAt(event.index);
    }
  }

  /// Конвертирует сумму [value] валюты [from] в валюту [to]
  ///
  /// Возвращает новую конверсию
  Conversion _convert({num value, Currency from, Currency to}) {
    return Conversion(currency: to, value: to.rate * value / from.rate);
  }

  /// Копия текущего состояния
  List<Conversion> get _state => List.from(state);
}
