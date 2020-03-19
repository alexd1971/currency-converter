import 'package:angular/angular.dart';
import 'package:currency_converter_models/models.dart';
import 'package:angular_bloc/angular_bloc.dart';
import 'package:currency_converter_bloc/bloc.dart';

import '../../../components.dart';

/// Компонент управления валютами
///
/// Используется для создания, изменения и удаления валют
@Component(
  selector: 'currency-manager',
  templateUrl: 'currency_manager.html',
  styleUrls: ['currency_manager.css'],
  directives: [
    coreDirectives,
    CurrencyEditor, // в шаблоне используется редактор валюты
  ],
  // экспортируем режим работы редактора для использования в шаблоне
  exports: [Mode],
  // BlocPipe  используется для получения состояния BLoC в шаблоне
  pipes: [BlocPipe],
)
class CurrencyManager {
  /// Компонент бизнес-логики
  ///
  /// Инжектируется посредством конструктора с помощью механизма DI встроенного
  /// в AngularDart
  final CurrencyManagerBloc bloc;

  /// Создает экземпляр компонента и инжектирует BLoC
  CurrencyManager(this.bloc);

  /// Редактор для создания новой валюты
  ///
  /// Этот компонент нам нужен для того, чтобы делать сброс формы после создания
  /// новой валюты (см. [create])
  @ViewChild('newCurrency')
  CurrencyEditor newCurrencyEditor;

  /// Индекс редактируемой валюты в списке валют
  ///
  /// На основании этого индекса поля редактора валюты становятся редактируемыми.
  /// Для всех остальных валют устанавливается состояние read only
  int editingCurrencyIndex;

  /// Сохраняет измененную валюту
  void save(Currency currency) {
    // Генерируем событие обновления валюты в BLoC
    bloc.add(UpdateCurrencyEvent(currency));
    editingCurrencyIndex = null;
  }

  /// Удаляет валюту
  void delete(Currency currency) {
    // Генерируем событие удаления валюты в BLoC
    bloc.add(RemoveCurrencyEvent(currency));
    editingCurrencyIndex = null;
  }

  /// Создает новую валюту
  void create(Currency currency) {
    // Генерируем событие удаления валюты в BLoC
    bloc.add(AddCurrencyEvent(Currency.from(currency)));
    // Сбрасываем форму для создания следующей валюты
    newCurrencyEditor.reset();
  }

  /// Устанавливает редактируемую валюту
  ///
  /// После установки этого параметра поля формы соответствующей валюты
  /// становятся редактируемыми
  void edit(int i) {
    editingCurrencyIndex = i;
  }
}
