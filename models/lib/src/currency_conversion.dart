import 'currency.dart';

class CurrencyConversion {
  Currency currency;
  num value;
  CurrencyConversion({this.currency, this.value});

  @override
  String toString() => 'Currency: $currency; Value: $value';
}
