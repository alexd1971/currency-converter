import 'package:angular/angular.dart';
import 'package:angular_forms/angular_forms.dart';

/// Валидатор кода валюты
///
/// Проверяет, чтобы код валюты состоял из 3-х заглавных английских букв
///
/// Для добавления валидатора к элементу формы, необходимо:
///
/// 1. Добавить директиву [CurrencyCodeValidator] в список директив компонента.
/// 2. В шаблоне компонента добавить к элементу формы атрибут `currencyCode`
@Directive(selector: '[currencyCode]', providers: [
  ExistingProvider.forToken(NG_VALIDATORS, CurrencyCodeValidator)
])
class CurrencyCodeValidator implements Validator {
  static final codeRegexp = RegExp(r'^[A-Z]{3}$');
  @override
  Map<String, dynamic> validate(AbstractControl control) {
    String value = control.value ?? '';
    if (!codeRegexp.hasMatch(value)) {
      return {'currencyCodeInvalid': true};
    }
    return null;
  }
}
