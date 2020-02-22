import 'package:angular/angular.dart';
import 'package:angular_forms/angular_forms.dart';

import 'handler_mixins.dart';
import 'labeled_input.dart';

/// Директива, реализующая интерфейс [ControlValueAccessor] для компонента
/// [LabeledInput]
///
/// Данная директива реализует поведение по умолчанию. То есть просто позволяет
/// осуществить доступ к строковому значению элемента формы и выполнить
/// автоматическую валидацию, если указан валидатор.
///
/// При подключении директивы к компоненту через параметр аннотации `directives`
/// она автоматически привязывается ко всем элементам `labeled-input`, у которых
/// указан атрибут `ngControl` и нет атрибута `type` (см. параметр `selector`)
///
/// Эта директива назначается провайдером интерфейса [ControlValueAccessor] для
/// элемента формы, к которому она привязывается (см. параметр `providers`).
///
/// Директива реализует интерфейс [ControlValueAccessor<String>], что означает,
/// что значение элемента формы будет интерпретироваться, как строка. Для
/// реализации приведения значения элемента формы к числовому типу используется
/// [LabeledInputNumberValueAccessor]
///
/// Интерфейс [ControlValueAccessor] содержит 4 метода:
///
/// * `registerOnChange` - регистрирует функцию, которая должна быть вызвана при
/// изменении элемента формы
/// * `registerOnTouch` - регистрирует функцию, которая должна быть вызвана при
/// выходе из элемента формы
/// * `onDisabledChange` - изменяет доступность элемента формы
/// * `writeValue` - устанавливает значение элемента формы
///
/// Поскольку реализаций данного интерфейса может быть несколько (например, для
/// разных типов значений), а логика реализаций ряда методов одинакова (в
/// частности логика методов `registerOnChange` и `registerOnTouch`),то для
/// исключения дублирования эта логика вынесена в отдельные примеси:
/// [ChangeHandler<T>] и [TouchedHandler] и подмешивается к разным реализациям
/// интерфейса.
@Directive(
    selector: 'labeled-input[ngControl]:not(labeled-input[type][ngControl])',
    providers: [
      ExistingProvider.forToken(
          ngValueAccessor, LabeledInputDefaultValueAccessor)
    ])
class LabeledInputDefaultValueAccessor
    with ChangeHandler<String>, TouchHandler
    implements ControlValueAccessor<String> {
  final LabeledInput _input;

  /// Создает директиву
  ///
  /// При создании директивы автоматически средствами Angular DI инжектируется
  /// экземпляр компонента, к которому привязана директива
  LabeledInputDefaultValueAccessor(this._input);

  @HostListener('onInput')
  void changedHandler(_) {
    onChange(_input.value, rawValue: _input.value);
  }

  /// Устанавливает значение элемента формы
  @override
  void writeValue(String value) {
    _input.value = value;
  }

  /// В зависимости от значения аргумента делает элемент формы
  /// доступным или недоступным.
  @override
  void onDisabledChanged(bool isDisabled) {
    _input.disabled = isDisabled;
  }
}
