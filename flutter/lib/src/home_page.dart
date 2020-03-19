import 'package:flutter/material.dart';

import 'currency_converter.dart';
import 'currency_manager.dart';

/// Начальный экран приложения
///
/// Запускается при старте приложения.
///
/// Включает в себя заголовок приложения и два таба для переключения между
/// конвертером валют и управлением валютами.
class HomePage extends StatefulWidget {
  /// Создает состояние компонента
  ///
  /// Для всех stateful-виджетов наличие этого фабричного метода обязательно.
  @override
  State<StatefulWidget> createState() => _HomePageState();
}

/// Состояние компонента [HomePage]
///
/// Для правильной работы анимации переключения между табами к классу
/// подмешивается [SingleTickerProviderStateMixin]. Этот mixin часто
/// используется при создании анимаций. За саму анимацию переключения
/// между табами отвечает [TabController]
class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  TabController _tabController;

  /// Инициализирует состояние компонента
  ///
  /// Метод выполняется один раз перед первой отрисовкой компонента
  ///
  /// Требует вызова initState() суперкласса.
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  /// Выполняет необходимую очистку состояния перед удалением компонента.
  ///
  /// Метод вызывается непосредственно перед удалением компонента.
  ///
  /// Требует вызова метода dispose() суперкласса
  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  /// Строит (отрисовывает) компонент
  @override
  Widget build(BuildContext context) {
    // Scaffold позвляет создать сразу экран с необходимыми элементами
    // управления
    return Scaffold(
      // Заголовок приложения
      appBar: AppBar(
        title: Text('Конвертер валют'),
        // Cнизу под заголовком располагается TabBar с двумя табами
        bottom: TabBar(
          // Используем созданный ранее контроллер
          controller: _tabController,
          tabs: <Widget>[
            Tab(text: 'Конвертер'),
            Tab(text: 'Управление валютами'),
          ],
        ),
      ),
      // Основной экран содержит TabView, где отображаются компоненты,
      // соответствующие выбранному табу
      body: TabBarView(
        // Используем созданный ранее контроллер
        controller: _tabController,
        // Компоненты, которые будут отображаться в соответствии с
        // выбранным табом
        children: [
          CurrencyConverter(),
          CurrencyManager(),
        ],
      ),
    );
  }
}
