// ignore_for_file: unnecessary_null_comparison, deprecated_member_use, file_names, non_constant_identifier_names, avoid_print, prefer_typing_uninitialized_variables, unnecessary_brace_in_string_interps, unused_local_variable, prefer_const_constructors

import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:user/Api/ApiWrapper.dart';
import 'package:user/Api/Config.dart';
import 'package:user/AppModel/Homedata/HomedataController.dart';
import 'package:user/booking/booking.dart';
import 'package:user/utils/AppWidget.dart';
import 'package:user/utils/Images.dart';
import 'package:user/utils/botton.dart';
import 'package:user/utils/colornotifire.dart';
import 'package:user/utils/media.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TicketDetailPage extends StatefulWidget {
  final String? eID;
  const TicketDetailPage({Key? key, this.eID}) : super(key: key);

  @override
  State<TicketDetailPage> createState() => _TicketDetailPageState();
}

class _TicketDetailPageState extends State<TicketDetailPage> {
  ScreenshotController screenshotController = ScreenshotController();
  late ColorNotifire notifire;
  Uint8List? capturedImage;
  bool isLoading = false;
  var jsonobj;
  Map ticketData = {};
  var temp;

  getdarkmodepreviousstate() async {
    final prefs = await SharedPreferences.getInstance();
    bool? previusstate = prefs.getBool("setIsDark");
    if (previusstate == null) {
      notifire.setIsDark = false;
    } else {
      notifire.setIsDark = previusstate;
    }
  }

//!------------------------
  @override
  void initState() {
    ticketStatusApi();
    getdarkmodepreviousstate();
    super.initState();
  }

  ticketStatusApi() async {
    setState(() {
      isLoading = true;
    });
    var data = {"tid": widget.eID, "uid": uID};
    ApiWrapper.dataPostjsonEncode(Config.ticketdata, data).then((val) {
      if ((val != null) && (val.isNotEmpty)) {
        var response = jsonDecode(val);
        if ((response['ResponseCode'] == "200") &&
            (response['Result'] == "true")) {
          ticketData = response["TicketData"];
          log(val.toString(), name: "Event Ticket : ");
          jsonobj = val;
          print("+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+" "${jsonobj.toString()}");
          setState(() {});
          isLoading = false;
        } else {
          setState(() {});
          isLoading = false;
        }
      }
    });
  }

  Future saveandShare(Uint8List bytes) async {
    final directory = await getApplicationDocumentsDirectory();
    final image = File("${directory.path}/ticket.jpg");
    image.writeAsBytesSync(bytes);
    await Share.shareFiles([image.path]);
  }

  @override
  Widget build(BuildContext context) {
    Future.delayed(const Duration(seconds: 0), () {
      setState(() {});
    });
    notifire = Provider.of<ColorNotifire>(context, listen: true);
    return Scaffold(
      backgroundColor: notifire.backgrounde,
      floatingActionButton: SizedBox(
        height: 45,
        width: 410,
        child: FloatingActionButton(
          onPressed: () {
            screenshotController
                .capture(delay: const Duration(milliseconds: 10))
                .then((capturedImage) async {
              capturedImage = capturedImage;
              log(capturedImage.toString(), name: "Image");
              saveandShare(capturedImage!);
            }).catchError((onError) {});
          },
          child: Custombutton.button1(
              notifire.getbuttonscolor,
              "Download Ticket".tr,
              SizedBox(width: width / 6.5),
              SizedBox(width: width / 10)),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: height / 20),
          //! ------- AppBar -------
          Row(
            children: [
              SizedBox(width: width / 40),
              InkWell(
                onTap: () {
                  Get.back();
                },
                child: Row(
                  children: [
                    Icon(Icons.arrow_back, color: notifire.textcolor),
                    SizedBox(width: width / 80),
                    Text(
                      "E-Ticket".tr,
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w900,
                          fontFamily: 'Gilroy Medium',
                          color: notifire.textcolor),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              InkWell(
                onTap: () {
                  Get.to(() => Booking(tID: ticketData["ticket_id"]));
                },
                child: Image(
                    image:  AssetImage(Images.more),
                    color: notifire.textcolor,
                    height: Get.height * 0.025),
              ),
              SizedBox(width: width / 20),
            ],
          ),
          SizedBox(height: Get.height * 0.015),
          Expanded(
            child: Screenshot(
              controller: screenshotController,
              child: SingleChildScrollView(
                child: !isLoading
                    ? Container(
                        color: notifire.containercolore,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 18),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              //! barcode add
                              SizedBox(height: Get.height * 0.014),
                              ticketTextRow(
                                  title: "Event".tr,
                                  subtitle: ticketData["ticket_title"]),

                              SizedBox(height: Get.height * 0.014),
                              ticketTextRow(
                                  title: "Date and Hour".tr.toLowerCase(),
                                  subtitle: ticketData["start_time"]),

                              SizedBox(height: Get.height * 0.014),
                              ticketTextRow(
                                  title: "Event Location".tr,
                                  subtitle: ticketData["event_address"]),

                              SizedBox(height: Get.height * 0.014),
                              ticketTextRow(
                                  title: "Event organizer".tr,
                                  subtitle: ticketData["event_address_title"]),

                              SizedBox(height: Get.height * 0.02),
                              //! ------- User Details --------
                              ticketUserRow(
                                  title: "Full Name".tr,
                                  subtitle: ticketData["ticket_username"]),

                              SizedBox(height: Get.height * 0.014),

                              ticketUserRow(
                                  title: "Phone".tr,
                                  subtitle: ticketData["ticket_mobile"]),

                              SizedBox(height: Get.height * 0.014),
                              ticketUserRow(
                                  title: "Email".tr,
                                  subtitle: ticketData["ticket_email"]),
                              SizedBox(height: Get.height * 0.02),
                              // //! ------- Ticket Price  --------
                              ticketUserRow(
                                  title: "Seats".tr,
                                  subtitle:
                                      "${ticketData["total_ticket"]}x ${ticketData["ticket_type"]}"),
                              SizedBox(height: Get.height * 0.014),
                              ticketUserRow(
                                  title: "Tax".tr,
                                  subtitle:
                                      "${mainData["currency"]}${ticketData["ticket_tax"]}"),
                              SizedBox(height: Get.height * 0.014),
                              ticketData != null
                                  ? ticketData["ticket_wall_amt"] != "0"
                                      ? Column(
                                          children: [
                                            ticketUserRow(
                                                title: "Wallet".tr,
                                                subtitle:
                                                    "${mainData["currency"]}${ticketData["ticket_wall_amt"]}"),
                                            SizedBox(
                                                height: Get.height * 0.018),
                                          ],
                                        )
                                      : const SizedBox()
                                  : const SizedBox(),
                              ticketData != null
                                  ? ticketData["ticket_total_amt"] != "0"
                                      ? Column(
                                          children: [
                                            ticketUserRow(
                                                title: "Total".tr,
                                                subtitle:
                                                    "${mainData["currency"]}${ticketData["ticket_total_amt"]}"),
                                            SizedBox(
                                                height: Get.height * 0.032),
                                          ],
                                        )
                                      : const SizedBox()
                                  : const SizedBox(),
                              ticketData != null
                                  ? ticketData["ticket_transaction_id"] != "0"
                                      ? Column(
                                          children: [
                                            ticketUserRow(
                                                title: "Transaction ID".tr,
                                                subtitle: ticketData[
                                                    "ticket_transaction_id"]),
                                            SizedBox(
                                                height: Get.height * 0.014),
                                          ],
                                        )
                                      : const SizedBox()
                                  : const SizedBox(),

                              ticketUserRow(
                                  title: "Payment Methods".tr,
                                  subtitle: ticketData["ticket_p_method"]),
                              SizedBox(height: Get.height * 0.014),
                              ticketUserRow(
                                  title: "Status".tr,
                                  subtitle: ticketData["ticket_status"]),
                              SizedBox(height: Get.height * 0.02),

                              InkWell(
                                onTap: () {
                                  print("+++++++++++++++++++++++++++++++++++$ticketData");
                                },
                                child: Center(
                                  child: QrImageView(
                                    // backgroundColor: notifire.textcolor,
                                      data: "$jsonobj",
                                      version: QrVersions.auto,
                                      size: 170.0),
                                ),
                              ),
                              SizedBox(height: Get.height * 0.12),
                            ],
                          ),
                        ),
                      )
                    : isLoadingCircular(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  ticketUserRow({String? title, subtitle}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title ?? "",
            style: TextStyle(
                fontSize: 14, fontFamily: 'Gilroy Medium', color: Colors.grey)),
        Ink(
          width: Get.width * 0.50,
          child: Text(subtitle ?? "",
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
              textAlign: TextAlign.end,
              style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  fontFamily: 'Gilroy Medium',
                  color: notifire.textcolor)),
        ),
      ],
    );
  }

  ticketUserCopy(
      {String? title, subtitle, Widget? textCopy, Function()? OnTap}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Tooltip(
          preferBelow: false,
          message: "Copy",
          child: Text(title!,
              style: TextStyle(
                  fontSize: 14,
                  fontFamily: 'Gilroy Medium',
                  color: Colors.grey)),
        ),
        InkWell(
          onTap: OnTap,
          child: Row(
            children: [
              Ink(
                width: Get.width * 0.50,
                child: Text(subtitle ?? "",
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    textAlign: TextAlign.end,
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        fontFamily: 'Gilroy Medium',
                        color: notifire.getdarkscolor)),
              ),
              SizedBox(child: textCopy)
            ],
          ),
        )
      ],
    );
  }

  ticketTextRow({String? title, String? subtitle}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title!,
            style: TextStyle(
                fontSize: 14, fontFamily: 'Gilroy Medium', color: Colors.grey)),
        SizedBox(height: Get.height * 0.006),
        Text(subtitle ?? "",
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                fontFamily: 'Gilroy Medium',
                color: notifire.textcolor)),
      ],
    );
  }
}
// class User {
//   final String name;
//   final String email;

//   User(this.name, this.email);

//   User.fromJson(Map<String, dynamic> json)
//       : name = json['name'],
//         email = json['email'];

//   Map<String, dynamic> toJson() => {
//         'name': name,
//         'email': email,
//       };
// }