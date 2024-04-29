import 'package:flutter/material.dart';

import 'color.dart';

class ColorNotifire with ChangeNotifier {
  bool isDark = false;
  set setIsDark(value) {
    isDark = value;
    notifyListeners();
  }

  get getIsDark => isDark;

  get getprimerycolor => isDark ? darkPrimeryColor : primeryColor;
  get getcardcolor => isDark ? darkcardColor : cardColor;
  get gettextcolor => isDark ? darktextColor : textColor;
  get getprocolor => isDark ? darkproColor : proColor;
  get gettext1color => isDark ? darktext1Color : text1Color;
  get getwhitecolor => isDark ? whiteColor : darkwhiteColor;
  get getbuttonscolor => isDark ? darkbuttonsColor : buttonsColor;
  get getbuttoncolor => isDark ? buttonboldColor : buttonColor;
  get gettopcolor => isDark ? darktopColor : topColor;
  get getdarkscolor => isDark ? blackColor : darkblackColor;
  get getbluecolor => isDark ? darkblueColor : blueColor;
  get getorangecolor => isDark ? darkorangeColor : orangeColor;
  get getpinkcolor => isDark ? darkpinkColor : pinkColor;
  get getblackcolor => isDark ? darkwhiteColor : whiteColor;
  get getsettingcolor => isDark ? darktopColor : whiteColor;
  get getticketcolor => isDark ? darktopColor1 : buttonColor;
  get getwhite => isDark ? whiteColor : whiteColor;



  get textcolor => isDark ? Colors.white : Colors.black;
  get backgrounde => isDark ? const Color(0xff161616) : Colors.white;
  get finalticketcolore => isDark ? const Color(0xff161616) : const Color(0xff5669FF);
  get containercolore => isDark ? const Color(0xff1C1C1C) :  Colors.white;
  get homecontainercolore => isDark ? const Color(0xff1C1C1C) :  const Color(0xff5669FF);
  get bottommenucolore => isDark ? Colors.white :  const Color(0xff6978A0).withOpacity(.80);

  get bordercolore => isDark ? const Color(0xff1E293B) :  Colors.grey.shade200;



}
