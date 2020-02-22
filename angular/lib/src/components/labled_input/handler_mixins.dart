import 'package:angular/core.dart';
import 'package:angular_forms/angular_forms.dart';

/// Примесь [ChangeHandler]
///
/// Добавляет реализацию метода [registerOnChange]
/// интерфейса [ControlValueAccessor]
mixin ChangeHandler<T> {
  ChangeFunction<T> onChange = (T _, {String rawValue}) {};

  /// Регистрирует функцию, которая вызывается при изменениях значения
  /// элемента формы
  void registerOnChange(fn) {
    onChange = fn;
  }
}

/// Примесь [TouchHandler]
///
/// Добавляет реализацию метода [registerOnTouch] интерфейса
/// [ControlValueAccessor]
///
/// Дополнительно организует обработку события `onBlur` хост-компонента. Это
/// необходимо для понимания был ли элемент управления "touched" или нет.
mixin TouchHandler {
  TouchFunction _onTouched = () {};

  @HostListener('onBlur')
  void touchHandler() {
    _onTouched();
  }

  /// Регистрирует функцию, которая вызывается при выходе из элемента формы.
  ///
  /// Выход из элемента формы даже без изменений устанавливает автоматически
  /// признак `touched`
  void registerOnTouched(fn) {
    _onTouched = fn;
  }
}
