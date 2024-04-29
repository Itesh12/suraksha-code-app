import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:user/src/screens/dashboard/ctrl_dashboard.dart';
import 'package:user/src/screens/safety_qr/sr_safety_qr.dart';
import 'package:user/utils/Images.dart';
import 'package:user/utils/color.dart';
import 'package:user/utils/colornotifire.dart';

class DashboardScreen extends StatelessWidget {
  DashboardScreen({Key? key}) : super(key: key);

  final DashboardController c = Get.put(DashboardController());

  @override
  Widget build(BuildContext context) {
    c.notifire = Provider.of<ColorNotifire>(context, listen: true);

    return Obx(() {
      return PopScope(
        onPopInvoked: (didPop) => c.handleWillPop,
        child: Scaffold(
            floatingActionButton: FloatingActionButton(
              backgroundColor: buttonColor,
              onPressed: () {
                Get.to(() => SafetyQrScreen());
              },
              child: const Icon(Icons.qr_code),
            ),
            bottomNavigationBar: BottomNavigationBar(
                type: BottomNavigationBarType.fixed,
                unselectedItemColor: c.notifire.bottommenucolore,
                backgroundColor: c.notifire.backgrounde,
                selectedLabelStyle: const TextStyle(
                  fontFamily: 'Gilroy_Medium',
                  fontWeight: FontWeight.w500,
                ),
                fixedColor: buttonColor,
                unselectedFontSize: 13,
                selectedFontSize: 13,
                unselectedLabelStyle:
                    const TextStyle(fontFamily: 'Gilroy_Medium'),
                currentIndex: c.selectedIndex.value,
                showSelectedLabels: true,
                showUnselectedLabels: true,
                items: [
                  BottomNavigationBarItem(
                      icon: Image.asset(Images.home,
                          color: c.selectedIndex.value == 0
                              ? buttonColor
                              : c.notifire.bottommenucolore,
                          height: MediaQuery.of(context).size.height / 35),
                      label: 'Explore'.tr),
                  BottomNavigationBarItem(
                      icon: Image.asset(Images.search,
                          color: c.selectedIndex.value == 1
                              ? buttonColor
                              : c.notifire.bottommenucolore,
                          height: MediaQuery.of(context).size.height / 33),
                      label: 'Map'.tr),
                  BottomNavigationBarItem(
                      icon: Image.asset(Images.calendar,
                          color: c.selectedIndex.value == 2
                              ? buttonColor
                              : c.notifire.bottommenucolore,
                          height: MediaQuery.of(context).size.height / 35),
                      label: 'Booking'.tr),
                  BottomNavigationBarItem(
                    icon: Image.asset(Images.rectangle,
                        color: c.selectedIndex.value == 3
                            ? buttonColor
                            : c.notifire.bottommenucolore,
                        height: MediaQuery.of(context).size.height / 35),
                    label: 'Favorite'.tr,
                  ),
                  BottomNavigationBarItem(
                    icon: Image.asset(Images.user,
                        color: c.selectedIndex.value == 4
                            ? buttonColor
                            : c.notifire.bottommenucolore,
                        height: MediaQuery.of(context).size.height / 35),
                    label: 'Profile'.tr,
                  ),
                ],
                onTap: (index) {
                  c.selectedIndex.value = index;
                }),
            body: c.pageOption[c.selectedIndex.value]),
      );
    });
  }
}
