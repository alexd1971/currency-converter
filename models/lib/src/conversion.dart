import 'currency.dart';

/// Конверсия
///
/// Конверсия включает в себя валюту и соответствующую сумму. Конвертер валют
/// может содержать однвременно несколько конверсий. При изменении валюты или
/// суммы одной из них приводит к автоматическому пересчету значений остальных
/// в соответствии с логикой, реализованной в компоненте бизнес-логики.
class Conversion {
  /// Валюта
  Currency currency;

  /// Сумма
  num value;

  /// Создает конверсию
  Conversion({this.currency, this.value});

  /// Создает конверсию из JSON-представления.
  ///
  /// Зачем это  нужно см. пояснение в [Currency].fromJson
  factory Conversion.fromJson(Map<String, dynamic> json) {
    if (json == null) return null;
    return Conversion(
        currency: Currency.fromJson(json['currency']), value: json['value']);
  }

  /// Возвращает JSON-представление объекта
  ///
  /// Поясннения см в [Currency].toJson
  Map<String, dynamic> toJson() {
    return {'currency': currency, 'value': value};
  }

  @override
  String toString() => '(Currency: $currency; Value: $value)';
}
