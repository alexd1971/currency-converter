import 'package:angular/angular.dart';
import 'package:currency_converter_models/models.dart';

import '../../../components.dart';

/// Компонент управления валютами
@Component(
    selector: 'currency-manager',
    templateUrl: 'currency_manager.html',
    styleUrls: [
      'currency_manager.css'
    ],
    directives: [
      coreDirectives,
      CurrencyForm,
    ])
class CurrencyManager {
  /// Список валют
  ///
  /// Формируется динамически
  final currencies = <Currency>[
    Currency(code: 'USD', name: 'Доллар США', rate: 1),
    Currency(code: 'RUR', name: 'Российский рубль', rate: 60),
  ];

  @ViewChild('newCurrencyForm')
  CurrencyForm newCurrencyForm;

  int editingCurrencyIndex;

  void save(int i) {
    print('Save: ${currencies[i]}');
    editingCurrencyIndex = null;
  }

  void delete(int i) {
    currencies.removeAt(i);
    editingCurrencyIndex = null;
  }

  void create() {
    currencies.insert(0, newCurrencyForm.currency);
    newCurrencyForm.currency = Currency();
    newCurrencyForm.form.reset();
  }

  void edit(int i) {
    editingCurrencyIndex = i;
  }
}
