// ignore_for_file: prefer_final_fields, body_might_complete_normally_nullable, unnecessary_string_interpolations, unnecessary_brace_in_string_interps, deprecated_member_use, avoid_print

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:user/Api/ApiWrapper.dart';
import 'package:user/Api/Config.dart';
import 'package:user/login_signup/login.dart';
import 'package:user/login_signup/verification.dart';
import 'package:user/profile/loream.dart';
import 'package:user/utils/AppWidget.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Controller/AuthController.dart';
import '../home/home.dart';
import '../utils/botton.dart';
import '../utils/colornotifire.dart';
import '../utils/ctextfield.dart';
import '../utils/itextfield.dart';
import '../utils/media.dart';

class Signup extends StatefulWidget {
  const Signup({Key? key}) : super(key: key);

  @override
  _SignupState createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  bool status = false;
  final auth = FirebaseAuth.instance;
  late ColorNotifire notifire;
  final name = TextEditingController();
  final number = TextEditingController();
  final email = TextEditingController();
  final fpassword = TextEditingController();
  final spassword = TextEditingController();
  final referral = TextEditingController();
  bool isLoading = false;
  String? _selectedCountryCode = '';
  final login = Get.put(AuthController());

  getdarkmodepreviousstate() async {
    final prefs = await SharedPreferences.getInstance();
    bool? previusstate = prefs.getBool("setIsDark");
    if (previusstate == null) {
      notifire.setIsDark = false;
    } else {
      notifire.setIsDark = previusstate;
    }
  }

  bool _obscureText = true;
  bool obscureText_ = true;

  void _toggle() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  void toggle() {
    setState(() {
      obscureText_ = !obscureText_;
    });
  }

  @override
  void initState() {
    super.initState();
    _selectedCountryCode = login.countryCode.first;
    getdarkmodepreviousstate();
  }

  @override
  Widget build(BuildContext context) {
    notifire = Provider.of<ColorNotifire>(context, listen: true);
    return Scaffold(
      backgroundColor: notifire.backgrounde,
      body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              SizedBox(height: height / 20),
              Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Icon(Icons.arrow_back, color: notifire.getwhitecolor),
                  ),
                ],
              ),
              SizedBox(height: height / 40),
              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.only(
                        bottom: MediaQuery.of(context).viewInsets.bottom),
                    child: !isLoading
                        ? Column(
                            children: [
                              Row(
                                children: [
                                  Text("Sign up".tr, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, fontFamily: 'Gilroy Medium', color: notifire.getwhitecolor),),
                                ],
                              ),
                              SizedBox(height: height / 40),
                              Customtextfild.textField(controller: name, name1: "Name".tr, labelclr: Colors.grey, textcolor: notifire.getwhitecolor, prefixIcon: Image.asset("image/Profile.png", scale: 3.5,color: notifire.textcolor), context: context,),
                              SizedBox(height: height / 40),
                              Customtextfild.textField(controller: email, name1: "Email".tr, labelclr: Colors.grey, textcolor: notifire.getwhitecolor, prefixIcon: Image.asset("image/Message.png", scale: 3.5,color: notifire.textcolor), context: context,
                              ),
                              SizedBox(height: height / 40),
                              Ink(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      height: 45,
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(10),
                                          border: Border.all(
                                              width: 1,
                                              color: notifire.bordercolore)),
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
                                        name1: "Mobile number".tr,
                                        keyboardType: TextInputType.number,
                                        labelclr: Colors.grey,
                                        textcolor: notifire.getwhitecolor, context: context,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: height / 40),
                              Customtextfild2.textField(
                                fpassword,
                                _obscureText,
                                "Your password".tr,
                                Colors.grey,
                                notifire.getwhitecolor,
                                "image/Lock.png",
                                GestureDetector(
                                    onTap: () {
                                      _toggle();
                                    },
                                    child: _obscureText
                                        ? Image.asset("image/Hide.png",
                                            scale: 3.5,color: notifire.textcolor,)
                                        : Image.asset("image/Show.png",
                                            scale: 3.5,color: notifire.textcolor)), context: context,
                              ),
                              SizedBox(height: height / 40),
                              Customtextfild2.textField(
                                spassword,
                                obscureText_,
                                "Confirm password".tr,
                                Colors.grey,
                                notifire.getwhitecolor,
                                "image/Lock.png",
                                GestureDetector(
                                    onTap: () {
                                      toggle();
                                    },
                                    child: obscureText_
                                        ? Image.asset("image/Hide.png",
                                            height: 22,color: notifire.textcolor)
                                        : Image.asset("image/Show.png",
                                            height: 22,color: notifire.textcolor)), context: context,
                              ),
                              SizedBox(height: height / 40),
                              Customtextfild.textField(
                                controller: referral,
                                name1: "Referral code".tr,
                                labelclr: Colors.grey,
                                textcolor: notifire.getwhitecolor,
                                keyboardType: TextInputType.number,
                                prefixIcon: Image.asset("image/Discount-1.png", scale: 3.5,color: notifire.textcolor), context: context,
                              ),
                              SizedBox(height: Get.height * 0.02),
                              Row(
                                children: [
                                  Ink(
                                    width: Get.width * 0.12,
                                    child: Transform.scale(
                                      scale: 0.7,
                                      child: CupertinoSwitch(
                                        activeColor: notifire.getbuttonscolor,
                                        value: status,
                                        onChanged: (value) {
                                          setState(() {});
                                          status = value;
                                        },
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: Get.width * 0.015),
                                  Center(
                                    child: RichText(
                                      text: TextSpan(
                                          text: "By continuing, ".tr,
                                          style: TextStyle(
                                              color: notifire.getwhitecolor,
                                              fontSize: 12),
                                          children: <TextSpan>[
                                            TextSpan(text: "You agree to GoEvent's \n".tr),
                                            TextSpan(
                                                text: 'Terms of Use '.tr,
                                                style: const TextStyle(
                                                    decoration: TextDecoration
                                                        .underline,
                                                    decorationThickness: 2.5),
                                                recognizer:
                                                    TapGestureRecognizer()
                                                      ..onTap = () {
                                                        Get.to(() => Loream("Terms & Conditions".tr));
                                                      }),
                                            const TextSpan(text: "and "),
                                            TextSpan(
                                                text: 'Privacy Policy.'.tr,
                                                style: const TextStyle(
                                                    decoration: TextDecoration
                                                        .underline,
                                                    decorationThickness: 2.5),
                                                recognizer:
                                                    TapGestureRecognizer()
                                                      ..onTap = () {
                                                        Get.to(() => Loream("Terms & Conditions".tr));
                                                      }),
                                          ]),
                                    ),
                                  )
                                ],
                              ),
                              SizedBox(height: Get.height * 0.10),
                              GestureDetector(
                                onTap: () {

                                  authSignUp();
                                  // print('hahahaha');
                                },
                                child: SizedBox(
                                  height: 45,
                                  child: Custombutton.button1(
                                    notifire.getbuttonscolor,
                                    "SIGN UP".tr,
                                    SizedBox(width: width / 4),
                                    SizedBox(width: width / 5),
                                  ),
                                ),
                              ),
                              SizedBox(height: Get.height / 60),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "Already have an account? ".tr,
                                    style: TextStyle(
                                        color: notifire.getwhitecolor,
                                        fontSize: 14,
                                        fontFamily: 'Gilroy Medium'),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      Get.to(() => const Login(),
                                          duration: Duration.zero);
                                    },
                                    child: Text(
                                      "Sign in".tr,
                                      style: const TextStyle(
                                          color: Color(0xff5669FF),
                                          fontFamily: 'Gilroy Medium'),
                                    ),
                                  ),
                                ],
                              )
                            ],
                          )
                        : Column(
                            children: [
                              isLoadingCircular(),
                            ],
                          ),
                  ),
                ),
              )
            ],
          )),
    );
  }

  Widget log(clr, name, img, clr2) {
    return Center(
      child: GestureDetector(
        onTap: () {
          Get.to(() => const Home(), duration: Duration.zero);
        },
        child: Container(
          decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(10)),
              color: clr),
          height: height / 15,
          width: width / 1.5,
          child: Row(
            children: [
              SizedBox(width: width / 10),
              Padding(
                  padding: const EdgeInsets.symmetric(vertical: 9),
                  child: Image.asset(img)),
              SizedBox(width: width / 20),
              Text(
                name,
                style: TextStyle(
                    color: clr2,
                    fontFamily: 'Gilroy Medium',
                    fontSize: 15,
                    fontWeight: FontWeight.w400),
              ),
            ],
          ),
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
              items: login.countryCode.map((value) {
                return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value, style: const TextStyle(fontSize: 14.0, color: Colors.grey)));
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

  //
  authSignUp() {
    print('uhuhuhuhu');
    FocusScope.of(context).requestFocus(FocusNode());

    var mcheck = {"mobile": number.text};

    if (name.text.isNotEmpty &&
            email.text.isNotEmpty &&
            number.text.isNotEmpty &&
            fpassword.text.isNotEmpty &&
            spassword.text.isNotEmpty
        // &&        referral.text.isNotEmpty
        ) {
      if ((RegExp(
              r"^[a-zA-Z0-9.a-zA-Z0-9!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9.a-zA-Z0-9!#$%&'*+-/=?^_`{|}~]+\.[a-zA-Z]+")
          .hasMatch(email.text))) {
        if (fpassword.text == spassword.text) {
          if (status == true) {
            ApiWrapper.dataPost(Config.mobilecheck, mcheck).then((val) {
              if ((val != null) && (val.isNotEmpty)) {
                if (val["Result"] == "true") {
                  setState(() {
                    isLoading = true;
                  });
                  var register = {
                    "UserName": name.text.trim(),
                    "Usernumber": number.text.trim(),
                    "UserEmail": email.text.trim(),
                    "Ccode": _selectedCountryCode,
                    "FPassword": fpassword.text.trim(),
                    "SPassword": spassword.text.trim(),
                    "ReferralCode": referral.text.trim(),
                  };
                  save("User", register);

                  verifyPhone("${_selectedCountryCode}" "${number.text}");
                } else {
                  setState(() {
                    isLoading = false;
                  });
                  ApiWrapper.showToastMessage(val['ResponseMsg']);
                }
              }
            });
          } else {
            ApiWrapper.showToastMessage("Accept terms & Condition is required");
          }
        } else {
          ApiWrapper.showToastMessage("password not match");
        }
      } else {
        ApiWrapper.showToastMessage('Please enter valid email address');
      }
    } else {
      ApiWrapper.showToastMessage("Please fill required field!");
    }
  }

  Future<void> verifyPhone(String number) async {
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: number,
      timeout: const Duration(seconds: 30),
      verificationCompleted: (PhoneAuthCredential credential) {
        ApiWrapper.showToastMessage("Auth Completed!");
        setState(() {
          isLoading = false;
        });
      },
      verificationFailed: (FirebaseAuthException e) {
        ApiWrapper.showToastMessage("Auth Failed!");
        setState(() {
          isLoading = false;
        });
      },
      codeSent: (String verificationId, int? resendToken) {
        ApiWrapper.showToastMessage("OTP Sent!");
        setState(() {
          isLoading = false;
        });
        Get.to(() => Verification(verID: verificationId, number: number));
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        ApiWrapper.showToastMessage("Timeout!");
        setState(() {
          isLoading = false;
        });
      },
    );
  }
}



//15900 + 5700 = 21600


