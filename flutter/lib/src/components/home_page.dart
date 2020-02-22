import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'currency_converter.dart';
import 'currency_manager.dart';

enum Tabs { converter, currencies }

class HomePage extends StatefulWidget {
  final Tabs activeTab;
  final tabTitle = <Widget>[
    Text('Конвертер валют'),
    Text('Управление валютами'),
  ];
  HomePage(this.activeTab);

  @override
  State<StatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Tabs activeTab;

  @override
  void initState() {
    activeTab = widget.activeTab;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: widget.tabTitle[activeTab.index],
      ),
      body:
          activeTab == Tabs.converter ? CurrencyConverter() : CurrencyManager(),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: Icon(FontAwesomeIcons.dollarSign),
            title: Text('Конвертер'),
          ),
          BottomNavigationBarItem(
            icon: Icon(FontAwesomeIcons.list),
            title: Text('Валюты'),
          ),
        ],
        currentIndex: activeTab.index,
        onTap: (index) {
          setState(() {
            activeTab = Tabs.values[index];
          });
        },
      ),
    );
  }
}
