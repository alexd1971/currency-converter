import 'dart:async';
import 'dart:html';
import 'dart:math';

import 'package:angular/angular.dart';
import 'package:angular_forms/angular_forms.dart';

/// Поле ввода
///
/// Является оберткой стандартного элемента `input`
///
/// В отличие от стандартного ввода в этот компонент интегрирована метка.
///
/// Для добавления в шаблон используется элемент `<labeled-input></labeled-input>`
///
/// Поддержиаемые атрибуты:
///
/// * [id]::[String] - идентификатор; по умолчанию генерируется автоматически
/// * [readOnly]::[bool] - только для чтения
/// * [disabled]::[bool] - недоступный
/// * [label]::[String] - метка поля ввода
///
/// Поддерживаемые события:
///
/// * [onInput] - генерируется при изменении в поле
/// * [onBlur] - генерируется при выходе из поля
/// * [onFocus] - генерируется при получении фокуса ввода
///
/// Если поле является эелементом формы и с ним связан валидатор/валидаторы,
/// то поле автоматически реагирует на изменение валидности поля
///
/// Компонент реализует интерфейс [AfterViewInit]. Это означает, что реализуется
/// метод [ngAfterViewInit], который срабатывает сразу после инициализации
/// представления компонента и используется для установки обработчиков событий
/// на внутреннем элементе `input`, что необходимо для работы компонента.
///
/// Для того, чтобы получить все прелести интеграции [LabeledInput] в форму
/// к нему необходимо привязать [ControlValueAccessor] - интерфейс, позволяющий:
///
/// * осуществлять доступ к значению поля, выполняя двунаправленную привязку
/// поля и модели данных; это означает, что при изменении значения в поле, оно
/// автоматически попадает в атрибут модели данных и, наоборот, при изменении
/// значения в модели, оно автоматически появляется в поле;
/// * автоматически приводить в соответствие типы данных поля и атрибута модели
/// данных;
/// * автоматически производить валидацию поля;
/// * автоматически делать форму не валидной, до тех пор, пока все поля формы
/// не будут валидными.
///
/// О том как красиво и элегантно привязать весь этот функционал к полю и еще
/// много интересного читайте в описании компонентов
/// [LabeledInputDefaultValueAccessor] и [LabeledInputNumberValueAccessor]
@Component(
  selector: 'labeled-input',
  templateUrl: 'labeled_input.html',
  styleUrls: ['labeled_input.css'],
  directives: [NgClass],
)
class LabeledInput implements AfterViewInit, OnDestroy {
  /// Инжектор
  ///
  /// Используется для инжектирования элeмента управления формы [NgControl], если
  /// компонент используется внутри формы
  ///
  /// Инжектировать [NgControl] с использованием стандартного способа Angular DI
  /// через конструктор невозможно, так как получается циклическая зависимость:
  /// для создания [LabledInput] требуется [NgControl] и, наоборот, для создания
  /// [NgControl] требуется [LabeldInput]
  ///
  /// Сам инжектор инжектируется с помощью стандартного механизма Angular DI
  final Injector _injector;

  /// Элемент управления формы
  ///
  /// Элемент упраления формы, связанный с полем ввода при использовании внутри
  /// формы. Отвечает за получения доступа к введенному значению и валидацию.
  NgControl control;

  /// Создает компонент и автоматически инжектирует инжектор.
  LabeledInput(this._injector);

  /// Идентификатор инпута
  ///
  /// По умолчанию генерируется автоматически
  @Input()
  String id = (Random().nextDouble() * 1000000).floor().toString();

  /// Признак только для чтения
  @Input()
  bool readOnly = false;

  /// Признак доступностии
  @Input()
  bool disabled = false;

  /// Метка
  @Input()
  String label = '';

  /// Признак валидности поля
  ///
  /// Если поле не используется внутри формы или для него не определены
  /// валидаторы, то значение всегда `true`
  bool get valid => (control?.valid ?? true) || (control?.pristine ?? true);

  /// Геттер определяет добавление класса невалидного поля
  ///
  /// Используется [NgClass].
  ///
  /// Более подробное объяснение, как работает [NgClass] см. компонент [Tab]
  Map<String, bool> get invalidCssClass =>
      {'labeled-input__input-invalid': !valid};

  /// Внутренний `input`-элемент
  ///
  /// Аннотация `@ViewChild('input')` позволяет получить доступ к эелменту
  /// автоматически. В данном случае `input` - это имя переменной шаблона,
  /// ссылающейся на компонент (см. шаблон: `#input`)
  @ViewChild('input')
  InputElement input;

  /// Значение, введенное в поле ввода
  String get value => input?.value;
  set value(String value) {
    input?.value = value;
  }

  /// Контроллер события `onInput`
  final _inputController = StreamController<String>.broadcast();

  /// Поток событий `onInput`
  @Output()
  Stream<String> get onInput => _inputController.stream;

  ///Контроллер события `onBlur`
  final _blurController = StreamController<Null>.broadcast();

  /// Поток событий `onBlur`
  @Output()
  Stream<Null> get onBlur => _blurController.stream;

  /// Контроллер события `onFocus`
  final _focusController = StreamController<Null>.broadcast();

  /// Поток событий `onFocus`
  @Output()
  Stream<Null> get onFocus => _focusController.stream;

  /// Запускается сразу после инициализации представления компонента
  ///
  /// Используется для своевременного выполнения действий:
  ///
  /// * инжектирования [NgControl]
  /// * установки обработчиков событий на внутренний `input`
  @override
  void ngAfterViewInit() {
    control = _injector.get(NgControl);

    input
      ..onInput.listen((_) {
        // при вводе в `input` генерируем событие onInput
        _inputController.add(value);
      })
      ..onBlur.listen((_) {
        // при выходе из `input` генерируем событие onBlur
        _blurController.add(null);
      })
      ..onFocus.listen((_) {
        // при входе в поле генерируем событие onFocus
        _focusController.add(null);
      });
  }

  /// Перед уничтожением компонента закрывает потоки событий [onBlur],
  /// [onInput] и [onFocus]
  @override
  void ngOnDestroy() {
    _blurController.close();
    _inputController.close();
    _focusController.close();
  }
}
