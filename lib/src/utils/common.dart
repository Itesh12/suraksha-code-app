import 'package:shared_preferences/shared_preferences.dart';
import 'package:user/utils/colornotifire.dart';

class Common{

  late ColorNotifire notifire;

  getDarkModePreviousState() async {
    final prefs = await SharedPreferences.getInstance();
    bool? previusstate = prefs.getBool("setIsDark");
    if (previusstate == null) {
      notifire.setIsDark = false;
    } else {
      notifire.setIsDark = previusstate;
    }
  }

}