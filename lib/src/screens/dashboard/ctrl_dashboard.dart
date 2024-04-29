import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:user/Search/SearchPage.dart';
import 'package:user/booking/TicketStatus.dart';
import 'package:user/home/bookmark.dart';
import 'package:user/home/home.dart';
import 'package:user/profile/profile.dart';
import 'package:user/utils/colornotifire.dart';

class DashboardController extends GetxController{
  late ColorNotifire notifire;
  RxInt lastTimeBackButtonWasTapped = 0.obs;
  RxInt exitTimeInMillis = 2000.obs;
  RxInt selectedIndex = 0.obs;
  RxBool isLogin = false.obs;

  final List pageOption = [
    const Home(),
    const SearchPage(),
    const TicketStatusPage(),
    const Bookmark(),
    const Profile(""),
  ];

  @override
  void onInit() {
    getDarkModePreviousState();
    isLogin.value = getData.read("firstLogin") ?? false;
    super.onInit();
  }

  getDarkModePreviousState() async {
    final prefs = await SharedPreferences.getInstance();
    bool? previusstate = prefs.getBool("setIsDark");
    if (previusstate == null) {
      notifire.setIsDark = false;
    } else {
      notifire.setIsDark = previusstate;
    }
  }

  Future<bool> handleWillPop() async {
    final currentTime = DateTime.now().millisecondsSinceEpoch;

    if (lastTimeBackButtonWasTapped.value != 0 &&
        (currentTime - lastTimeBackButtonWasTapped.value) < exitTimeInMillis.value) {
      return true;
    } else {
      lastTimeBackButtonWasTapped.value = DateTime.now().millisecondsSinceEpoch;
      return false;
    }
  }
}