import 'package:angular/angular.dart';
import 'package:angular_forms/angular_forms.dart';

/// Валидатор числового поля формы
///
/// Автоматически применяется к элементам управления формы, у которых
/// есть атрибуты `type=number` и `ngControl`
///
/// Реализует интерфейс [Validator], который состоит из одного метода:
/// [validate]
@Directive(selector: '[type=number][ngControl]',
    // Делаем наш класс-директиву провайдером валидации
    providers: [ExistingProvider.forToken(NG_VALIDATORS, OnlyNumberValidator)])
class OnlyNumberValidator implements Validator {
  /// Переопределенная функция валидации
  ///
  /// [control] - элемент управления формы, для которого требуется валидация
  ///
  /// Если поле не валидно, то возвращает `Map<String, dynamic>`, где в качестве
  /// ключа используется идентификатор ошибки (должен быть условно-уникальным
  /// среди валидатором, используемых для поля), а значение - произвольное
  /// значение, в котором можно передавать дополнительные параметры, необходимые
  /// для обработчика ошибки.
  ///
  /// Если поле валидно, то ваозвращаем `null`
  @override
  Map<String, dynamic> validate(AbstractControl control) {
    final value = control.value is num || control.value == null
        ? control.value
        : num.tryParse(control.value);
    if (value == null) {
      return {'isNotNumber': true};
    }
    return null;
  }
}
