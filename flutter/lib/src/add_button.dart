import 'package:flutter/material.dart';

/// Кнопка добавления
///
/// Используется как в компоненте [CurrencyConverter], так и в компоненте
/// [CurrencyManager]
///
/// Выделена в отдельный виджет, чтобы не дублировать код
class AddButton extends StatelessWidget {
  /// Функция обработчик нажатия на кнопку
  final void Function() _onPressed;

  /// Создает [AddButton]
  ///
  /// В качестве аргумента принимает функцию-обработчик нажатия. Если обработчик
  /// не передан, то кнопка недоступна.
  AddButton({void Function() onPressed}) : _onPressed = onPressed;

  @override
  Widget build(BuildContext context) {
    return Align(
      // Позволяет управлять положением
      alignment: Alignment.bottomRight, // располагаем кнопку справа внизу
      child: Padding(
        padding: EdgeInsets.only(right: 20, bottom: 20), // отступы для красоты
        // Создаем саму кнопку
        child: FloatingActionButton(
          // если кнопок несколько, то каждая должна иметь уникальный heroTag
          heroTag: UniqueKey(),
          // Добавляем на нее иконку со знаком '+'
          child: Icon(Icons.add),
          // Устанавливаем обработчик нажатия
          onPressed: _onPressed,
        ),
      ),
    );
  }
}
