import 'dart:io';

import 'package:flutter/material.dart';

import '../config.dart';

class WidgetList {
  static DisplayCenter(BuildContext context, {required List<Widget> children}) {
    return Center(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
                color: MainTheme.secondary,
                width: (Display.isDesktop()) ? 
                MediaQuery.of(context).size.width * .6  : 
                MediaQuery.of(context).size.width,
                margin: EdgeInsets.symmetric(vertical: 25, horizontal: 20),
                padding: EdgeInsets.all(15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: children,
                )),
          ],
        ),
      ),
    );
  }

  static Input({TextEditingController? controller, String? Function(String?)? validator, String? hintText, TextInputType? keyboardType, bool? obscureText, TextInputAction? textInputAction, Function(String value)? onFieldSubmitted}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: TextFormField(
        obscureText: obscureText ?? false,
        textInputAction: textInputAction ?? TextInputAction.done,
        keyboardType: keyboardType,
        style: TextStyle(color: Colors.white),
        validator: validator,
        controller: controller,
        onFieldSubmitted: onFieldSubmitted,
        decoration: InputDecoration(
            hintText: hintText,
            hintStyle: TextStyle(color: Colors.white54),
            contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 8),
            border: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.transparent)),
            fillColor: MainTheme.light,
            filled: true),
      ),
    );
  }

  static Button({required String text, required VoidCallback onPressed}) {
    return ElevatedButton(
      onPressed: onPressed, 
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all<Color>(MainTheme.accent),
        padding: (Display.isDesktop()) ? MaterialStateProperty.all(EdgeInsets.all(20)) : MaterialStateProperty.all(EdgeInsets.all(12))
      ),
      child: Text(text, style: TextStyle(
        color: MainTheme.primary,
        fontSize: (Platform.isWindows) ? 18 : 16,
      )),
    );
  }
}
