import 'package:currency_converter_bloc/bloc.dart';
import 'package:currency_converter_models/models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'add_button.dart';
import 'conversion_input.dart';

/// Конвертер валют
class CurrencyConverter extends StatefulWidget {
  @override
  _CurrencyConverterState createState() => _CurrencyConverterState();
}

/// Состояние конвертера валют
class _CurrencyConverterState extends State<CurrencyConverter> {
  /// Индекс компонента ввода параметров конверсии, который имеет фокус ввода
  ///
  /// Поскольку при изменении значения суммы в одной из конверсий происходит
  /// автоматический пересчет значений в других конверсиях, и, как следствие,
  /// перерисовка всех конверсий, нам необходимо после перерисовки возвращать
  /// фокус ввода в ту конверсию, которая в данный момент изменяется. Для этого
  /// в этом свойстве мы будем запоминать индекс компонента, у которого сейчас
  /// фокус ввода.
  int _focusedConvertionInput;

  @override
  Widget build(BuildContext context) {
    // Получаем из контекста экземпляр BLoC конвертера валют
    // ignore: close_sinks
    final converterBloc = BlocProvider.of<CurrencyConverterBloc>(context);
    // Складываем в стопку список конверсий и плавающую кнопку добавления
    // конверсии
    return Stack(
      children: <Widget>[
        // Используем BlocBuilder для автоматической перерисовки интерфейса при
        // изменении состояния
        BlocBuilder<CurrencyConverterBloc, List<Conversion>>(
          // Билдер получает на вход состояние в виде списка конверсий
          builder: (context, conversions) {
            // Формируем представление списка конверсий
            return ListView.separated(
              // Количество элементов списка определяется количеством конверсий
              itemCount: conversions.length,
              // Функция, создающая виджет, который будет разделителем между элементами
              // списка. Обычно это Divider.
              separatorBuilder: (context, i) => Divider(),
              // itemBuilder конструирует элемент списка
              // на вход передается контекст и индекс элемента,
              // который нужно сконструировать
              itemBuilder: (context, i) {
                // Элемент списка можно удалять смахиванием в сторону. За это
                // отвечает виджет [Dismissible], в который мы оборачиваем
                // [ConversionInput]
                return Dismissible(
                  // Удаляемый элемент должен иметь уникальный ключ
                  key: UniqueKey(),
                  // background отвечает за шлейф при смахивании
                  background: Container(color: Colors.black12),
                  // Удаление смахиванием производит только визуальное удаление.
                  // Чтобы реально удалить конверсию, нужно обработать событие
                  // onDismissed. При этом инициируем соответствующее событие BLoC
                  onDismissed: (direction) {
                    converterBloc.add(RemoveConversionEvent(i));
                  },
                  // Сам элемент списка
                  child: ConversionInput(
                    conversion: conversions[i],
                    // при изменении валюты конверсии инициируем соответствующее
                    // событие BLoC
                    onCurrencyChange: (currency) {
                      converterBloc
                          .add(ChangeConversionCurrencyEvent(i, currency));
                    },
                    // при изменении значения суммы конверсии инициируем
                    // соответствующее событие BLoC
                    onValueChange: (value) {
                      converterBloc.add(ChangeConversionValueEvent(i, value));
                    },
                    // при получении фокуса ввода запоминаем индекс конверсии,
                    // чтобы потом при изменении значения суммы и перерисовывании
                    // интерфейса возвращать фокус ввода
                    onFocus: () {
                      _focusedConvertionInput = i;
                    },
                    // автоматичеки устанавливаем фокус ввода, если индекс
                    // конверсии совпадает с сохраненным индексом
                    autofocus: _focusedConvertionInput == i,
                  ),
                );
              },
            );
          },
        ),
        // Кнопка добавления конверсии
        AddButton(
          onPressed: () {
            converterBloc.add(AddConversionEvent());
          },
        ),
      ],
    );
  }
}
