// ignore_for_file: file_names, avoid_print, prefer_const_constructors, prefer_is_empty, prefer_collection_literals

import 'dart:ui' as ui;
import 'dart:developer';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:user/Api/ApiWrapper.dart';
import 'package:user/Api/Config.dart';
import 'package:user/AppModel/Homedata/HomedataController.dart';
import 'package:user/home/EventDetails.dart';
import 'package:user/utils/colornotifire.dart';
import 'package:user/utils/media.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

//! Done
class SearchPage extends StatefulWidget {
  final String? type;
  const SearchPage({Key? key, this.type}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  late ColorNotifire notifire;

  List eventAllList = [];
  bool isLoading = false;
  late GoogleMapController mapController;

  CameraPosition kGoogle = CameraPosition(
    target: LatLng(21.2381962, 72.8879607),
    zoom: 5,
  );

  @override
  void initState() {
    super.initState();
    eventSearchApi("a");

    getdarkmodepreviousstate();
  }

  eventSearchApi(String? val) {
    isLoading = true;
    setState(() {});
    var data = {"title": val, "uid": uID};
    print(data);
    ApiWrapper.dataPost(Config.eventSearch, data).then((val) {
      if ((val != null) && (val.isNotEmpty)) {
        if ((val['ResponseCode'] == "200") && (val['Result'] == "true")) {
          eventAllList = val["SearchData"];
          getmarkers();
          isLoading = false;
          setState(() {});
          log(val.toString(), name: " Event Search Api :: ");
        } else {
          isLoading = false;
          setState(() {});
          // ApiWrapper.showToastMessage(val["ResponseMsg"]);
        }
      }
    });
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

  Future<Uint8List> getImages(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetHeight: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
        .buffer
        .asUint8List();
  }

  @override
  Widget build(BuildContext context) {
    Future.delayed(const Duration(seconds: 0), () => setState(() {}));
    notifire = Provider.of<ColorNotifire>(context, listen: true);
    return Scaffold(
      backgroundColor: notifire.backgrounde,
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                // Container(
                //   height: Get.height * 0.15,
                //   width: double.infinity,
                //   decoration: BoxDecoration(
                //       color: notifire.gettopcolor,
                //       borderRadius: const BorderRadius.only(
                //           bottomRight: Radius.circular(20),
                //           bottomLeft: Radius.circular(20))),
                //   child: Padding(
                //     padding: const EdgeInsets.symmetric(horizontal: 08),
                //     child: Column(
                //       children: [
                //         SizedBox(height: Get.height * 0.05),
                //         Padding(
                //           padding: EdgeInsets.only(left: Get.width * 0.04),
                //           child: Row(
                //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //             children: [
                //               widget.type == "0"
                //                   ? InkWell(
                //                 onTap: () {
                //                   Get.back();
                //                 },
                //                 child: const Icon(Icons.arrow_back,
                //                     color: Colors.white, size: 26),
                //               )
                //                   : const SizedBox(),
                //               Text(
                //                 "Search".tr,
                //                 style: TextStyle(
                //                   color: Colors.white,
                //                   fontSize: 18,
                //                   fontWeight: FontWeight.w900,
                //                   fontFamily: 'Gilroy Medium',
                //                 ),
                //               ),
                //               const SizedBox()
                //             ],
                //           ),
                //         ),
                //         SizedBox(height: Get.height * 0.008),
                //         Padding(
                //           padding: const EdgeInsets.symmetric(horizontal: 20),
                //           child: Row(
                //             children: [
                //               Image.asset("image/search.png", height: height / 30),
                //               SizedBox(width: width / 90),
                //               Container(width: 1, height: height / 40, color: Colors.grey),
                //               SizedBox(width: width / 90),
                //               //! ------ Search TextField -------
                //               Container(
                //                 color: Colors.transparent,
                //                 height: height / 20,
                //                 width: width / 1.7,
                //                 child: TextField(
                //                   onChanged: (val) {
                //                     val.length != 0
                //                         ? eventSearchApi(val)
                //                         : eventSearchApi("a");
                //                   },
                //                   style: TextStyle(
                //                       fontFamily: 'Gilroy Medium',
                //                       color: Colors.white,
                //                       fontSize: 15),
                //                   decoration: InputDecoration(
                //                     border: InputBorder.none,
                //                     focusedBorder: InputBorder.none,
                //                     enabledBorder: InputBorder.none,
                //                     errorBorder: InputBorder.none,
                //                     disabledBorder: InputBorder.none,
                //                     hintText: "Search...".tr,
                //                     hintStyle: TextStyle(
                //                         fontFamily: 'Gilroy Medium',
                //                         color: const Color(0xffd2d2db),
                //                         fontSize: 15),
                //                   ),
                //                 ),
                //               ),
                //             ],
                //           ),
                //         ),
                //       ],
                //     ),
                //   ),
                // ),
                // SizedBox(height: Get.height * 0.01),

                SizedBox(
                  height: Get.size.height,
                  child: GoogleMap(
                    initialCameraPosition: kGoogle,
                    gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>[
                      Factory<OneSequenceGestureRecognizer>(
                            () => EagerGestureRecognizer(),
                      ),
                    ].toSet(),
                    // markers: Set<Marker>.of(homePageController.markers),
                    // markers: Set<Marker>.of(markers),
                    mapType: MapType.normal,
                    markers: Set<Marker>.of(markers),
                    myLocationEnabled: false,
                    compassEnabled: true,
                    zoomGesturesEnabled: true,
                    tiltGesturesEnabled: true,
                    zoomControlsEnabled: true,
                    onMapCreated: (controller) {
                      setState(() {
                        mapController = controller;
                      });
                    },
                  ),
                ),
              ],
            ),
          ),
          Container(
            height: 140,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10)
            ),
            child: PageView.builder(
              controller: pageController,
              onPageChanged: (value) {
                print(value);
                mapController
                    .animateCamera(
                  CameraUpdate.newCameraPosition(
                    CameraPosition(
                      target: LatLng(
                        double.parse(eventAllList[value]["latitude"] ??
                            "0"),
                        double.parse(eventAllList[value]["longtitude"] ??
                            ""),
                      ),
                      zoom: 12,
                    ),
                  ),
                )
                    .then((val) {
                  setState(() {});
                });
              },
              scrollDirection: Axis.horizontal,
              itemCount: eventAllList.length,
              itemBuilder: (context, index) {
              return conference(eventAllList, index);
            },),
          ),

        ],
      ),
    );
  }

  Widget conference(event, i) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
          Future.delayed(Duration(seconds: 1), () {
            Get.to(() => EventsDetails(eid: event[i]["event_id"]),
                duration: Duration.zero);
          });
        },
        child: Container(
          // width: width,
          margin: EdgeInsets.symmetric(vertical: 6),
          decoration: BoxDecoration(
              color: notifire.containercolore,
              borderRadius: const BorderRadius.all(Radius.circular(10)),
              border: Border.all(color: notifire.bordercolore)),
          child: Padding(
            padding:
                const EdgeInsets.only(left: 8, right: 6, bottom: 5, top: 5),
            child: Row(children: [
              Container(
                  width: width / 5,
                  height: height / 8,
                  decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  child: ClipRRect(
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                    child: FadeInImage.assetNetwork(
                        fadeInCurve: Curves.easeInCirc,
                        placeholder: "image/skeleton.gif",
                        fit: BoxFit.cover,
                        image: Config.base_url + event[i]["event_img"]),
                  )),
              Column(children: [
                SizedBox(height: height / 200),
                Row(
                  children: [
                    SizedBox(width: width / 50),
                    Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            event[i]["event_sdate"],
                            style: TextStyle(
                                fontFamily: 'Gilroy Medium',
                                color: const Color(0xff4A43EC),
                                fontSize: 13,
                                fontWeight: FontWeight.w600),
                          ),
                          SizedBox(height: Get.height * 0.01),
                          SizedBox(
                            width: Get.width * 0.60,
                            child: Text(
                              event[i]["event_title"],
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  fontFamily: 'Gilroy Medium',
                                  color: notifire.textcolor,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600),
                            ),
                          ),
                          SizedBox(height: Get.height * 0.01),
                          Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Image.asset("image/location.png",
                                    height: height / 50),
                                SizedBox(width: Get.width * 0.01),
                                SizedBox(
                                  width: Get.width * 0.55,
                                  child: Text(
                                    event[i]["event_address"],
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                        fontFamily: 'Gilroy Medium',
                                        color: Colors.grey,
                                        fontSize: 13),
                                  ),
                                ),
                              ]),
                        ]),
                  ],
                ),
                SizedBox(height: height / 80),
              ])
            ]),
          ),
        ),
      ),
    );
  }

  final Set<Marker> markers = Set();

  getmarkers() async {
    final Uint8List markIcon = await getImages("image/Pin.png", 80);
    print("+ + + + +${eventAllList.length}");
    for (var i = 0;
    i < eventAllList.length;
    i++) {
      markers.add(Marker(
        //add first marker
        markerId: MarkerId(i.toString()),
        position: LatLng(
          double.parse(eventAllList[i]["latitude"] ??
              "0"),
          double.parse(eventAllList[i]["longtitude"] ??
              "0"),
        ),
        icon: BitmapDescriptor.fromBytes(markIcon), //position of marker

        onTap: () {
          print(i.toString());
          // homePageController.updateMapPosition(index: i);
        },
      ));
    }
  }
  PageController pageController = PageController();
  updateMapPosition({int? index}) {
    pageController.animateToPage(index ?? 0,
        duration: Duration(seconds: 1), curve: Curves.decelerate);
    setState(() {

    });
  }
}
