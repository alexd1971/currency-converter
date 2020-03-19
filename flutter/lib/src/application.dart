import 'package:currency_converter_bloc/bloc.dart';
// ignore: unused_import
import 'package:currency_converter_services/currency_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// ignore: unused_import
import 'local_currency_service.dart';

import 'home_page.dart';

/// Корневой виджет приложения
///
/// Само приложение - это компонент без состояния. Он никогда не
/// перерисовывается
///
/// Ответственность компонента:
/// - инициализация бизнес-логики
/// - переход к начальной (домашней) странице приложения при запуске
class Application extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Создаем сервис доступа к данным валют
    // На данный момент существует две реализации сервиса:
    // - MemoryCurrencyService, который хранит данные валют в оперативной памяти
    // - LocalCurrencyService, который хранит данные валют в локальном хранилище
    // Можно экспериметировать и заменять один на другой, наблюдая за изменениями
    // поведения приложения.
    final currencyService = LocalCurrencyService();

    // MaterialApp - это стандартный виджет для создания приложений
    return MaterialApp(
        title: 'Currency Converter',
        // цветовая тема приложения
        theme: ThemeData(
          primarySwatch: Colors.blueGrey,
        ),
        // Используем BlocProvider для инициализации компонентов бизнес-логики.
        // Поскольку компонентов два, то вкладываем один BlocProvider в другой.
        // HomePage получает доступ к обоим BLoC
        home: BlocProvider<CurrencyConverterBloc>(
          // Фабричный метод создает и инициализирует BLoC конвертера валют
          create: (context) => CurrencyConverterBloc(currencyService)
            ..add(InitCurrencyConverterEvent()),
          child: BlocProvider<CurrencyManagerBloc>(
            // Фабричный метод создает и инициализирует BLoC менеджера валют
            create: (context) => CurrencyManagerBloc(currencyService,
                BlocProvider.of<CurrencyConverterBloc>(context))
              ..add(InitCurrencyManagerEvent()),
            // Начальная страница приложения
            child: HomePage(),
          ),
        ));
  }
}
