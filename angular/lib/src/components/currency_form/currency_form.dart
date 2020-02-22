import 'package:angular/angular.dart';
import 'package:angular_forms/angular_forms.dart';
import 'package:currency_converter_models/models.dart';

import '../../../components.dart';
import '../../../validators.dart';
import '../labled_input/labeled_input_default_value_accessor.dart';
import '../labled_input/labeled_input_number_value_accessor.dart';

/// Форма для ввода параметров валюты
///
/// Для включения в шаблон используется элемент `<currency-form></currency-form>`
///
/// Форма в качестве полей ввода использует [LabeledInput], к которым подключены
/// валидаторы [RequiredValidator] (реализован в Angular) и [OnlyNumberValidator]
/// (самописный)
///
/// Поддерживаемые атрибуты:
///
/// * [currency]::[Currency] - валюта
@Component(
  selector: 'currency-form',
  templateUrl: 'currency_form.html',
  styleUrls: ['currency_form.css'],
  directives: [
    LabeledInput,
    formDirectives,
    RequiredValidator,
    CurrencyCodeValidator,
    OnlyNumberValidator,
    LabeledInputDefaultValueAccessor,
    LabeledInputNumberValueAccessor,
    LabeledInputUpperCaseValueAccessor
  ],
)
class CurrencyForm {
  /// Форма
  ///
  /// Поскольку логика компонента требует активного анализа состояния
  /// как самой формы так и ее элемментов, принято решение конструировать
  /// форму прямо в компоненте и передавать в шаблон, а не наоборот - передавать
  /// из шаблона в компонент.
  ///
  /// Форма представляет собой группу элементов управления [ControlGroup].
  /// Имена элементов формы определяются в шаблоне через атрибут [ngControl].
  final form = ControlGroup({
    'code': Control<String>(''),
    'name': Control<String>(''),
    'rate': Control<num>()
  });

  /// Признак валидности формы
  ///
  /// Валидность формы автоматически определяется валидностью всех ее элементов.
  bool get valid => form.valid ?? true;

  /// Пояснительный текст для поля "Код валюты"
  ///
  /// Формирует сообщение об ошибке, если поле не валидно.
  String get codeHint => _message(form.controls['code']);

  /// Пояснительный текст для поля "Название валюты"
  ///
  /// Формирует сообщение об ошибке, если поле не валидно.
  String get nameHint => _message(form.controls['name']);

  /// Пояснительный текст для поля "Рэйтинг валюты"
  ///
  /// Формирует сообщение об ошибке, если поле не валидно.
  String get rateHint => _message(form.controls['rate']);

  /// Объект валюты, связанный с формой
  @Input()
  Currency currency = Currency();

  @Input()
  bool readOnly = false;

  /// Маппинг типа ошибки и сообщения об ошибке
  final _messages = <String, String>{
    'required': 'Обязательно',
    'isNotNumber': 'Нужно число',
    'currencyCodeInvalid': '3 англ. буквы'
  };

  /// Возвращает сообщение об ошибке, если поле не валидно.
  ///
  /// Если поле валидно, то возвращается пустая строка.
  String _message(AbstractControl control) {
    final messageId = control.errors?.entries?.first?.key;
    if (!control.pristine && messageId != null) return _messages[messageId];
    return '';
  }
}
