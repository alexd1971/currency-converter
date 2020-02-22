import 'package:equatable/equatable.dart';

/// Валюта
class Currency with EquatableMixin {
  /// Код валюты
  String code;

  /// Наименование валюты
  String name;

  /// Стоимость валюты относительно базовой
  num rate;

  /// Создает новый экземпляр валюты
  Currency({this.code, this.name, this.rate});

  @override
  String toString() => 'Currency: ${code ?? ''}, ${name ?? ''}, ${rate ?? ''}';

  @override
  List<Object> get props => [code];
}
