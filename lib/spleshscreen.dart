// ignore_for_file: avoid_print

import 'dart:async';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:user/Controller/AuthController.dart';
import 'package:user/Bottombar.dart';
import 'package:user/home/home.dart';
import 'package:user/src/screens/dashboard/sr_dashboard.dart';
import 'package:user/utils/AppWidget.dart';
import 'package:user/utils/media.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'AppModel/Homedata/HomedataController.dart';
import 'onbonding.dart';
import 'utils/colornotifire.dart';

String long = "", lat = "";

class Spleshscreen extends StatefulWidget {
  const Spleshscreen({Key? key}) : super(key: key);

  @override
  _SpleshscreenState createState() => _SpleshscreenState();
}

class _SpleshscreenState extends State<Spleshscreen> {
  final hData = Get.put(HomeController());

  final x = Get.put(AuthController());
  bool servicestatus = false;
  bool haspermission = false;
  late LocationPermission permission;
  late Position position;

  late StreamSubscription<Position> positionStream;
  @override
  void initState() {
    super.initState();
    checkGps();

    getdarkmodepreviousstate();
    Timer(
        const Duration(seconds: 4),
        () => getData.read("UserLogin") == null
            ? Get.to(() => const Onbonding(), duration: Duration.zero)
            : Get.to(() =>  DashboardScreen(), duration: Duration.zero));
  }

  late ColorNotifire notifire;

  getdarkmodepreviousstate() async {
    x.cCodeApi();
    final prefs = await SharedPreferences.getInstance();
    bool? previusstate = prefs.getBool("setIsDark");
    if (previusstate == null) {
      notifire.setIsDark = false;
    } else {
      notifire.setIsDark = previusstate;
    }
  }

//! permission handel
  checkGps() async {
    servicestatus = await Geolocator.isLocationServiceEnabled();
    if (servicestatus) {
      permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
        } else if (permission == LocationPermission.deniedForever) {
        } else {
          haspermission = true;
        }
      } else {
        haspermission = true;
      }
      if (haspermission) {
        setState(() {});
        getLocation();
      }
    } else {
      print("GPS Service is not enabled, turn on GPS location");
    }
    setState(() {
      //refresh the UI
    });
  }

//! get lat long
  getLocation() async {
    position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    print(position.longitude); //Output: 80.24599079
    print(position.latitude); //Output: 29.6593457

    long = position.longitude.toString();
    lat = position.latitude.toString();
    var latlong = LatLng(position.latitude, position.longitude);
    getAddressFromLatLong(latlong);

    setState(() {});
  }

  Future<void> getAddressFromLatLong(LatLng latLng) async {
    List<Placemark> placemarks =
        await placemarkFromCoordinates(latLng.latitude, latLng.longitude);
    if (placemarks.isNotEmpty) {
      Placemark place = placemarks[0];
      String city = place.locality.toString();
      String country = place.country.toString();

      var currentAddress = city + ((city.isNotEmpty) ? ", " : "") + country;
      save("CurentAdd", currentAddress);
      print(currentAddress);
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    notifire = Provider.of<ColorNotifire>(context, listen: true);
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: notifire.backgrounde,
      body: Center(
        child: Container(
          color: notifire.backgrounde,
          child: Column(
            children: [
              SizedBox(height: height / 2.5),
              Container(
                  color: Colors.transparent,
                  height: height / 7,
                  child: Image.asset("image/getevent.png")),
              SizedBox(height: height / 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Go".tr,
                    style: TextStyle(
                        fontSize: 35,
                        fontFamily: 'Gilroy ExtraBold',
                        color: notifire.gettextcolor),
                  ),
                  Text(
                    "Event".tr,
                    style: TextStyle(
                        fontSize: 35,
                        fontFamily: 'Gilroy ExtraBold',
                        color: notifire.gettext1color),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
