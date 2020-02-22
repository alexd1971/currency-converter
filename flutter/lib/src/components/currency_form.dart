import 'package:currency_converter_models/models.dart';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';

class CurrencyForm extends StatefulWidget {
  final Currency currency;

  CurrencyForm({this.currency});

  @override
  _CurrencyFormState createState() => _CurrencyFormState();
}

class _CurrencyFormState extends State<CurrencyForm> {
  final _formKey = GlobalKey<FormState>();
  final _codeFieldKey = GlobalKey<FormFieldState<String>>();
  final _nameFieldKey = GlobalKey<FormFieldState<String>>();
  final _rateFieldKey = GlobalKey<FormFieldState<String>>();

  bool _autovalidateCode = false;
  bool _autovalidateName = false;
  bool _autovalidateRate = false;

  Currency currency;
  String _errorMessage = '';
  FocusNode _codeFocusNode;
  FocusNode _nameFocusNode;
  FocusNode _rateFocusNode;

  @override
  void initState() {
    super.initState();
    currency = widget.currency ?? Currency();
    _codeFocusNode = FocusNode()
      ..addListener(() {
        if (!_codeFocusNode.hasFocus &&
            !_codeFieldKey.currentState.validate()) {
          _codeFocusNode.requestFocus();
          setState(() {
            _autovalidateCode = true;
          });
        }
      });
    _nameFocusNode = FocusNode()..addListener(() {});
    _rateFocusNode = FocusNode()..addListener(() {});
  }

  @override
  void dispose() {
    _codeFocusNode.dispose();
    _nameFocusNode.dispose();
    _rateFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_codeFocusNode.hasFocus) {
      _errorMessage = _codeFieldKey.currentState.errorText;
    }
    if (_nameFocusNode.hasFocus) {
      _errorMessage = _nameFieldKey.currentState.errorText;
    }
    if (_rateFocusNode.hasFocus) {
      _errorMessage = _rateFieldKey.currentState.errorText;
    }
    final required = RequiredValidator(errorText: 'Обязательно');
    final only3Chars =
        LengthRangeValidator(min: 3, max: 3, errorText: '3 буквы');
    final englishChars = PatternValidator(r'^[A-Za-z]*$', errorText: 'Англ.');
    final onlyNumber = PatternValidator(r'^[0-9.]*$', errorText: 'Число');

    return Form(
      key: _formKey,
      child: Column(
        children: [
          Row(
            children: <Widget>[
              _formField(
                key: _codeFieldKey,
                context: context,
                flex: 2,
                current: _codeFocusNode,
                next: _nameFocusNode,
                labelText: 'Код',
                initialValue: currency?.code,
                onChanged: (value) {
                  currency.code = value;
                },
                validator: MultiValidator([
                  required,
                  englishChars,
                  only3Chars,
                ]),
                textCapitalization: TextCapitalization.characters,
                autovalidate: _autovalidateCode,
              ),
              _formField(
                key: _nameFieldKey,
                context: context,
                flex: 8,
                current: _nameFocusNode,
                next: _rateFocusNode,
                labelText: 'Наименование',
                initialValue: currency?.name,
                onChanged: (value) {
                  currency.name = value;
                },
                validator: required,
                autovalidate: _autovalidateName,
              ),
              _formField(
                key: _rateFieldKey,
                context: context,
                flex: 3,
                current: _rateFocusNode,
                next: _codeFocusNode,
                labelText: 'Рэйтинг',
                initialValue: currency?.rate?.toString(),
                onChanged: (value) {
                  currency.rate = num.tryParse(value);
                },
                validator: MultiValidator([
                  required,
                  onlyNumber,
                ]),
                autovalidate: _autovalidateRate,
              ),
            ],
          ),
          Text(
            _errorMessage,
            style: TextStyle(
              fontSize: 12.0,
              color: Colors.red,
            ),
          ),
        ],
      ),
    );
  }

  Widget _formField({
    GlobalKey<FormFieldState<String>> key,
    int flex: 1,
    String labelText,
    String initialValue,
    void Function(String) onChanged,
    FocusNode current,
    FocusNode next,
    String Function(String) validator,
    @required BuildContext context,
    TextCapitalization textCapitalization: TextCapitalization.none,
    TextInputAction textInputAction: TextInputAction.next,
    bool autovalidate,
  }) {
    return Expanded(
      flex: flex,
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: 1,
        ),
        child: TextFormField(
          key: key,
          focusNode: current,
          decoration: InputDecoration(
            labelText: labelText,
            border: OutlineInputBorder(),
            errorStyle: TextStyle(
              height: 0,
              fontSize: 0,
            ),
          ),
          initialValue: initialValue,
          onChanged: (value) {
            setState(() {
              onChanged(value);
            });
          },
          textInputAction: textInputAction,
          onEditingComplete: () {
            next.requestFocus();
          },
          validator: validator,
          autovalidate: autovalidate,
          textCapitalization: textCapitalization,
        ),
      ),
    );
  }
}
