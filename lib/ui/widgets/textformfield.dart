import 'package:flutter/material.dart';
import 'responsive_ui.dart';

class CustomTextField extends StatelessWidget {
  final String hint;
  final TextEditingController textEditingController;
  final TextInputType keyboardType;
  final bool obscureText;
  final IconData icon;
  double _width;
  double _pixelRatio;
  bool large;
  bool medium;
  bool obscure;
  final validator;
  final save;

  CustomTextField(
      {this.hint,
      this.textEditingController,
      this.keyboardType,
      this.icon,
      this.obscureText = false,
      this.save,
      this.obscure: false,
      this.validator});

  @override
  Widget build(BuildContext context) {
    _width = MediaQuery.of(context).size.width;
    _pixelRatio = MediaQuery.of(context).devicePixelRatio;
    large = ResponsiveWidget.isScreenLarge(_width, _pixelRatio);
    medium = ResponsiveWidget.isScreenMedium(_width, _pixelRatio);
    return Material(
      borderRadius: BorderRadius.circular(30.0),
      elevation: large ? 12 : (medium ? 10 : 8),
      child: TextFormField(
        controller: textEditingController,
        keyboardType: keyboardType,
        obscureText: obscure,
        validator: validator,
        onSaved: save,
        cursorColor: Colors.orange[200],
        decoration: InputDecoration(
          prefixIcon: Icon(icon, color: Colors.orange[200], size: 20),
          hintText: hint,
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30.0),
              borderSide: BorderSide.none),
        ),
      ),
    );
  }
}

class TextFormFieldCustom extends StatelessWidget {
  String text;
  bool obscure;
  int maxLength;
  bool autofocus;
  String value;
  final onsaved;
  final onchanged;
  final validator;
  TextFormFieldCustom(
      {@required this.text,
      @required this.obscure,
      @required this.maxLength,
      @required this.autofocus,
      this.onsaved,
      this.onchanged,
      this.value,
      this.validator});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 15),
      child: TextFormField(
        maxLength: maxLength,
        autofocus: autofocus,
        obscureText: obscure,
        onSaved: onsaved,
        initialValue: value,
        validator: validator,
        onChanged: onchanged,
        textDirection: TextDirection.rtl,
        decoration: InputDecoration(
          labelText: text,
          labelStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          border:
              UnderlineInputBorder(borderSide: BorderSide(color: Colors.teal)),
        ),
      ),
    );
  }
}
