// ignore_for_file: avoid_print, prefer_const_constructors, unnecessary_brace_in_string_interps, non_constant_identifier_names

import 'dart:developer';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import '../payment/flutterwave.dart';
import '../payment/mercadopogo.dart';
import '../utils/botton.dart';
import '../utils/colornotifire.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:user/home/home.dart';
import 'package:user/Api/Config.dart';
import 'package:user/utils/color.dart';
import 'package:user/utils/media.dart';
import 'package:provider/provider.dart';
import 'package:user/Api/ApiWrapper.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:user/Controller/DarkMode.dart';
import 'package:user/home/CouponList.dart';
import 'package:user/payment/InputFormater.dart';
import 'package:user/payment/PayPal.dart';
import 'package:user/payment/Payment_card.dart';
import 'package:user/payment/StripeWeb.dart';
import 'package:user/payment/finalticket.dart';
import 'package:user/spleshscreen.dart';
import 'package:user/utils/AppWidget.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:user/Controller/AppController.dart';
import 'package:user/AppModel/Homedata/HomedataController.dart';

// Done
class Ticket extends StatefulWidget {
  final String? eid;
  const Ticket({Key? key, this.eid}) : super(key: key);

  @override
  _TicketState createState() => _TicketState();
}

class _TicketState extends State<Ticket> {
  late Razorpay _razorpay;
  final hData = Get.put(HomeController());
  final dMode = Get.put(DarkMode());

  final voucher = TextEditingController();
  final pData = Get.put(HomeDataContro());
  bool isLoading = false;

  bool selected = false;
  int _counter = 1;
  int _select = 0;
  bool isChecked = false;
  //! payment var
  String? selectidpay = "3";
  int _groupValue = 0;
  String? paymenttital;
  Map ticketlist = {};
  String ticketprice = "0";
  int ticketlimit = 0;
  String ticketType = "";
  bool voucherApply = false;
  String subtotal = "0.0";
  String couponamount = "0";
  String ticketTotal = "0.0";
  String c_id = "";
  String c_amount = "";
  String couponcode = "";
  String ticketax = "0";
  String eventTax = "0";
  String coupontitle = "";
  String couponprice = "0";
  String typeid = "";
  String razorpaykey = "";
  bool status = false;
  String? walletAmount = "";
  String? walletbalence = "0";
  var tempWallet = 0.0;
  var useWallet = 0.0;

  @override
  void initState() {
    super.initState();
    getData.read("UserLogin") != null
        ? hData.homeDataApi(getData.read("UserLogin")["id"], lat, long)
        : null;
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
    getTicketListApi();
    dMode.getdarkmodepreviousstate();
    pData.paymentgateway();
    walletAmount = wallet;
    tempWallet = double.parse(wallet.toString());
  }

  getTicketListApi() {
    var data = {"eid": widget.eid, "uid": uID};
    print("Api Call type price: :$data");
    ApiWrapper.dataPost(Config.typePrice, data).then((val) {
      isloading = true;
      setState(() {});
      if ((val != null) && (val.isNotEmpty)) {
        if ((val['ResponseCode'] == "200") && (val['Result'] == "true")) {
          val["EventData"].forEach((e) {
            ticketlist = e;
            eventTax = e["event_tax"];
            for (var i = 0; i <= 0; i++) {
              typeid = e["ticketlist"][i]["typeid"];
              ticketType = e["ticketlist"][i]["ticket_type"];
              ticketlimit = e["ticketlist"][i]["ticket_limit"];
              ticketprice = e["ticketlist"][i]["ticket_price"];
              subtotal = e["ticketlist"][i]["ticket_price"];
              ticketTotal = e["ticketlist"][i]["ticket_price"];
            }
          });
          ticketpriceCount(_counter);
          setState(() {});
          isLoading = false;
        } else {
          isloading = false;
          setState(() {});
          ApiWrapper.showToastMessage(val["ResponseMsg"]);
        }
      }
    });
  }
  late ColorNotifire notifire;
  void _handlePaymentError(PaymentFailureResponse response) {
    print('Error Response: ${"ERROR: " + response.code.toString() + " - " + response.message!}');
    ApiWrapper.showToastMessage(response.message!);
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    ApiWrapper.showToastMessage(response.walletName!);
  }

  @override
  Widget build(BuildContext context) {
    notifire = Provider.of<ColorNotifire>(context, listen: true);
    Future.delayed(const Duration(seconds: 0), () {
      setState(() {});
    });
    dMode.notifire = Provider.of<ColorNotifire>(context, listen: true);
    return Scaffold(
      // extendBodyBehindAppBar: true,
      backgroundColor: notifire.backgrounde,
      //! Continue Button
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        iconTheme: IconThemeData(
            color: notifire.textcolor,
        ),
        title: Text("Ticket".tr, style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900, fontFamily: 'Gilroy Medium', color: notifire.textcolor),),
      ),
      floatingActionButton: SizedBox(
        height: 45,
        width: 410,
        child: FloatingActionButton(
          onPressed: () {
            continuebottomSheet();
            // buyNoworder('otid');
          },
          child: Custombutton.button1(
              dMode.notifire.getbuttonscolor,
              "CONTINUE".tr,
              SizedBox(width: width / 5),
              SizedBox(width: width / 8)),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: Column(
        children: [
          // SizedBox(height: height / 20),
          //! ------- AppBar -------!//
          // Row(
          //   children: [
          //     SizedBox(width: width / 20),
          //     GestureDetector(
          //         onTap: () {
          //           Get.back();
          //         },
          //         child: Icon(Icons.arrow_back,
          //             color: dMode.notifire.getdarkscolor)),
          //     SizedBox(width: width / 80),
          //     Text("Ticket".tr, style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900, fontFamily: 'Gilroy Medium', color: dMode.notifire.getdarkscolor),
          //     ),
          //   ],
          // ),
          Expanded(
            child: SingleChildScrollView(
              child: isloading
                  ? Column(
                      children: [
                        SizedBox(height: 10),
                        //! -------- ticketlist -------
                        Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 20),
                              child: Text("Ticket Type".tr, style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, fontFamily: 'Gilroy Bold', color: notifire.textcolor),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: Get.height * 0.08,
                          child: ListView.builder(
                            itemCount: ticketlist.isEmpty
                                ? 0
                                : ticketlist["ticketlist"].length,
                            shrinkWrap: true,
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (ctx, i) {
                              return tic(ticketlist["ticketlist"], i);
                            },
                          ),
                        ),

                        SizedBox(height: 20),

                        //! ------ seat count button --------
                        Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 20),
                              child: Text("Seat".tr,
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontFamily: 'Gilroy Bold',
                                      color: notifire.textcolor)),
                            ),
                          ],
                        ),
                        SizedBox(height: 10),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Container(
                            height: height / 12,
                            width: width,
                            decoration: BoxDecoration(
                                borderRadius: const BorderRadius.all(Radius.circular(10)),
                                border: Border.all(color: notifire.bordercolore, width: 1)),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    setState(() {});
                                    if (_counter > 1) {
                                      _counter--;
                                      ticketpriceCount(_counter);
                                      walletCalculation(status);
                                    }
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(5),
                                    child: Container(
                                        width: width / 7,
                                        height: height,
                                        decoration: BoxDecoration(
                                            color: dMode.notifire.getpinkcolor,
                                            borderRadius:
                                                const BorderRadius.all(
                                                    Radius.circular(10))),
                                        child: const Center(
                                            child: Icon(Icons.remove,
                                                color: Color(0xff5669ff)))),
                                  ),
                                ),
                                Text(_counter > 9 ? '$_counter' : '0$_counter',style: TextStyle(fontSize: 15, fontFamily: 'Gilroy Normal', color: notifire.textcolor, fontWeight: FontWeight.w600)),
                                GestureDetector(
                                  onTap: () {
                                    setState(() {});
                                    print("ticketlimit:----+++${{ticketlimit}}");
                                    if(_counter < int.parse(ticketlimit.toString())) {
                                      _counter++;
                                      ticketpriceCount(_counter);
                                      walletCalculation(status);
                                    }
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(5),
                                    child: Container(
                                      width: width / 7,
                                      height: height,
                                      decoration: BoxDecoration(
                                          color: dMode.notifire.getpinkcolor,
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(10))),
                                      child: const Center(
                                          child: Icon(Icons.add,
                                              color: Color(0xff5669ff))),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),


                        SizedBox(height: 30),

                        //! ----- Voucher Code -----
                        Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 20),
                              child: Text("Coupons".tr,
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontFamily: 'Gilroy Bold',
                                      color: notifire.textcolor)),
                            ),
                          ],
                        ),
                        SizedBox(height: 10),
                        InkWell(
                          onTap: () {
                            setState(() {});
                            voucherApply = !voucherApply;

                            couponcode == ""
                                ? Get.to(() => CouponListPage(bill: subtotal))!
                                    .then((value) {
                                    if (value != null) {
                                      status = false;
                                      walletCalculation(false);
                                      walletCalculation(_counter);
                                      c_id = value["id"];

                                      c_amount = value["c_value"];
                                      couponamount = value["c_value"];
                                      couponcode = value["coupon_code"];
                                      voucher.text = value["coupon_code"];
                                      coupontitle = value["coupon_title"];

                                      ticketTotal = (double.parse(
                                                  ticketTotal.toString()) -
                                              double.parse(value["c_value"].toString())).toStringAsFixed(2);
                                    }
                                  })
                                : null;
                          },
                          child: Container(
                            height: Get.height * 0.08,
                            width: Get.width * 0.90,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                    color: notifire.bordercolore, width: 1)),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(4),
                                  child: Image.asset("image/couponimg.png",
                                      scale: 3.5),
                                ),
                                Flexible(
                                  flex: 4,
                                  child: couponcode != ""
                                      ? Text(
                                          "Coupon applied !".tr,
                                          style: TextStyle(
                                              color: Colors.green.shade400,
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600),
                                        )
                                      : Text(
                                          "Apply Coupon".tr,
                                          style: TextStyle(
                                              color: Colors.grey,
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600),
                                        ),
                                ),
                                Container(),
                                Container(),
                                Container(),
                                Padding(
                                  padding: const EdgeInsets.all(1.0),
                                  child: Padding(
                                    padding: const EdgeInsets.only(right: 8),
                                    child: Center(
                                        child: Icon(
                                            Icons.arrow_forward_ios_rounded,
                                            size: 32,
                                            color: Colors.grey)),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),


                        //! ----- Applied Voucher -------
                        SizedBox(height: 30),

                        couponcode != ""
                            ? Container(
                                height: Get.height * 0.11,
                                width: Get.width * 0.90,
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Colors.grey.shade200, width: 1),
                                    borderRadius: BorderRadius.circular(10)),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 10, top: 10),
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text("Applied Voucher Code".tr.toUpperCase(),
                                              style: TextStyle(fontSize: 13, fontFamily: 'Gilroy Medium', color: dMode.notifire.gettext1color)),
                                          Text(couponcode,
                                              style: TextStyle(
                                                  fontSize: 15,
                                                  fontFamily: 'Gilroy Bold',
                                                  color: dMode
                                                      .notifire.gettext1color)),
                                          Ink(
                                            width: Get.width * 0.76,
                                            child: Text(coupontitle,
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                    fontSize: 13,
                                                    fontFamily: 'Gilroy Medium',
                                                    color: dMode.notifire.gettext1color)),
                                          ),
                                        ],
                                      ),
                                    ),
                                    InkWell(
                                      onTap: () {
                                        setState(() {
                                          status = false;
                                          walletCalculation(false);
                                          // walletCalculation(_counter);
                                          couponcode = "";
                                          voucher.clear();
                                          ticketTotal = (double.parse(
                                                      ticketTotal.toString()) +
                                                  double.parse(
                                                      c_amount.toString()))
                                              .toStringAsFixed(2);
                                          couponamount = "0";
                                          setState(() {});

                                          //
                                        });
                                      },
                                      child: const Padding(
                                        padding: EdgeInsets.all(6),
                                        child: Icon(Icons.close,size: 20, color: Colors.grey),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            : SizedBox(),
                        //!------ Wallet get data --------

                        walletAmount != "0"
                            ? Container(
                                margin: EdgeInsets.symmetric(horizontal: 16),
                                padding: EdgeInsets.symmetric(
                                    horizontal: 14, vertical: 10),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                    border: Border.all(
                                        color: notifire.bordercolore)),
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        Text("Pay from wallet".tr, style: TextStyle(fontSize: 15, fontFamily: 'Gilroy Bold', color: notifire.textcolor)),
                                      ],
                                    ),
                                    SizedBox(height: Get.height * 0.01),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Column(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text("GoEvent Balance".tr, style: TextStyle(fontSize: 15, fontFamily: 'Gilroy Bold', color: notifire.textcolor)),
                                            Row(
                                              children: [
                                                Text("Available for Payment ".tr, style: TextStyle(fontSize: 15, fontFamily: 'Gilroy Medium', color: Colors.grey)),
                                                Text("${mainData["currency"]}${tempWallet}", style: TextStyle(fontSize: 15, fontFamily: 'Gilroy Medium',color: notifire.textcolor)),
                                              ],
                                            ),
                                          ],
                                        ),
                                        Transform.scale(
                                          scale: 0.7,
                                          child: CupertinoSwitch(
                                            activeColor: dMode.notifire.getbuttonscolor,
                                            value: status,
                                            onChanged: (value) {
                                              setState(() {});
                                              status = value;
                                              walletCalculation(value);
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              )
                            : SizedBox(),

                        //! ----- Coupon Code sub total -------
                        SizedBox(height: 30),
                        priceRow(title: "Sub Total:".tr, subtitle: "${mainData["currency"]}${subtotal}", textcolor: dMode.notifire.gettext1color, fontSize: 17,),
                        SizedBox(height: Get.height * 0.006),
                        status ? priceRow(title: "Wallet:".tr, subtitle: "${mainData["currency"]}${useWallet}", textcolor: Colors.green, fontSize: 17,) : SizedBox(),
                        walletAmount == "0" ? SizedBox(height: Get.height * 0.006) : SizedBox(),
                        couponcode != "" ? priceRow(title: "Coupon Code:".tr, subtitle: "${mainData["currency"]}${couponamount} ", textcolor: darktextColor, fontSize: 17,) : SizedBox(),
                        couponcode != "" ? SizedBox(height: Get.height * 0.006) : SizedBox(),
                        priceRow(title: "Tax:".tr, subtitle: "${mainData["currency"]}${ticketax}", textcolor: dMode.notifire.gettext1color, fontSize: 17,),
                        SizedBox(height: Get.height * 0.006),
                        priceRow(title: "Total:".tr, subtitle: "${mainData["currency"]}${ticketTotal}", textcolor: dMode.notifire.gettext1color, fontSize: 17,),
                        SizedBox(height: Get.height * 0.12),
                      ],
                    )
                  : isLoadingCircular(),
            ),
          )
        ],
      ),
    );
  }

  walletCalculation(value) {
    if (value == true) {
      if (double.parse(wallet.toString()) <
          double.parse(ticketTotal.toString())) {
        tempWallet = double.parse(ticketTotal.toString()) -
            double.parse(wallet.toString());

        useWallet = double.parse(wallet.toString());

        ticketTotal = (double.parse(ticketTotal.toString()) -
                double.parse(wallet.toString()))
            .toString();
        tempWallet = 0;
        setState(() {});
        print("wallet--------- tempwallet :======== 1");

        print(tempWallet);
      } else {
        tempWallet = double.parse(wallet.toString()) -
            double.parse(ticketTotal.toString());

        useWallet = double.parse(wallet.toString()) - tempWallet;
        ticketTotal = "0";
        print("wallet--------- tempwallet :======== 2");

        print(tempWallet);
      }
    } else {
      ticketpriceCount(_counter);
      tempWallet = double.parse(wallet.toString());
      useWallet = 0;
      setState(() {});
    }
  }

  ticketpriceCount(totalticket) {
    setState(() {});

    subtotal = doublevaluemulti(totalticket, ticketprice);
    print("Subtotal : $subtotal");

    if (couponamount != "0") {
      couponprice = valueCal(subtotal, couponamount);
      print(couponprice + " coponprice ------ : ");
    } else {
      couponprice = subtotal;

      print(couponprice + " coponprice ------ else: ");
    }
    ticketax = doublevaluPer(subtotal, eventTax);
    print(ticketax + "event tax : ");
    var newprice = couponprice != "0" ? couponprice : subtotal;
    print(newprice + " newprice : ");

    ticketTotal = valuePlus(newprice, ticketax);
    print(ticketTotal + "event plus : ");
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    print('Success Response: $response');
    buyNoworder(response.paymentId);
    ApiWrapper.showToastMessage("Payment Successfully");
  }

  priceRow({String? title, subtitle, Color? textcolor, double? fontSize}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title!,
              style: TextStyle(
                  color: textcolor,
                  fontFamily: 'Gilroy Medium',
                  fontSize: fontSize)),
          Text(subtitle!,
              style: TextStyle(
                  color: textcolor,
                  fontFamily: 'Gilroy Medium',
                  fontSize: fontSize))
        ],
      ),
    );
  }

  Widget tic(ticket, i) {
    return InkWell(
      onTap: () {
        pData.paymentgateway();
        setState(() {});
        status = false;

        _select = i;
        typeid = ticket[i]["typeid"];
        ticketType = ticket[i]["ticket_type"];
        ticketlimit = ticket[i]["ticket_limit"];
        ticketprice = ticket[i]["ticket_price"];
        ticketpriceCount(_counter);
        walletCalculation(_counter);
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          decoration: BoxDecoration(
              color: _select == i ? dMode.notifire.getbuttonscolor : Colors.white,
              borderRadius: const BorderRadius.all(Radius.circular(10)),
              border: Border.all(width: 1, color: notifire.bordercolore)),
          height: height / 14,
          width: width / 2.5,
          child: Center(
            child: Text(ticketlist["ticketlist"][i]["ticket_type"],
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  fontFamily: 'Gilroy Medium',
                  color: _select == i ? Colors.white : text1Color,
                )),
          ),
        ),
      ),
    );
  }

  continuebottomSheet() {
    return showModalBottomSheet<dynamic>(
      backgroundColor: notifire.backgrounde,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(25.0), topRight: Radius.circular(25.0))),
      context: context,
      builder: (BuildContext bc) {
        return StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
          return SizedBox(
            height: Get.height * 0.92,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(height: height / 50),
                Container(
                    decoration: const BoxDecoration(
                        color: Colors.grey,
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    height: MediaQuery.of(context).size.height / 80,
                    width: MediaQuery.of(context).size.width / 7),
                SizedBox(height: height / 70),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: Html(
                            data: ticketlist["event_disclaimer"],
                            style: {
                              "body": Style(
                                  maxLines: 5,
                                  textOverflow: TextOverflow.ellipsis,
                                  color: Colors.grey,
                                  fontSize: FontSize(14)),
                            },
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                SizedBox(height: height / 60),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Row(
                    children: <Widget>[
                      Checkbox(
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        checkColor: Colors.white,
                        fillColor: MaterialStateProperty.resolveWith(
                            (states) => dMode.notifire.getbuttonscolor),
                        value: isChecked,
                        onChanged: (bool? value) {
                          setState(() {
                            isChecked = value!;
                          });
                        },
                      ),
                      Text(
                        "I Confirm that I am healty".tr,
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            fontFamily: 'Gilroy Normal',
                            color: notifire.textcolor),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: height / 200),
                GestureDetector(
                  onTap: () {
                    //! Open Payment Sheet
                    if (isChecked == true) {
                      if (status == true) {
                        if (double.parse(ticketTotal.toString()) > 0) {
                          Get.back();
                          paymentSheet();
                        } else {
                          //! book ticket
                          buyNoworder(0);
                        }
                      } else {
                        if (double.parse(ticketTotal.toString()) != 0.00) {
                          Get.back();
                          paymentSheet();
                        } else {
                          buyNoworder(0);
                        }
                      }
                    } else {
                      ApiWrapper.showToastMessage(
                          "Accept terms & Condition is required");
                    }
                  },
                  child: SizedBox(
                    height: 45,
                    width: width / 1.5,
                    child: Custombutton.button1(
                      dMode.notifire.getbuttonscolor,
                      "CONTINUE".tr,
                      SizedBox(width: width / 5),
                      SizedBox(width: width / 8),
                    ),
                  ),
                ),

                // GestureDetector(
                //   onTap: () {
                //     //! Open Payment Sheet
                //     if (isChecked == true) {
                //       if (status == true) {
                //         if (double.parse(ticketTotal.toString()) > 0) {
                //           Get.back();
                //           paymentSheet();
                //         } else {
                //           //! book ticket
                //           buyNoworder(0);
                //         }
                //       } else {
                //         if (double.parse(ticketTotal.toString()) != 0.00) {
                //           Get.back();
                //           paymentSheet();
                //         } else {
                //           buyNoworder(0);
                //         }
                //       }
                //     } else {
                //       ApiWrapper.showToastMessage(
                //           "Accept terms & Condition is required");
                //     }
                //   },
                //   child: Center(
                //     child: Container(
                //       decoration: BoxDecoration(
                //           borderRadius:
                //               const BorderRadius.all(Radius.circular(10)),
                //           color: dMode.notifire.getbuttonscolor),
                //       height: height / 15,
                //       width: width / 1.5,
                //       child: Row(
                //         children: [
                //           SizedBox(width: width / 5),
                //           Text("CONTINUE".tr,
                //               style: TextStyle(
                //                   fontFamily: 'Gilroy Medium',
                //                   color: Colors.white,
                //                   fontSize: 15,
                //                   fontWeight: FontWeight.w600)),
                //           SizedBox(width: width / 7),
                //           Padding(
                //             padding: const EdgeInsets.symmetric(vertical: 9),
                //             child: Image.asset("image/arrow.png"),
                //           ),
                //         ],
                //       ),
                //     ),
                //   ),
                // ),

                SizedBox(height: height / 200),
              ],
            ),
          );
        });
      },
    );
  }

  // Future paymentSheet() {
  //   return showModalBottomSheet(
  //     backgroundColor: dMode.notifire.getprimerycolor,
  //     shape: const RoundedRectangleBorder(
  //         borderRadius: BorderRadius.only(
  //             topLeft: Radius.circular(20), topRight: Radius.circular(20))),
  //     context: context,
  //     builder: (context) {
  //       return StatefulBuilder(
  //           builder: (BuildContext context, StateSetter setState) {
  //         return SingleChildScrollView(
  //           child: Column(
  //             children: [
  //               SizedBox(height: height / 38),
  //               Center(
  //                 child: Container(
  //                   height: height / 80,
  //                   width: width / 5,
  //                   decoration: const BoxDecoration(
  //                       color: Colors.grey,
  //                       borderRadius: BorderRadius.all(Radius.circular(20))),
  //                 ),
  //               ),
  //               SizedBox(height: height / 50),
  //               Row(
  //                 children: [
  //                   SizedBox(width: width / 14),
  //                   Text("Select Payment Method".tr,
  //                       style: TextStyle(
  //                           color: dMode.notifire.getdarkscolor,
  //                           fontSize: height / 40,
  //                           fontFamily: 'Gilroy_Bold')),
  //                 ],
  //               ),
  //               SizedBox(height: height / 50),
  //               //! --------- List view paymente ----------
  //               ListView.builder(
  //                 shrinkWrap: true,
  //                 itemCount: pData.paymentList.length,
  //                 scrollDirection: Axis.vertical,
  //                 physics: NeverScrollableScrollPhysics(),
  //                 itemBuilder: (ctx, i) {
  //                   return Padding(
  //                     padding: const EdgeInsets.symmetric(vertical: 8),
  //                     child: sugestlocationtype(
  //                       borderColor: selectidpay == pData.paymentList[i]["id"]
  //                           ? buttonColor
  //                           : const Color(0xffD6D6D6),
  //                       title: pData.paymentList[i]["title"],
  //                       titleColor: dMode.notifire.getdarkscolor,
  //                       val: 0,
  //                       image: Config.base_url + pData.paymentList[i]["img"],
  //                       adress: pData.paymentList[i]["subtitle"],
  //                       ontap: () async {
  //                         setState(() {
  //                           razorpaykey = pData.paymentList[i]["attributes"];
  //                           paymenttital = pData.paymentList[i]["title"];
  //                           selectidpay = pData.paymentList[i]["id"];
  //                           _groupValue = i;
  //                         });
  //                       },
  //                       radio: Radio(
  //                         activeColor: buttonColor,
  //                         value: i,
  //                         groupValue: _groupValue,
  //                         onChanged: (value) {
  //                           setState(() {});
  //                           // _groupValue = i;
  //                         },
  //                       ),
  //                     ),
  //                   );
  //                 },
  //               ),
  //
  //               SizedBox(height: 10),
  //               InkWell(
  //                   onTap: () {
  //                     //!---- Stripe Payment ------
  //
  //                     if (paymenttital == "Stripe") {
  //                       Get.back();
  //                       stripePayment();
  //                     } else if (paymenttital == "Paypal") {
  //                       //!---- PayPal Payment ------
  //                       Get.to(() => PayPalPayment(totalAmount: ticketTotal))!
  //                           .then((otid) {
  //                         if (otid != null) {
  //                           buyNoworder(otid);
  //                           ApiWrapper.showToastMessage(
  //                               "Payment Successfully");
  //                         } else {
  //                           Get.back();
  //                         }
  //                       });
  //                     } else if (paymenttital == "Razorpay") {
  //                       //!---- Razorpay Payment ------
  //                       Get.back();
  //                       openCheckout();
  //                     }
  //                   },
  //                   child: paynowbutton()),
  //               SizedBox(height: Get.height * 0.06),
  //             ],
  //           ),
  //         );
  //       });
  //     },
  //   );
  // }



  Future paymentSheet() {
    return showModalBottomSheet(
      isDismissible: false,
      backgroundColor: dMode.notifire.getprimerycolor,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20), topRight: Radius.circular(20))),
      context: context,
      builder: (context) {
        return  StatefulBuilder(
            builder: (context, setState)  {
              return ClipRRect(
                borderRadius: const BorderRadius.only(topLeft: Radius.circular(15),topRight: Radius.circular(15)),
                child: Scaffold(
                  // backgroundColor: notifier.containercoloreproper,
                  // backgroundColor: Colors.white,
                  backgroundColor: Colors.transparent,
                  floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
                  floatingActionButton: InkWell(
                      onTap: () {
                        //!---- Stripe Payment ------

                        if (paymenttital == "Stripe") {
                          Get.back();
                          stripePayment();
                        } else if (paymenttital == "Paypal") {
                          //!---- PayPal Payment ------
                          Get.to(() => PayPalPayment(totalAmount: ticketTotal))!
                              .then((otid) {
                            if (otid != null) {
                              buyNoworder(otid);
                              ApiWrapper.showToastMessage("Payment Successfully");
                            } else {
                              Get.back();
                            }
                          });
                        } else if (paymenttital == "Razorpay") {
                          //!---- Razorpay Payment ------!
                          Get.back();
                          openCheckout();
                        } else if (paymenttital == "Flutterwave") {
                          //!---- Flutterwave Payment ------!
                          Get.to(() => Flutterwave(
                              totalAmount: ticketTotal.toString(),
                              email: getData.read("UserLogin")["email"]
                          ))!
                              .then((otid) {
                            if (otid != null) {
                              // Book_Ticket( uid: widget.uid, bus_id: widget.bus_id,pick_id: widget.pick_id, dropId: widget.dropId, ticketPrice: widget.ticketPrice,trip_date: widget.trip_date,paymentId: "$otid",boardingCity: widget.boardingCity,dropCity: widget.dropCity,busPicktime: widget.busPicktime,busDroptime: widget.busDroptime,Difference_pick_drop: widget.differencePickDrop);
                              Fluttertoast.showToast(msg: 'Payment Successfully',timeInSecForIosWeb: 4);
                            } else {
                              Get.back();
                            }
                          });
                          // Get.back();
                        }else if (paymenttital == "MercadoPago") {
                          //!---- Flutterwave Payment ------!
                          Get.to(() => merpago(
                            totalAmount: (double.parse(ticketTotal.toString())).toString(),
                          ))!
                              .then((otid) {
                            if (otid != null) {
                              // Book_Ticket( uid: widget.uid, bus_id: widget.bus_id,pick_id: widget.pick_id, dropId: widget.dropId, ticketPrice: widget.ticketPrice,trip_date: widget.trip_date,paymentId: "$otid",boardingCity: widget.boardingCity,dropCity: widget.dropCity,busPicktime: widget.busPicktime,busDroptime: widget.busDroptime,Difference_pick_drop: widget.differencePickDrop);
                              Fluttertoast.showToast(msg: 'Payment Successfully',timeInSecForIosWeb: 4);
                            } else {
                              Get.back();
                            }
                          });
                          // Get.back();
                        }
                      },
                      child: paynowbutton()),
                  body: Container(
                    height: 380,
                    decoration:  BoxDecoration(
                        color: notifire.backgrounde,
                        // color: Colors.yellowAccent,

                        // border: Border.all(color: notifier.textColor),
                        borderRadius: const BorderRadius.only(topLeft: Radius.circular(15),topRight: Radius.circular(15))
                    ),
                    child:  Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget> [

                        const SizedBox(height: 13,),
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Text('Payment Getway Method'.tr,style:  TextStyle(fontWeight: FontWeight.bold,fontSize: 18,color: notifire.textcolor)),
                        ),
                        const SizedBox(height: 4,),
                        Expanded(
                          child: ListView.separated(
                            // shrinkWrap: true,
                            // itemCount: pData.paymentList.length,
                            // scrollDirection: Axis.vertical,
                            // physics: NeverScrollableScrollPhysics(),
                            separatorBuilder: (context, index) {
                              return const SizedBox(width: 0,);
                            },
                            shrinkWrap: true,
                            scrollDirection: Axis.vertical,
                            physics: const BouncingScrollPhysics(),
                            itemCount: pData.paymentList.length,
                            itemBuilder: (ctx, i) {
                              return Padding(
                                padding: const EdgeInsets.symmetric(vertical: 8),
                                child: sugestlocationtype(
                                  borderColor: selectidpay == pData.paymentList[i]["id"]
                                      ? buttonColor
                                      : const Color(0xffD6D6D6),
                                  title: pData.paymentList[i]["title"],
                                  titleColor: notifire.textcolor,
                                  val: 0,
                                  image: Config.base_url + pData.paymentList[i]["img"],
                                  adress: pData.paymentList[i]["subtitle"],
                                  ontap: () async {
                                    setState(() {
                                      razorpaykey = pData.paymentList[i]["attributes"];
                                      paymenttital = pData.paymentList[i]["title"];
                                      selectidpay = pData.paymentList[i]["id"];
                                      _groupValue = i;
                                    });
                                  },
                                  radio: Theme(
                                    data: ThemeData(unselectedWidgetColor: notifire.textcolor),
                                    child: Radio(
                                      activeColor: buttonColor,
                                      value: i,
                                      groupValue: _groupValue,
                                      onChanged: (value) {
                                        setState(() {});
                                        // _groupValue = i;
                                      },
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }
        );
      },
    );
  }

  Widget paynowbutton() {
    return Padding(
      padding: EdgeInsets.only(bottom: Get.height * 0.01),
      child: Container(
        height: height / 16,
        width: width / 1.1,
        decoration: BoxDecoration(
            color: buttonColor, borderRadius: BorderRadius.circular(12)),
        child: Center(
          child: Text(
              "PAY NOW | "
              "${mainData["currency"]}${ticketTotal}",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: height / 50,
                  fontFamily: 'Gilroy_Medium')),
        ),
      ),
    );
  }

  //!--------------------------- payment Widget --------------------
  final _formKey = GlobalKey<FormState>();
  var numberController = TextEditingController();
  final _paymentCard = PaymentCard();
  var _autoValidateMode = AutovalidateMode.disabled;
  bool isloading = false;

  final _card = PaymentCard();
  stripePayment() {
    return showModalBottomSheet(
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20), topRight: Radius.circular(20))),
      backgroundColor: dMode.notifire.getprimerycolor,
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
          return SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom),
              child: Ink(
                child: Column(
                  children: [
                    SizedBox(height: height / 45),
                    Center(
                      child: Container(
                        height: height / 85,
                        width: width / 5,
                        decoration: BoxDecoration(
                            color: Colors.grey.withOpacity(0.4),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(20))),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SizedBox(height: height * 0.03),
                          Text('Add Your payment information'.tr,
                              style: TextStyle(
                                  color: dMode.notifire.getdarkscolor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  letterSpacing: 0.5)),
                          SizedBox(height: height * 0.02),
                          Form(
                              key: _formKey,
                              autovalidateMode: _autoValidateMode,
                              child: Column(
                                children: [
                                  const SizedBox(height: 16),
                                  TextFormField(
                                      style: TextStyle(
                                          color: dMode.notifire.getdarkscolor),
                                      keyboardType: TextInputType.number,
                                      inputFormatters: [
                                        FilteringTextInputFormatter.digitsOnly,
                                        LengthLimitingTextInputFormatter(19),
                                        CardNumberInputFormatter()
                                      ],
                                      controller: numberController,
                                      onSaved: (String? value) {
                                        _paymentCard.number =
                                            CardUtils.getCleanedNumber(value!);

                                        CardType cardType =
                                            CardUtils.getCardTypeFrmNumber(
                                                _paymentCard.number.toString());
                                        setState(() {
                                          _card.name = cardType.toString();
                                          _paymentCard.type = cardType;
                                        });
                                      },
                                      onChanged: (val) {
                                        CardType cardType =
                                            CardUtils.getCardTypeFrmNumber(val);
                                        setState(() {
                                          _card.name = cardType.toString();
                                          _paymentCard.type = cardType;
                                        });
                                      },
                                      validator: CardUtils.validateCardNum,
                                      decoration: InputDecoration(
                                          prefixIcon: SizedBox(
                                              height: 10,
                                              child: Padding(
                                                  padding: const EdgeInsets.symmetric(
                                                      vertical: 14,
                                                      horizontal: 6),
                                                  child: CardUtils.getCardIcon(
                                                      _paymentCard.type))),
                                          focusedErrorBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: buttonColor)),
                                          errorBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: buttonColor)),
                                          enabledBorder: OutlineInputBorder(
                                              borderSide:
                                                  BorderSide(color: buttonColor)),
                                          focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: buttonColor)),
                                          hintText: 'What number is written on card?'.tr,
                                          hintStyle: TextStyle(color: dMode.notifire.getdarkscolor),
                                          labelStyle: TextStyle(color: dMode.notifire.getdarkscolor),
                                          labelText: 'Number'.tr)),
                                  const SizedBox(height: 20),
                                  Row(
                                    children: [
                                      Flexible(
                                        flex: 4,
                                        child: TextFormField(
                                          style: TextStyle(
                                              color:
                                                  dMode.notifire.getdarkscolor),
                                          inputFormatters: [
                                            FilteringTextInputFormatter
                                                .digitsOnly,
                                            LengthLimitingTextInputFormatter(4),
                                          ],
                                          decoration: InputDecoration(
                                              prefixIcon: SizedBox(
                                                  height: 10,
                                                  child: Padding(
                                                      padding:
                                                          const EdgeInsets.symmetric(
                                                              vertical: 14),
                                                      child: Image.asset(
                                                          'image/card_cvv.png',
                                                          width: 6,
                                                          color: buttonColor))),
                                              focusedErrorBorder:
                                                  OutlineInputBorder(
                                                      borderSide: BorderSide(
                                                          color: buttonColor)),
                                              errorBorder: OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: buttonColor)),
                                              enabledBorder: OutlineInputBorder(
                                                  borderSide:
                                                      BorderSide(color: buttonColor)),
                                              focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: buttonColor)),
                                              hintText: 'Number behind the card'.tr,
                                              hintStyle: TextStyle(color: dMode.notifire.getdarkscolor),
                                              labelStyle: TextStyle(color: dMode.notifire.getdarkscolor),
                                              labelText: 'CVV'.tr),
                                          validator: CardUtils.validateCVV,
                                          keyboardType: TextInputType.number,
                                          onSaved: (value) {
                                            _paymentCard.cvv =
                                                int.parse(value!);
                                          },
                                        ),
                                      ),
                                      SizedBox(width: Get.width * 0.03),
                                      Flexible(
                                        flex: 4,
                                        child: TextFormField(
                                          style: TextStyle(
                                              color:
                                                  dMode.notifire.getdarkscolor),
                                          inputFormatters: [
                                            FilteringTextInputFormatter
                                                .digitsOnly,
                                            LengthLimitingTextInputFormatter(4),
                                            CardMonthInputFormatter()
                                          ],
                                          decoration: InputDecoration(
                                              prefixIcon: SizedBox(
                                                  height: 10,
                                                  child: Padding(
                                                      padding:
                                                          const EdgeInsets.symmetric(
                                                              vertical: 14),
                                                      child: Image.asset(
                                                          'image/calender.png',
                                                          width: 10,
                                                          color: buttonColor))),
                                              errorBorder: OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: buttonColor)),
                                              focusedErrorBorder:
                                                  OutlineInputBorder(
                                                      borderSide: BorderSide(
                                                          color: buttonColor)),
                                              enabledBorder: OutlineInputBorder(
                                                  borderSide:
                                                      BorderSide(color: buttonColor)),
                                              focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: buttonColor)),
                                              hintText: 'MM/YY'.tr,
                                              hintStyle: TextStyle(color: dMode.notifire.getdarkscolor),
                                              labelStyle: TextStyle(color: dMode.notifire.getdarkscolor),
                                              labelText: 'Expiry Date'.tr),
                                          validator: CardUtils.validateDate,
                                          keyboardType: TextInputType.number,
                                          onSaved: (value) {
                                            List<int> expiryDate =
                                                CardUtils.getExpiryDate(value!);
                                            _paymentCard.month = expiryDate[0];
                                            _paymentCard.year = expiryDate[1];
                                          },
                                        ),
                                      )
                                    ],
                                  ),
                                  SizedBox(height: Get.height * 0.055),
                                  Container(
                                      alignment: Alignment.center,
                                      child: _getPayButton()),
                                  SizedBox(height: Get.height * 0.065),
                                ],
                              ))
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        });
      },
    );
  }

  @override
  void dispose() {
    numberController.removeListener(_getCardTypeFrmNumber);
    numberController.dispose();
    _razorpay.clear();
    super.dispose();
  }

  void _getCardTypeFrmNumber() {
    String input = CardUtils.getCleanedNumber(numberController.text);
    CardType cardType = CardUtils.getCardTypeFrmNumber(input);
    setState(() {
      _paymentCard.type = cardType;
    });
  }

  void _validateInputs() {
    final FormState form = _formKey.currentState!;
    if (!form.validate()) {
      setState(() {
        _autoValidateMode =
            AutovalidateMode.always; // Start validating on every change.
      });
      _showInSnackBar('Please fix the errors in red before submitting.');
    } else {
      var username = getData.read("UserLogin")["name"] ?? "";
      var email = getData.read("UserLogin")["email"] ?? "";
      _paymentCard.name = username;
      _paymentCard.email = email;
      _paymentCard.amount = ticketTotal;
      form.save();

      Get.to(() => StripePaymentWeb(paymentCard: _paymentCard))!.then((otid) {
        Get.back();
        //! order Api call
        if (otid != null) {
          log(otid.toString(), name: "StripePaymentWeb irder id :: ");
          //! Api Call Payment Success
          buyNoworder(otid);
        }
      });

      _showInSnackBar('Payment card is valid');
    }
  }

  Widget _getPayButton() {
    return SizedBox(
      width: Get.width,
      child: CupertinoButton(
          onPressed: _validateInputs,
          color: buttonColor,
          child: Text("Pay ${mainData["currency"]}${ticketTotal}",
              style: TextStyle(fontSize: 17.0))),
    );
  }

  void _showInSnackBar(String value) {
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(value), duration: const Duration(seconds: 3)));
  }

  void openCheckout() async {
    var username = getData.read("UserLogin")["name"] ?? "";
    var mobile = getData.read("UserLogin")["mobile"] ?? "";
    var email = getData.read("UserLogin")["email"] ?? "";
    var options = {
      'key': razorpaykey,
      'amount': (double.parse(ticketTotal) * 100).toString(),
      'name': username,
      'description': ticketType,
      'timeout': 300,
      'prefill': {'contact': mobile, 'email': email},
    };

    try {
      _razorpay.open(options);
    } catch (e) {
      debugPrint('Error: e');
    }
  }

  buyNoworder(otid) {
    var dataa = {
      "uid": uID,
      "eid": widget.eid,
      "typeid": typeid,
      "type": ticketType,
      "price": ticketprice,
      "total_ticket": _counter.toString(),
      "subtotal": subtotal,
      "tax": ticketax,
      "cou_amt": couponamount,
      "total_amt": ticketTotal,
      "wall_amt": useWallet,
      "p_method_id": selectidpay,
      "transaction_id": "$otid"
    };
    print(dataa);

    ApiWrapper.dataPost(Config.ebookticket, dataa).then((val) {
      log(val.toString(), name: "ticket Book value 1 :: ");
      if ((val != null) && (val.isNotEmpty)) {
        if ((val['ResponseCode'] == "200") && (val['Result'] == "true")) {
          log(val.toString(), name: "ticket Book value :: ");
          save("EID", widget.eid);
          getData.read("UserLogin") != null
              ? hData.homeDataApi(getData.read("UserLogin")["id"], lat, long)
              : null;
          walletAmount = wallet;
          Get.off(() => Final(tID: val["order_id"].toString()));
        } else {
          ApiWrapper.showToastMessage(val["ResponseMsg"]);
        }
      }
    });
  }
}
