import 'package:currency_converter_models/models.dart';
import 'package:flutter/material.dart';

import 'currency_form.dart';

class CurrencyManager extends StatefulWidget {
  @override
  _CurrencyManagerState createState() => _CurrencyManagerState();
}

class _CurrencyManagerState extends State<CurrencyManager> {
  /// Список валют
  ///
  /// Формируется динамически
  List<Currency> currencies;

  @override
  void initState() {
    currencies = <Currency>[
      Currency(code: 'USD', name: 'Доллар США', rate: 1),
      Currency(code: 'RUR', name: 'Российский рубль', rate: 60),
    ];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(
        children: [
          Padding(
            padding: EdgeInsets.only(top: 8),
            child: ListView.separated(
              itemCount: currencies.length,
              itemBuilder: (context, i) {
                return Dismissible(
                  key: UniqueKey(),
                  background: Container(
                    color: Colors.red,
                  ),
                  onDismissed: (direction) {
                    setState(() {
                      currencies.removeAt(i);
                    });
                  },
                  child: CurrencyForm(
                    currency: currencies[i],
                  ),
                );
              },
              separatorBuilder: (context, _) => Divider(),
            ),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: Padding(
              padding: EdgeInsets.only(right: 20, bottom: 20),
              child: FloatingActionButton(
                child: Icon(Icons.add),
                onPressed: () {
                  setState(() {
                    currencies.add(Currency());
                  });
                },
              ),
            ),
          )
        ],
      ),
    );
  }
}
