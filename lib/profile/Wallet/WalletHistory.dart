// ignore_for_file: file_names, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:user/Api/ApiWrapper.dart';
import 'package:user/Api/Config.dart';
import 'package:user/AppModel/Homedata/HomedataController.dart';
import 'package:user/profile/Wallet/addWallet.dart';
import 'package:user/utils/botton.dart';
import 'package:user/utils/color.dart';
import 'package:user/utils/colornotifire.dart';
import 'package:user/utils/media.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WalletReportPage extends StatefulWidget {
  const WalletReportPage({Key? key}) : super(key: key);

  @override
  State<WalletReportPage> createState() => _WalletWalletReportPageState();
}

class _WalletWalletReportPageState extends State<WalletReportPage> {
  late ColorNotifire notifire;
  List walletitem = [];
  String? totalAmount = "0";

  @override
  void initState() {
    walletgetdata();
    getdarkmodepreviousstate();
    super.initState();
  }

  getdarkmodepreviousstate() async {
    final prefs = await SharedPreferences.getInstance();
    bool? previusstate = prefs.getBool("setIsDark");
    if (previusstate == null) {
      notifire.setIsDark = false;
    } else {
      notifire.setIsDark = previusstate;
    }
  }

  walletgetdata() async {
    var data = {"uid": uID};

    ApiWrapper.dataPost(Config.walletreport, data).then((val) {
      if ((val != null) && (val.isNotEmpty)) {
        if ((val['ResponseCode'] == "200") && (val['Result'] == "true")) {
          setState(() {});
          totalAmount = val["wallet"];
          walletitem = val["Walletitem"];
        } else {
          setState(() {});
          // ApiWrapper.showToastMessage(val["ResponseMsg"]);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    notifire = Provider.of<ColorNotifire>(context, listen: true);

    Future.delayed(const Duration(seconds: 0), () {
      setState(() {});
    });
    return Scaffold(
      backgroundColor: notifire.backgrounde,
      floatingActionButton: SizedBox(
        height: 45,
        width: 410,
        child: FloatingActionButton(
          onPressed: () {
            Get.to(() => AddWalletPage(amount: totalAmount))!.then((value) {
              walletgetdata();
            });
          },
          child: Custombutton.button1(
              notifire.getbuttonscolor,
              "Add AMOUNT".tr.toUpperCase(),
              SizedBox(width: width / 6.5),
              SizedBox(width: width / 10)),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: Column(
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
                      "Wallet".tr,
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w900,
                          fontFamily: 'Gilroy Medium',
                          color: notifire.textcolor),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: Get.height * 0.01),
          Padding(
            padding: EdgeInsets.only(left: Get.width * 0.03),
            child: Container(
              height: Get.height * 0.20,
              width: Get.width,
              decoration: const BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage('image/walletTop.png'),
                      fit: BoxFit.fill)),
              child: Padding(
                padding: EdgeInsets.only(left: Get.width * 0.04),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "${mainData["currency"]}$totalAmount",
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Gilroy Bold',
                          color: notifire.getwhite),
                    ),
                    Text(
                      "Your current Balance ".tr,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Gilroy Bold',
                          color: notifire.getwhite),
                    ),
                    Container(
                      height: Get.height * 0.04,
                    )
                  ],
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              child: Text(
                "History",
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Gilroy Bold',
                    color: notifire.textcolor),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10,right: 10),
            child: Column(
              children: [
                walletitem.isNotEmpty
                    ? SizedBox(
                        height: Get.height * 0.65,
                        child: ListView.builder(
                          itemCount: walletitem.length,
                          physics: const AlwaysScrollableScrollPhysics(),
                          padding: EdgeInsets.only(bottom: Get.height * 0.02),
                          shrinkWrap: true,
                          itemBuilder: (ctx, i) {
                            return walletList(walletitem, i);
                          },
                        ),
                      )
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image(
                              image: const AssetImage("image/33.png"),
                              height: Get.height * 0.14),
                          SizedBox(height: Get.height * 0.02),
                          Center(
                            child: Text("Looks like you haven't booked yet".tr,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: notifire.gettextcolor,
                                  fontSize: 16,
                                  fontFamily: 'Gilroy Bold',
                                )),
                          ),
                          SizedBox(height: Get.height * 0.02),
                        ],
                      ),
              ],
            ),
          )
        ],
      ),
    );
  }

  walletList(user, i) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Card(
        color: notifire.containercolore,
        elevation: 0,
        child: Container(
          width: Get.width * 0.90,
          height: Get.height * 0.08,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: notifire.bordercolore, width: 0.5)),
          child:
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            SizedBox(width: Get.width * 0.02),
            Image(
                image: const AssetImage("image/wallet1.png"),
                height: Get.height * 0.05),
            SizedBox(width: Get.width * 0.02),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Ink(
                  width: Get.width * 0.60,
                  child: Text(
                    user[i]["message"],
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Gilroy Bold',
                        color: notifire.textcolor),
                  ),
                ),
                Ink(
                  width: Get.width * 0.58,
                  child: Text(
                    user[i]["tdate"],
                    style: TextStyle(
                        fontSize: 14,
                        fontFamily: 'Gilroy Medium',
                        color: Colors.grey),
                  ),
                ),
              ],
            ),
            user[i]["status"] == "Credit"
                ? Text(
                    "${user[i]["amt"]}${mainData["currency"]}+",
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Gilroy Bold',
                        color: buttonColor),
                  )
                : Text(
                    "${user[i]["amt"]}${mainData["currency"]}- ",
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Gilroy Bold',
                        color: Colors.orange.shade300),
                  ),
          ]),
        ),
      ),
    );
  }
}
