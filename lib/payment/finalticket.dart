// ignore_for_file: prefer_const_constructors, avoid_print, prefer_typing_uninitialized_variables, unnecessary_null_comparison

import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:user/Api/ApiWrapper.dart';
import 'package:user/Api/Config.dart';
import 'package:user/AppModel/Homedata/HomedataController.dart';
import 'package:user/booking/booking.dart';
import 'package:user/utils/color.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ticket_widget/ticket_widget.dart';
import '../utils/colornotifire.dart';
import '../utils/media.dart';

//   Done
class Final extends StatefulWidget {
  final String? tID;
  const Final({Key? key, this.tID}) : super(key: key);

  @override
  _FinalState createState() => _FinalState();
}

class _FinalState extends State<Final> {
  late ColorNotifire notifire;
  Map ticketData = {};
  bool isLoading = false;
  var jsonobj;
  GlobalKey globalKey = GlobalKey();

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
    previewticket();
    getdarkmodepreviousstate();
  }

  previewticket() {
    setState(() {
      isLoading = true;
    });
    var data = {"tid": widget.tID, "uid": uID};
    ApiWrapper.finalticketdataPost(Config.ticketpreview, data).then((val) {
      if ((val != null) && (val.isNotEmpty)) {
        var response = jsonDecode(val);
        if ((response['ResponseCode'] == "200") &&
            (response['Result'] == "true")) {
          ticketData = response["TicketData"];
          log(val.toString(), name: "Event Ticket : ");
          jsonobj = val;
          print("+-+-+-+-+-+-+-+-aaaaaaaaaaa+-+-+-+-+-+-+-+-+"
              "${jsonobj.toString()}");
          setState(() {});
          isLoading = false;
        } else {
          setState(() {});
          isLoading = false;
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    Future.delayed(const Duration(seconds: 1), () {
      setState(() {});
    });
    notifire = Provider.of<ColorNotifire>(context, listen: true);
    return Scaffold(
      backgroundColor: notifire.finalticketcolore,
      //! ----- My Booking button  -----
      floatingActionButton: SizedBox(
        height: 45,
        width: 425,
        child: FloatingActionButton(
          onPressed: () {
            Get.to(() => Booking(tID: widget.tID));
          },
          child: Center(
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                  border: Border.all(color: notifire.getbuttonscolor, width: 2),
                  color: notifire.getprimerycolor),
              height: height / 15,
              width: width / 1.4,
              child: Row(
                children: [
                  SizedBox(width: width / 5),
                  Text("My Booking".tr,
                      style: TextStyle(
                          color: notifire.getbuttonscolor,
                          fontSize: 15,
                          fontWeight: FontWeight.w600)),
                  SizedBox(width: width / 9.5),
                  Padding(
                      padding: const EdgeInsets.symmetric(vertical: 9),
                      child: Image.asset("image/arrow.png")),
                ],
              ),
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: Stack(
        children: [
          Column(
            children: [
              SizedBox(height: height / 20),
              //! ----- AppBar -----

              Row(
                children: [
                  SizedBox(width: width / 20),
                  GestureDetector(
                      onTap: () {
                        Get.back();
                      },
                      child: const Icon(Icons.arrow_back, color: Colors.white)),
                  SizedBox(width: width / 80),
                  Text("Congratulation !".tr,
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w900,
                          fontFamily: 'Gilroy Medium',
                          color: Colors.white)),
                ],
              ),
              SizedBox(height: height / 25),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      ticketData.isNotEmpty
                          ? TicketWidget(
                              color: notifire.containercolore,
                              width: Get.width * 0.92,
                              height: Get.height * 0.8,
                              isCornerRounded: true,
                              margin: const EdgeInsets.all(6),
                              padding: EdgeInsets.zero,
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 20),
                                child: Column(
                                  children: [
                                    SizedBox(height: Get.height * 0.03),
                                    ticketData.isNotEmpty
                                        ? Container(
                                            height: height / 4.7,
                                            width: Get.width,
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                image: DecorationImage(
                                                    image: NetworkImage(
                                                        Config.base_url +
                                                            ticketData[
                                                                "ticket_img"]),
                                                    fit: BoxFit.cover)))
                                        : SizedBox(),
                                    SizedBox(height: Get.height * 0.02),
                                    Text(
                                        ticketData.isNotEmpty
                                            ? ticketData["ticket_title"]
                                            : "",
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        textAlign: TextAlign.start,
                                        style: TextStyle(
                                            fontSize: 24,
                                            fontWeight: FontWeight.w500,
                                            fontFamily: 'Gilroy Medium',
                                            color: notifire.textcolor)),
                                    SizedBox(height: Get.height * 0.02),
                                    SizedBox(width: width / 8),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        ticketText(
                                          title: "NAME".tr,
                                          subtitle: ticketData.isNotEmpty
                                              ? ticketData["ticket_username"]
                                              : "",
                                        ),
                                        SizedBox(height: Get.height * 0.02),
                                        Row(
                                          children: [
                                            ticketText(
                                              title: "DATE".tr,
                                              subtitle: ticketData.isNotEmpty
                                                  ? ticketData["event_sdate"]
                                                  : "",
                                            ),
                                            SizedBox(width: width / 5),
                                            ticketText(
                                              title: "TIME".tr,
                                              subtitle: ticketData.isNotEmpty
                                                  ? ticketData["start_time"]
                                                  : "",
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: Get.height * 0.01),
                                        ticketText(
                                          title: "Location".tr,
                                          subtitle: ticketData.isNotEmpty
                                              ? ticketData[
                                                  "event_address_title"]
                                              : "",
                                        ),
                                        SizedBox(height: height / 200),
                                        Text(
                                          ticketData.isNotEmpty
                                              ? ticketData["event_address"]
                                              : "",
                                          style: TextStyle(
                                              fontSize: 15,
                                              fontFamily: 'Gilroy Normal',
                                              color: Colors.grey),
                                        ),
                                      ],
                                    ),
                                    // Column(
                                    //   children: [
                                    //     ticketUserRow(
                                    //         title: "Phone",
                                    //         subtitle:
                                    //             ticketData["ticket_mobile"]),

                                    //     SizedBox(height: Get.height * 0.014),
                                    //     ticketUserRow(
                                    //         title: "Email",
                                    //         subtitle:
                                    //             ticketData["ticket_email"]),
                                    //     SizedBox(height: Get.height * 0.02),
                                    //     // //! ------- Ticket Price  --------
                                    //     ticketUserRow(
                                    //         title: "Seats",
                                    //         subtitle:
                                    //             "${ticketData["total_ticket"]}x ${ticketData["ticket_type"]}"),
                                    //     SizedBox(height: Get.height * 0.014),
                                    //     ticketUserRow(
                                    //         title: "Tax",
                                    //         subtitle:
                                    //             "${ticketData["currency"]}${ticketData["ticket_tax"]}"),
                                    //     SizedBox(height: Get.height * 0.014),
                                    //     ticketData != null
                                    //         ? ticketData["ticket_wall_amt"] !=
                                    //                 "0"
                                    //             ? Column(
                                    //                 children: [
                                    //                   ticketUserRow(
                                    //                       title: "Wallet",
                                    //                       subtitle:
                                    //                           "${ticketData["currency"]}${ticketData["ticket_wall_amt"]}"),
                                    //                   SizedBox(
                                    //                       height: Get.height *
                                    //                           0.018),
                                    //                 ],
                                    //               )
                                    //             : const SizedBox()
                                    //         : const SizedBox(),
                                    //     ticketData != null
                                    //         ? ticketData[
                                    //                     "ticket_total_amt"] !=
                                    //                 "0"
                                    //             ? Column(
                                    //                 children: [
                                    //                   ticketUserRow(
                                    //                       title: "Total",
                                    //                       subtitle:
                                    //                           "${ticketData["currency"]}${ticketData["ticket_total_amt"]}"),
                                    //                   SizedBox(
                                    //                       height: Get.height *
                                    //                           0.032),
                                    //                 ],
                                    //               )
                                    //             : const SizedBox()
                                    //         : const SizedBox(),
                                    //     ticketData != null
                                    //         ? ticketData[
                                    //                     "ticket_transaction_id"] !=
                                    //                 "0"
                                    //             ? Column(
                                    //                 children: [
                                    //                   ticketUserRow(
                                    //                       title:
                                    //                           "Transaction ID",
                                    //                       subtitle: ticketData[
                                    //                           "ticket_transaction_id"]),
                                    //                   SizedBox(
                                    //                       height: Get.height *
                                    //                           0.014),
                                    //                 ],
                                    //               )
                                    //             : const SizedBox()
                                    //         : const SizedBox(),

                                    //     ticketUserRow(
                                    //         title: "Payment Methods",
                                    //         subtitle: ticketData[
                                    //             "ticket_p_method"]),
                                    //     SizedBox(height: Get.height * 0.014),
                                    //     ticketUserRow(
                                    //         title: "Status",
                                    //         subtitle:
                                    //             ticketData["ticket_status"]),
                                    //     SizedBox(height: Get.height * 0.02),
                                    //     ticketUserRow(
                                    //         title: "Uid",
                                    //         subtitle: ticketData["uid"]),
                                    //     SizedBox(height: Get.height * 0.014),
                                    //     ticketUserRow(
                                    //         title: "Ticket Id",
                                    //         subtitle:
                                    //             ticketData["ticket_id"]),
                                    //     SizedBox(height: Get.height * 0.014),
                                    //   ],
                                    // ),
                                    Center(
                                      child: QrImageView(
                                          data: "$jsonobj",
                                          version: QrVersions.auto,
                                          size: 140.0),
                                    ),

                                  ],
                                ),
                              ),
                            )
                          : Padding(
                              padding: EdgeInsets.only(top: Get.height * 0.35),
                              child: CircularProgressIndicator()),
                      SizedBox(height: Get.height * 0.10),
                    ],
                  ),
                ),
              ),
            ],
          ),
          // Positioned(
          //   bottom: Get.height * 0.075,
          //   left: Get.width * 0.3,
          //   child: ticketData.isNotEmpty
          //       ?
          //       : SizedBox(),
          // ),
        ],
      ),
    );
  }

  ticketText({String? title, subtitle}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title!,
            style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                fontFamily: 'Gilroy Medium',
                color: Colors.grey)),
        SizedBox(height: height / 200),
        Text(subtitle!,
            style: TextStyle(
                fontSize: 15,
                fontFamily: 'Gilroy Bold',
                color: notifire.textcolor)),
      ],
    );
  }

  ticketUserRow({String? title, subtitle}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title ?? "",
            style: const TextStyle(
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
                  color: blackColor)),
        ),
      ],
    );
  }
}

class OverlapSquare extends StatelessWidget {
  const OverlapSquare({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200.1,
      child: ClipRect(
          clipBehavior: Clip.hardEdge,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.red,
            ),
            child: OverflowBox(
              maxHeight: 250,
              maxWidth: 250,
              child: Center(
                child: Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ),
          )),
    );
  }
}
