import 'package:angular/angular.dart';
import 'package:angular_forms/angular_forms.dart';
import 'package:currency_converter_models/models.dart';

import '../../../components.dart';
import '../../../validators.dart';
import '../labeled_input/labeled_input_default_value_accessor.dart';
import '../labeled_input/labeled_input_number_value_accessor.dart';

/// Режим работы формы
///
/// Режим влияет на доступность полей формы для редактирования.
/// В режиме создания можно редактировать все поля. В режиме редактирования
/// нельзя изменять код валюты.
enum Mode { create, edit }

/// Форма для ввода параметров валюты
///
/// Для включения в шаблон используется элемент `<currency-form></currency-form>`
///
/// Форма в качестве полей ввода использует [LabeledInput], к которым подключены
/// валидаторы [RequiredValidator] (реализован в Angular),
/// [CurrencyCodeValidator] и [OnlyNumberValidator] (самописные)
///
/// Поддерживаемые атрибуты:
///
/// * [currency]::[Currency] - валюта
@Component(
  selector: 'currency-editor',
  templateUrl: 'currency_editor.html',
  styleUrls: ['currency_editor.css'],
  directives: [
    LabeledInput, // этот компонент используется в шаблоне
    formDirectives,
    // подключаем директивы валидаторов
    RequiredValidator,
    CurrencyCodeValidator,
    OnlyNumberValidator,
    // подключаем директивы получения значений полей формы
    LabeledInputDefaultValueAccessor,
    LabeledInputNumberValueAccessor,
    LabeledInputUpperCaseValueAccessor
  ],
  exports: [Mode], // экспортируем [Mode], чтобы использовать его в шаблоне
)
class CurrencyEditor {
  /// Форма
  ///
  /// Собственно форма из шаблона.
  /// Доступ к форме необходим для проверки ее валидности и для сброса
  /// В исходное состояние.
  @ViewChild('form')
  NgForm form;

  /// Признак валидности формы
  ///
  /// Валидность формы автоматически определяется валидностью всех ее элементов.
  bool get valid => form.valid ?? true;

  /// Поле, на котором в данный момент находится фокус ввода
  ///
  /// Используется для вывода ошибки в редактируемом поле, если она есть
  AbstractControl focused;

  /// Валюта, связанная с формой
  @Input()
  Currency currency = Currency();

  /// Признак "только для чтения"
  ///
  /// Если признак установлен в `true`, то поля формы нельзя редактировать
  @Input()
  bool readOnly = false;

  /// Режим работы формы
  ///
  /// - [Mode].create - режим создания новой валюты (все поля можно редактировать)
  /// - [Mode].edit - режим редактирования валюты (можно изменить все кроме кода валюты)
  @Input()
  Mode mode = Mode.create;

  /// Маппинг типа ошибки и сообщения об ошибке
  final _messages = <String, String>{
    'required': 'Обязательное поле',
    'isNotNumber': 'Требуется число',
    'currencyCodeInvalid': 'Необходимо ввести 3 английские буквы'
  };

  /// Сообщение об ошибке, если поле не валидно.
  ///
  /// Если поле валидно, то возвращается пустая строка.
  /// Сообщение об ошибке возвращается только для поля, в котором находится
  /// фокус ввода
  String get message {
    final messageId = focused?.errors?.entries?.first?.key;
    if (messageId == null || focused.pristine) return '';
    return _messages[messageId];
  }

  /// Сбрасывает форму в исходное состояние
  void reset() {
    focused = null;
    form.reset();
  }
}
