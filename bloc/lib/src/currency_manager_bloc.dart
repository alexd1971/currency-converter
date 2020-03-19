import 'dart:async';
import 'package:bloc/bloc.dart';
import 'currency_manager_events.dart';
import 'package:currency_converter_models/models.dart';
import 'package:currency_converter_services/currency_service.dart';
import 'currency_converter_events.dart';
import 'currency_converter_bloc.dart';

/// Компонент бизнес-логики менеджера валют
///
/// В качестве событий компонент получает различные вариации [CurrencyManagerEvent].
/// Возвращаемое состояние - список валют [List<Currency>]
///
/// Все BLoC являются расширениями базового класса [Bloc] из пакета `bloc`
class CurrencyManagerBloc extends Bloc<CurrencyManagerEvent, List<Currency>> {
  /// Сервис доступа к данным валют
  final CurrencyService _service;

  /// Компонент бизнес-логики конвертера валют
  ///
  /// Логика конвертера валют связана с логикой менеджера валют. В частности,
  /// при удалении валюты в менеджере валют должны удаляться все конверсии с
  /// этой валютой в конвертере валют. Эта логика реализуется через эту связку.
  final CurrencyConverterBloc _currencyConverterBloc;

  /// Создает BLoC менеджера валют
  ///
  /// Здесь используется принцип Dependency Inversion из SOLID-принципов:
  /// через конструктор инжектируются зависимости:
  ///
  /// - [service] - сервис, реализующий интерфейс [CurrencyService]
  /// - [currencyConverterBloc] - компонент бизнес-логики конвертера валют
  ///
  /// Инжектирование зависимостей позволяет решить следующие важные задачи:
  ///
  /// - Позволяет легко переключаться на другие реализации сервиса и компонента.
  /// Например, можно легко вместо [MemoryCurrencyService] использовать
  /// [LocalCurrencyService], который сохраняет данные в локальном хранилище
  /// вместо оперативной памяти или другой, отправляющий данные на сервер.
  /// - При тестировании BLoC можно вместо реальных сервисов и компонентов
  /// использовать mocks
  CurrencyManagerBloc(
      CurrencyService service, CurrencyConverterBloc currencyConverterBloc)
      : _service = service,
        _currencyConverterBloc = currencyConverterBloc;

  @override
  List<Currency> get initialState => [];

  @override
  Stream<List<Currency>> mapEventToState(CurrencyManagerEvent event) async* {
    // Логика инициализации менеджера валют: возвращаем весь список валют
    if (event is InitCurrencyManagerEvent) {
      yield await _service.readAll();
    }

    // Логика добавления новой валюты:
    // - _service.add - добавляет валюту в хранилище и возвращает добавленную
    // валюту
    // - _state..add - добавляет новую валюту к новому состоянию
    if (event is AddCurrencyEvent) {
      yield _state..add(await _service.add(event.currency));
    }

    // Логика изменения параметров валюты
    if (event is UpdateCurrencyEvent) {
      // изменяем валюту в хранилище
      final updatedCurrency = await _service.update(event.currency);
      // находим индекс обновленной валюты в списке валют
      final updateIndex = state.indexWhere((c) => c == updatedCurrency);
      // возвращаем новое состояние с измененной валютой
      yield _state..[updateIndex] = updatedCurrency;
    }

    // Логика удаления валюты
    if (event is RemoveCurrencyEvent) {
      // удаляем валюту из хранилища
      final removedCurrency = await _service.remove(event.currency);
      // удаляем все конверсии с этой валютой
      // если конверсий несколько, то удаляем их по одной, получая после каждого
      // удаления новое состояние конверсий в _currencyConverterBloc
      await for (var conversions in _currencyConverterBloc) {
        // находим первую конверсию с этой валютой
        final i = conversions.indexWhere((c) => c.currency == event.currency);
        // если конверсия найдена, то
        if (i != -1) {
          // удаляем ее
          _currencyConverterBloc.add(RemoveConversionEvent(i));
        } else {
          // иначе заканчиваем процесс удаления
          break;
        }
      }
      // возвращаем новое состояние без удаленной валюты
      yield _state..removeWhere((c) => c == removedCurrency);
    }
  }

  /// Копия текущего состояния
  List<Currency> get _state => List.from(state);
}
