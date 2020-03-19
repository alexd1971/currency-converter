import 'package:currency_converter_models/models.dart';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:currency_converter_bloc/bloc.dart';

/// Режим редактора
///
/// - `create` - режим создания новой валюты
/// - `edit` - режим редактирования валюты
enum Mode { create, edit }

/// Редактор валюты
class CurrencyEditor extends StatefulWidget {
  /// Редактируемая валюта
  final Currency _currency;

  /// Режим редактора
  final Mode _mode;

  /// Создает редактор валюты
  CurrencyEditor({Currency currency, @required Mode mode})
      : assert(mode != null),
        _currency = currency,
        _mode = mode;

  @override
  _CurrencyEditorState createState() => _CurrencyEditorState();
}

/// Состояние редактора валюты
class _CurrencyEditorState extends State<CurrencyEditor> {
  /// Глобальный ключ формы редактора
  ///
  /// По этому ключу можно получать доступ к состоянию формы и параметрам самой
  /// формы.
  final _formKey = GlobalKey<FormState>();

  /// Состояние автовалидации формы
  ///
  /// Если значение `true`, то валидация формы происходит автоматически
  bool _formAutovalidate = false;

  /// Редактируемая валюта
  Currency currency;

  /// Валидатор обязательного ввода значения
  final required = RequiredValidator(errorText: 'Обязательноe поле');

  /// Валидатор, проверяющий, что введено ровно 3 символа
  ///
  /// Применяется для валидации значения в поле кода валюты
  final only3Chars =
      LengthRangeValidator(min: 3, max: 3, errorText: 'Требуется 3 буквы');

  /// Валидатор, проверяющий, что введенные символы только из английского
  /// алфавита
  final englishChars =
      PatternValidator(r'^[A-Za-z]*$', errorText: 'Только английские буквы');

  /// Валидатор ввода числа
  final onlyNumber = PatternValidator(r'^[0-9.]*$', errorText: 'Только число');

  @override
  void initState() {
    super.initState();
    // Инициализируем редактируемую валюту
    currency = widget._currency ?? Currency();
  }

  @override
  Widget build(BuildContext context) {
    // В соответствии с режимом формируем заголовок
    final title = widget._mode == Mode.create
        ? 'Новая валюта'
        : 'Изменить: ${currency.code}';
    return Scaffold(
      appBar: AppBar(
        // Устанавливаем заголовок в аппбаре приложения
        title: Text(title),
      ),
      body: Padding(
        padding: EdgeInsets.all(10),
        // Вставляем форму редактора
        // Редактор состоит из трех полей (код, название, курс) и двух кнопок
        // (сохранить, удалить)
        child: Form(
          // Используем созданный ранее глобальный ключ
          key: _formKey,
          // Устанавливаем текущее состояние автовалидации
          autovalidate: _formAutovalidate,
          // Поля и кнопки располагаем в колонку
          child: Column(
            children: <Widget>[
              // Поле кода валюты
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Код Валюты',
                ),
                // Начальное значение
                initialValue: currency.code ?? '',
                // Обработчик изменения
                onChanged: (value) {
                  // При изменении сохраняем значение поля в состоянии
                  // редактируемой валюты
                  currency.code = value;
                },
                // Подключаем валидатор
                // Композиция трех простых валидаторов
                validator: MultiValidator([
                  required,
                  englishChars,
                  only3Chars,
                ]),
                // Указываем, что нам нужно автоматически делать буквы большими
                textCapitalization: TextCapitalization.characters,
                // В режиме редактирования запрещаем изменять код валюты, так
                // как он является также идентификатором валюты
                readOnly: widget._mode == Mode.edit,
              ),
              // Поле наименования валюты
              TextFormField(
                decoration: InputDecoration(labelText: 'Наименование валюты'),
                initialValue: currency.name ?? '',
                onChanged: (value) {
                  currency.name = value;
                },
                validator: required,
              ),
              // Поле курса валюты
              TextFormField(
                decoration: InputDecoration(labelText: 'Курс валюты'),
                initialValue: currency.rate?.toString() ?? '',
                onChanged: (value) {
                  currency.rate = num.tryParse(value);
                },
                validator: MultiValidator([
                  required,
                  onlyNumber,
                ]),
              ),
              // Добавляем ряд кнопок
              Row(
                // Кнопки размещаем по середине строки
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.all(5),
                    // Кнопка сохранения валюты
                    child: RaisedButton(
                      child: Text('Сохранить'),
                      // Обработчик нажатия
                      onPressed: () {
                        // Если форма валидна
                        if (_formKey.currentState.validate()) {
                          CurrencyManagerEvent event;
                          switch (widget._mode) {
                            case Mode.create:
                              // В режиме создания формируем событие создания валюты
                              event = AddCurrencyEvent(currency);
                              break;
                            case Mode.edit:
                              // В режиме редактирования формируем событие изменения
                              // валюты
                              event = UpdateCurrencyEvent(currency);
                              break;
                          }
                          // Возвращаем событие
                          Navigator.of(context)
                              .pop<CurrencyManagerEvent>(event);
                        } else {
                          // Иначе включаем автовалидацию формы, чтобы
                          // пользователь увидел ошибки и добиваемся от него
                          // корректного ввода
                          setState(() {
                            _formAutovalidate = true;
                          });
                        }
                      },
                    ),
                  ),
                  // Кнопку удаления показываем только в режиме редактирования
                  if (widget._mode == Mode.edit)
                    Padding(
                      padding: EdgeInsets.all(5),
                      // Кнопка удаления
                      child: RaisedButton(
                        child: Text('Удалить',
                            style: TextStyle(
                              color: Colors.white,
                            )),
                        // Делаем кнопку красной, предупреждая об опасности
                        color: Colors.red,
                        // Обработчик нажатия
                        onPressed: () {
                          // Возвращаем событие удаления валюты
                          Navigator.of(context).pop<CurrencyManagerEvent>(
                              RemoveCurrencyEvent(currency));
                        },
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
