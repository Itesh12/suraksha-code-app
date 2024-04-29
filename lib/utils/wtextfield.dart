import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'colornotifire.dart';

late ColorNotifire notifire;

class Customtextfild3 {
  static Widget textField(controller, textcolor, hinttext, wid, type, no, align, readOnly,{required context}) {
    notifire = Provider.of<ColorNotifire>(context, listen: true);
    return Container(
      color: Colors.transparent,
      height: 45,
      width: wid,
      child: TextField(
        controller: controller,
        keyboardType: type,
        readOnly: readOnly,
        inputFormatters: [LengthLimitingTextInputFormatter(no)],
        style: TextStyle(color: textcolor, fontSize: 13),
        textAlign: align,
        decoration: InputDecoration(
          labelText: hinttext,
          labelStyle: const TextStyle(color: Colors.grey),
          disabledBorder:
              OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          enabledBorder: OutlineInputBorder(
              borderSide:  BorderSide(color: notifire.bordercolore, width: 1),
              borderRadius: BorderRadius.circular(10)),
          focusedBorder: OutlineInputBorder(
              borderSide:  BorderSide(color: notifire.bordercolore, width: 1),
              borderRadius: BorderRadius.circular(10)),
        ),
      ),
    );
  }
}
