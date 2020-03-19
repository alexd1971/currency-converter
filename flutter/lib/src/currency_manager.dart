import 'package:currency_converter_bloc/bloc.dart';
import 'package:currency_converter_models/models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'add_button.dart';
import 'currency_editor.dart';

/// Компонент управления валютами
///
/// Позволяет добавлять, изменять и удалять валюты
///
/// Все имеющиеся валюты отображаются в таблице из трех колонок: код,
/// название и курс валюты.
class CurrencyManager extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Получаем экземпляр BLoC менеджера валют
    // ignore: close_sinks
    final currencyBloc = BlocProvider.of<CurrencyManagerBloc>(context);
    // Укладываем в стопку таблицу валют и кнопку добавления новой
    // валюты
    return Stack(
      // выравниваем таблицу по середине
      alignment: AlignmentDirectional.topCenter,
      children: [
        Padding(
          padding: EdgeInsets.only(top: 8),
          // Таблицу валют вставляем в ScrollView, чтобы можно было прокручивать,
          // если список будет длинным
          child: SingleChildScrollView(
            // Используем BlocBuilder, чтобы автоматически перерисовывать
            // таблицу при изменении состояния
            child: BlocBuilder<CurrencyManagerBloc, List<Currency>>(
              // Билдер получает состояние в виде списка валют
              builder: (context, currencies) {
                // Конструируем таблицу
                return DataTable(
                    horizontalMargin: 5,
                    columnSpacing: 40,
                    // Описание колонок
                    columns: [
                      // Колонка кода валюты
                      DataColumn(
                        // Чтобы исключить повторяющийся код используем метод
                        // _headerLabel()
                        label: _headerLabel('Код'),
                      ),
                      // Колонка наименования валюты
                      DataColumn(
                        label: _headerLabel('Наименование'),
                      ),
                      // Колонка курса валюты
                      DataColumn(
                        label: _headerLabel('Курс'),
                        numeric: true,
                      ),
                      // Колонка для отображения кнокпи редактирования
                      DataColumn(label: Text(''))
                    ],
                    // Строки таблицы фрмируются на основании списка валют
                    rows: currencies
                        .map((currency) => DataRow(cells: [
                              // Код валюты
                              DataCell(
                                Text(currency.code ?? ''),
                              ),
                              // Название валюты
                              DataCell(
                                Text(currency.name ?? ''),
                              ),
                              // Курс валюты
                              DataCell(
                                Text(currency.rate.toString() ?? ''),
                              ),
                              // Кнопка редактирования
                              DataCell(
                                Icon(FontAwesomeIcons.edit),
                                // Обработчик тыка в кнопку редактирования
                                onTap: () async {
                                  // При тыке в редактирование передаем валюту из
                                  // данной строки в редактор валюты и дожидаемся
                                  // результата редактирования. Результатом могут
                                  // быть события менеджера валют:
                                  // - UpdateCurrencyEvent при изменении валюты
                                  // - RemoveCurrencyEvent при удалении валюты
                                  final event = await Navigator.of(context)
                                      .push<CurrencyManagerEvent>(
                                    MaterialPageRoute(
                                      builder: (context) => CurrencyEditor(
                                        currency: currency,
                                        mode: Mode.edit,
                                      ),
                                    ),
                                  );
                                  // Передаем полученное событие компоненту
                                  // бизнес-логики
                                  currencyBloc.add(event);
                                },
                              ),
                            ]))
                        .toList());
              },
            ),
          ),
        ),
        // Кнопка добавления новой валюты
        AddButton(
          // Обработчик нажатия
          onPressed: () async {
            // Передаем в редактор валюты "пустую" валюту и дожидаемся результата
            final event = await Navigator.of(context)
                .push<CurrencyManagerEvent>(MaterialPageRoute(
              builder: (context) => CurrencyEditor(
                currency: Currency(),
                mode: Mode.create,
              ),
            ));
            // Если новая валюта создана, то добавляем ее
            if (event != null) {
              currencyBloc.add(event);
            }
          },
        ),
      ],
    );
  }

  /// Возвращает виджет текста заголовка колонки
  Widget _headerLabel(String text) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}
