import 'package:currency_converter_bloc/bloc.dart';
import 'package:currency_converter_models/models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Компонент ввода параметров конверсии
class ConversionInput extends StatefulWidget {
  /// Конверсия
  ///
  /// Определяет начальное состояние конверсии при создании компонента.
  final Conversion _conversion;

  /// Функция, которая вызывается при изменении валюты конверсии
  final void Function(Currency) _onCurrencyChange;

  /// Функция, которая вызывается при изменении значения суммы конверсии
  final void Function(num) _onValueChange;

  /// Функция, которая вызывается при переходе фокуса на поле ввода компонента
  final VoidCallback _onFocus;

  /// Признак автофокуса
  ///
  /// Если `true`, то поле автоматически получает фокус после перерисовывания
  final bool _autofocus;

  /// Создает компонент [ConversionInput]
  ///
  /// - [conversion] - начальное состояние конверсии
  /// - [onCurrencyChange] - функция, которую нужно вызвать при изменении валюты
  /// конверсии
  /// - [onValueChange] - функция, которую нужно вызвать при изменении значения
  /// суммы конверсии
  /// - [onFocus] - функция, которую нужно вызвать при получении фокуса ввода
  /// - [autofocus] - признак автофокуса
  ConversionInput({
    Conversion conversion,
    void Function(Currency) onCurrencyChange,
    void Function(num) onValueChange,
    VoidCallback onFocus,
    bool autofocus: false,
  })  : _conversion = conversion,
        _onCurrencyChange = onCurrencyChange,
        _onValueChange = onValueChange,
        _onFocus = onFocus,
        _autofocus = autofocus;

  @override
  _ConversionInputState createState() => _ConversionInputState();
}

/// Состояние компонента ввода параметров конверсии
class _ConversionInputState extends State<ConversionInput> {
  /// Конверсия
  ///
  /// Определяет текущее состояние конверсии
  Conversion _conversion;

  /// Контроллер редактирования текста
  ///
  /// Используется для задания начального состояния поля ввода суммы.
  TextEditingController _controller;

  /// Объект, отвечающий за передачу фокуса
  ///
  /// Используется для
  /// - фиксации события получения фокуса
  /// - передачи фокуса, если установлен признак [autofocus] == `true`
  FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    //Инициализируем начальное состояние конверсии.
    // Если в конструктор компонента не передается конверсия, то создаем пустую
    _conversion = widget._conversion ?? Conversion();
    // Инициализируем значение поля ввода суммы
    _controller =
        TextEditingController(text: _conversion.value?.toString() ?? '');
    // Инициализируем FocusNode и устанавливаем обработчик изменения фокуса
    _focusNode = FocusNode()
      ..addListener(() {
        // если компонент получил фокус ввода и установлен обработчик onFocus,
        // то вызываем ее
        if (_focusNode.hasFocus && widget._onFocus != null) {
          widget._onFocus();
        }
      });
  }

  @override
  void dispose() {
    // При удалении компонента нужно почистить за собой:
    // удаляем _focusNode и _controller
    _focusNode.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Если autofocus == true, то запрашиваем фокус для компонента
    if (widget._autofocus) {
      FocusScope.of(context).requestFocus(_focusNode);
    }
    return Padding(
      // отступы, чтобы было красиво
      padding: EdgeInsets.all(15),
      // Визуально компонент представляет собой расположенные в ряд выпадающий
      // список выбора валюты и поле ввода суммы.
      child: Row(
        children: <Widget>[
          // Растягиваем на все доступное пространство
          Expanded(
            // Параметр flex позволяет управлять относительной шириной виджета
            flex: 4,
            // Выпадающий список для выбора валюты
            // Упаковываем список в ScrollView, чтобы он мог прокручиваться,
            // если будет слишком длинным
            child: SingleChildScrollView(
              // Используем BlocBuilder, который автоматически перерисовывает
              // компонент при изменении состояния
              child: BlocBuilder<CurrencyManagerBloc, List<Currency>>(
                // на вход билдер получает помимо контекста состояние BLoC
                // в нашем случае это список валют
                builder: (context, currencies) {
                  // собственно выпадающий список
                  return DropdownButton<Currency>(
                    // Начальное выбранное значение
                    value: _conversion.currency,
                    isExpanded: true,
                    // Список валют
                    items: currencies.map((currency) {
                      // Конструируем элемент списка
                      return DropdownMenuItem<Currency>(
                        // Значение (валюта), которое соответствует данному элементу
                        // списка. Это значение возвращается при выборе.
                        value: currency,
                        // Виджет, элемента списка, который отображается в интерфейсе
                        // Представляет собой строку с выделенным жирным  кодом
                        // валюты и ее названием.
                        child: Row(
                          children: [
                            Padding(
                              // чтобы было красиво
                              padding: EdgeInsets.symmetric(horizontal: 5),
                              // Код валюты
                              child: Text(
                                currency.code,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold, // жирно
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 5),
                              // Название валюты
                              child: Text(currency.name),
                            )
                          ],
                        ),
                      );
                    }).toList(),
                    // При выборе валюты вызываем функцию onCurrencyChange,
                    // если она установлена.
                    onChanged: (value) {
                      if (widget._onCurrencyChange != null) {
                        widget._onCurrencyChange(value);
                      }
                    },
                    // Это просто для красоты
                    underline: Container(
                      height: 0,
                    ),
                  );
                },
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Padding(
              padding: EdgeInsetsDirectional.only(start: 15),
              // Поле ввода суммы
              child: TextField(
                // Используем инициализированный ранее контроллер
                controller: _controller,
                // Используем инициализированный ранее экземпляр FocusNode
                focusNode: _focusNode,
                // При входе в поле будет открываться цифровая клавиатура
                keyboardType: TextInputType.numberWithOptions(
                  // Позволяет вводить десятичную запятую (точку)
                  decimal: true,
                ),
                // Устанавливаем обработчик изменения значения суммы конверсии
                onChanged: (value) {
                  // пытаемся перевести введенное значение в число
                  var newValue = num.tryParse(value) ?? 0;
                  // если что-то поменялось, то устанавливаем новое значение и
                  // вызываем функцию обработки изменения значения, если она
                  // установлена
                  if (_conversion.value != newValue) {
                    _conversion.value = newValue;
                    if (widget._onValueChange != null) {
                      widget._onValueChange(_conversion.value);
                    }
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
