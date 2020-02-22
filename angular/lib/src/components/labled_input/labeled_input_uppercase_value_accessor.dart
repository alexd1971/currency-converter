import 'package:angular/angular.dart';
import 'package:angular_forms/angular_forms.dart';

import 'handler_mixins.dart';
import 'labeled_input.dart';

/// Директива реализующая интефейс [ControlValueAccessor] для компнента
/// [LabeledInput]
///
/// Реализация директивы аналогична реализации [LabeledInputDefaultValueAccessor]
/// за исключением того, что здесь реализуется приведение значения поля к
/// верхнему регистру.
///
/// При подключении директивы к компоненту через параметр аннотации `directives`
/// она автоматически привязывается ко всем элементам `labeled-input`, у которых
/// указаны атрибуты `ngControl` и `type=upper` (см. параметр `selector`)
@Directive(selector: 'labeled-input[type=upper][ngControl]', providers: [
  ExistingProvider.forToken(ngValueAccessor, LabeledInputUpperCaseValueAccessor)
])
class LabeledInputUpperCaseValueAccessor
    with ChangeHandler<String>, TouchHandler
    implements ControlValueAccessor<String> {
  final LabeledInput _input;

  /// Создает директиву
  ///
  /// При создании автоматически инжектируется связанный компонент
  LabeledInputUpperCaseValueAccessor(this._input);

  /// Обрабатывает изменения значения элемента формы
  @HostListener('onInput')
  void changedHandler(_) {
    final value = _input.value.toUpperCase();
    onChange(value, rawValue: _input.value);
    _input.value = value;
  }

  /// Устанавливает значение элемента формы
  @override
  void writeValue(String value) {
    _input.value = value == null ? '' : value.toUpperCase();
  }

  /// В зависимости от значения аргумента делает элемент формы
  /// доступным или недоступным.
  @override
  void onDisabledChanged(bool isDisabled) {
    _input.disabled = isDisabled;
  }
}
