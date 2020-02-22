import 'package:flutter/material.dart';

class CurrencyFormField<T> extends FormField<T> {
  CurrencyFormField(
      {Key key,
      String labelText,
      T initialValue,
      FocusNode focusNode,
      TextInputType keyboardType,
      TextStyle style,
      bool autofocus: false,
      bool readOnly: false,
      bool autovalidate: false,
      int maxLength,
      ValueChanged<T> onChanged,
      GestureTapCallback onTap,
      VoidCallback onEditingComplete,
      ValueChanged<T> onFieldSubmitted,
      FormFieldSetter<T> onSaved,
      FormFieldValidator<T> validator,
      bool enabled: true})
      : assert(autovalidate != null),
        assert(autofocus != null),
        assert(readOnly != null),
        assert(maxLength == null, maxLength > 0),
        super(
            key: key,
            onSaved: onSaved,
            validator: validator,
            initialValue: initialValue,
            autovalidate: autovalidate,
            enabled: enabled,
            builder: (FormFieldState<T> field) {
              _CurrencyFormFieldState<T> state = field;
              return TextField();
            });

  @override
  _CurrencyFormFieldState<T> createState() => _CurrencyFormFieldState<T>();
}

class _CurrencyFormFieldState<T> extends FormFieldState<T> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
