import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:user/src/model/categoryModel.dart';
import 'package:user/src/model/help_line_model.dart';
import 'package:user/utils/Images.dart';
import 'package:user/utils/colornotifire.dart';

class SafetyQrController extends GetxController {
  late ColorNotifire notifire;

  RxList<CategoryModel> categoryList = <CategoryModel>[].obs;
  RxList<HelpLineModel> helpLineList = <HelpLineModel>[].obs;

  RxInt categorySelectedIndex = 0.obs;

  @override
  void onInit() {
    getDarkModePreviousState();

    categoryList.value = [
      CategoryModel(categoryName: 'Car', categoryIcon: Images.boy),
      CategoryModel(categoryName: 'Bike', categoryIcon: ''),
      CategoryModel(categoryName: 'Child', categoryIcon: ''),
      CategoryModel(categoryName: 'Luggage', categoryIcon: ''),
      CategoryModel(categoryName: 'Pet', categoryIcon: ''),
    ];

    helpLineList.value = [
      HelpLineModel(
        languages: ['English', 'Hindi'],
        number: "108",
        services: ['Emergency Support', 'Medical report'],
        title: 'Ambulance Help',
        image: Images.siren,
      ),
      HelpLineModel(
        languages: ['English', 'Hindi'],
        number: "181",
        services: ['Shelter Support', 'Counselling', 'Legal Assistance'],
        title: 'Women Help',
        image: Images.girl,
      ),
      HelpLineModel(
        languages: ['English', 'Hindi'],
        number: "1098",
        services: ['Shelter Support', 'Counselling', 'Education'],
        title: 'Child Help',
        image: Images.boy,
      ),
    ];

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
}
