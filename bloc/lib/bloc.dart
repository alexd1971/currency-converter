/// Библиотека бизнес логики конвертера валют
///
/// Реализует классы событий пользовательского интерфейса:
///
/// - Управление валютами:
///   - [InitCurrencyManagerEvent] - инициализация начального состояния
///   - [AddCurrencyEvent] - добавление валюты
///   - [UpdateCurrencyEvent] - изменение параметров валюты
///   - [RemoveCurrencyEvent] - удаление валюты
/// - Конвертация валют:
///   - [InitCurrencyConverterEvent] - инициализация начального состояния
///   - [AddConversionEvent] - добавление конверсии
///   - [ChangeConversionCurrencyEvent] - изменение валюты конверсии
///   - [ChangeConversionValueEvent] - изменение значения суммы конверсии
///   - [RemoveConversionEvent] - удаление конверсии
///
/// Реализует компоненты бизнес-логики:
///
/// - [CurrencyManagerBloc] - компонент бизнес-логики менеджера валют
/// - [CurrencyConverterBloc] - компонент бизнес-логики собственно конвертера валют
library currency_converter_bloc;

export 'src/currency_converter_bloc.dart';
export 'src/currency_converter_events.dart';
export 'src/currency_manager_bloc.dart';
export 'src/currency_manager_events.dart';
