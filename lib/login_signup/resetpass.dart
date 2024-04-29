// ignore_for_file: unnecessary_brace_in_string_interps, deprecated_member_use

import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:user/Api/ApiWrapper.dart';
import 'package:user/Api/Config.dart';
import 'package:user/Controller/AuthController.dart';
import 'package:user/login_signup/verification.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../utils/botton.dart';
import '../utils/colornotifire.dart';
import '../utils/ctextfield.dart';
import '../utils/media.dart';

class Resetpassword extends StatefulWidget {
  const Resetpassword({Key? key}) : super(key: key);

  @override
  _ResetpasswordState createState() => _ResetpasswordState();
}

class _ResetpasswordState extends State<Resetpassword> {
  late ColorNotifire notifire;
  final number = TextEditingController();
  final x = Get.put(AuthController());
  String? _selectedCountryCode = "";

  bool isLoading = false;

  getdarkmodepreviousstate() async {
    final prefs = await SharedPreferences.getInstance();
    bool? previusstate = prefs.getBool("setIsDark");
    if (previusstate == null) {
      notifire.setIsDark = false;
    } else {
      notifire.setIsDark = previusstate;
    }
  }

  @override
  void initState() {
    super.initState();
    _selectedCountryCode = x.countryCode.first;
    getdarkmodepreviousstate();
  }

  String? vID = "";

  verifyPhone(String mobilenumber) async {
    var mcheck = {"mobile": number.text};

    ApiWrapper.dataPost(Config.mobilecheck, mcheck).then((val) async {
      setState(() {});
      isLoading = true;
      if ((val != null) && (val.isNotEmpty)) {
        if (val["Result"] != "true") {
          log(val.toString(), name: "Mobile Chake ");
          await FirebaseAuth.instance.verifyPhoneNumber(
            phoneNumber: mobilenumber,
            timeout: const Duration(seconds: 30),
            verificationCompleted: (PhoneAuthCredential credential) {
              ApiWrapper.showToastMessage("Auth Completed!");
            },
            verificationFailed: (FirebaseAuthException e) {
              ApiWrapper.showToastMessage("Auth Failed!");
            },
            codeSent: (String verificationId, int? resendToken) {
              ApiWrapper.showToastMessage("OTP Sent!");
              setState(() {});

              isLoading = false;
              Get.to(() => Verification(
                  verID: verificationId, number: number.text, type: "Reset"));
            },
            codeAutoRetrievalTimeout: (String verificationId) {
              ApiWrapper.showToastMessage("Timeout!");
            },
          );
        } else {
          setState(() {});
          isLoading = false;
          ApiWrapper.showToastMessage(
              "Unable to process request. Please retry.");
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    notifire = Provider.of<ColorNotifire>(context, listen: true);
    return Scaffold(
      backgroundColor: notifire.backgrounde,
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: height / 20),
            Row(
              children: [
                SizedBox(width: width / 20),
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Icon(Icons.arrow_back,
                      color: notifire.getwhitecolor),
                ),
              ],
            ),
            SizedBox(height: height / 100),
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: Text(
                    "Resset Password".tr,
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Gilroy Medium',
                        color: notifire.getwhitecolor),
                  ),
                ),
              ],
            ),
            SizedBox(height: height / 100),
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Please enter your email address to".tr,
                        style: TextStyle(
                            fontSize: 14,
                            fontFamily: 'Gilroy Medium',
                            color: notifire.getwhitecolor),
                      ),
                      SizedBox(height: height / 400),
                      Text(
                        "request a password reset".tr,
                        style: TextStyle(
                            fontSize: 14,
                            fontFamily: 'Gilroy Medium',
                            color: notifire.getwhitecolor),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: height / 30),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Ink(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      height: 45,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                              width: 1, color: notifire.bordercolore)),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const SizedBox(width: 12),
                          Image.asset("image/Call1.png", scale: 3.5,color: notifire.textcolor),
                          cpicker(),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8,),
                    Expanded(
                      child: Customtextfild.textField(
                        controller: number,
                        name1: "Enter Number".tr,
                        labelclr: Colors.grey,
                        keyboardType: const TextInputType.numberWithOptions(),
                        textcolor: notifire.getwhitecolor, context: context,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: height / 20),
            !isLoading
                ? GestureDetector(
                    onTap: () {
                      if (number.text.isNotEmpty) {
                        verifyPhone("${_selectedCountryCode}" "${number.text}");
                      } else {
                        ApiWrapper.showToastMessage(
                            "Please fill required field!");
                      }
                    },
                    child: SizedBox(
                      height: 45,
                      child: Custombutton.button1(
                        notifire.getbuttonscolor,
                        "SEND".tr,
                        SizedBox(width: width / 3.5),
                        SizedBox(width: width / 7),
                      ),
                    ),
                  )
                : CircularProgressIndicator(color: notifire.getbuttonscolor),
          ],
        ),
      ),
    );
  }

  cpicker() {
    var countryDropDown = Ink(
      child: DropdownButtonHideUnderline(
        child: ButtonTheme(
          alignedDropdown: true,
          child: DropdownButton(
              value: _selectedCountryCode,
              items: x.countryCode.map((value) {
                return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value,
                        style: const TextStyle(
                            fontSize: 14.0, color: Colors.grey)));
              }).toList(),
              onChanged: (String? value) {
                setState(() {
                  _selectedCountryCode = value;
                });
              },
              style: Theme.of(context).textTheme.headline6),
        ),
      ),
    );
    return countryDropDown;
  }
}
