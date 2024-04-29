// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'media.dart';

class Custombutton {
  // static Widget button(clr, text, siz, siz2) {
  //   return Center(
  //     child: Container(
  //       decoration: BoxDecoration(
  //           borderRadius: const BorderRadius.all(Radius.circular(14)),
  //           color: clr),
  //       height: height / 15,
  //       width: Get.width / 1.3,
  //       child: Row(
  //         children: [
  //           siz,
  //           Text(text,
  //               style: TextStyle(
  //                   color: Colors.white,
  //                   fontSize: 15,
  //                   fontWeight: FontWeight.w600)),
  //           siz2,
  //           Padding(
  //               padding: const EdgeInsets.symmetric(vertical: 9),
  //               child: Image.asset("image/arrow.png")),
  //         ],
  //       ),
  //     ),
  //   );
  // }

  static Widget button1(clr, text, siz, siz2) {
    return Center(
      child: Container(
        decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(14)),
            color: clr),
        height: height / 15,
        width: Get.width / 1.3,
        child: Row(
          children: [
            SizedBox(
              width: 10,
            ),
            Expanded(
              child: Text(text,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w600)),
            ),
            Padding(
                padding: const EdgeInsets.symmetric(vertical: 9),
                child: Image.asset("image/arrow.png")),
            SizedBox(
              width: 10,
            ),
          ],
        ),
      ),
    );
  }
}
