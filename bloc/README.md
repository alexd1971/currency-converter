# Компоненты бизнес-логики

Для реализации BLoC-паттерна использованы взаимосвязанные пакеты:

- [bloc](https://pub.dev/packages/bloc) - базовый пакет для реализации BLoC
- [flutter_bloc](https://pub.dev/packages/flutter_bloc) - пакет для подключение BLoC в мобильное приложение
- [angular_bloc](https://pub.dev/packages/angular_bloc) - пакет для подключение BLoC в web-приложение

Данный пакет реализует следующие BLoC:

- `CurrencyConverterBloc` - компонент бизнес-логики непосредственно конвертера валют
- `CurrencyManagerBloc` - компонент бизнес-логики управления валютами
