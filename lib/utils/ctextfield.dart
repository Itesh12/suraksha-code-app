import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'colornotifire.dart';


late ColorNotifire notifire;

class Customtextfild {
  static Widget textField({required context,TextEditingController? controller, String? name1, Color? labelclr, Color? textcolor, Color? imagecolor, String? Function(String?)? validator, Widget? prefixIcon, Function(String)? onChanged, TextInputType? keyboardType, TextInputAction? textInputAction,}) {
    notifire = Provider.of<ColorNotifire>(context, listen: true);
    return Container(
      color: Colors.transparent,
      height: 45,
      child: TextFormField(
        controller: controller,
        onChanged: onChanged,
        validator: validator,
        textInputAction: textInputAction,
        keyboardType: keyboardType,
        style: TextStyle(color: textcolor),
        decoration: InputDecoration(
          disabledBorder:
              OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          labelText: name1,
          labelStyle: TextStyle(color: labelclr),
          prefixIcon: prefixIcon,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: notifire.bordercolore, width: 1),
              borderRadius: BorderRadius.circular(10)),
          focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Color(0xff5669FF), width: 1),
              borderRadius: BorderRadius.circular(10)),
        ),
      ),
    );
  }
}
