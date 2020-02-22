import 'package:angular/angular.dart';
import 'package:angular_forms/angular_forms.dart';

import 'handler_mixins.dart';
import 'labeled_input.dart';

/// Директива реализующая интефейс [ControlValueAccessor] для компнента
/// [LabeledInput]
///
/// Реализация директивы аналогична реализации [LabeledInputDefaultValueAccessor]
/// за исключением того, что здесь реализуется приведение значения поля к
/// числовому типу. Если значением поля является не число, то значением элемента
/// формы будет `null` и само поле останется пустым.
///
/// При подключении директивы к компоненту через параметр аннотации `directives`
/// она автоматически привязывается ко всем элементам `labeled-input`, у которых
/// указаны атрибуты `ngControl` и `type=number` (см. параметр `selector`)
@Directive(selector: 'labeled-input[type=number][ngControl]', providers: [
  ExistingProvider.forToken(ngValueAccessor, LabeledInputNumberValueAccessor)
])
class LabeledInputNumberValueAccessor
    with ChangeHandler<num>, TouchHandler
    implements ControlValueAccessor<num> {
  final LabeledInput _input;

  /// Создает директиву
  ///
  /// При создании автоматически инжектируется связанный компонент
  LabeledInputNumberValueAccessor(this._input);

  /// Обрабатывает изменения значения элемента формы
  @HostListener('onInput')
  void changedHandler(_) {
    final value =
        num.tryParse(_input.value); // пытаемся привести значение к числу
    onChange(value, rawValue: _input.value);
    if (value == null) {
      _input.value = ''; // если не число, то пустое значение
    }
  }

  /// Устанавливает значение элемента формы
  ///
  /// Здесь происходит обратное преобразование: число => строка
  @override
  void writeValue(num value) {
    _input.value = value == null ? '' : '$value';
  }

  /// В зависимости от значения аргумента делает элемент формы
  /// доступным или недоступным.
  @override
  void onDisabledChanged(bool isDisabled) {
    _input.disabled = isDisabled;
  }
}
