import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:user/src/model/categoryModel.dart';
import 'package:user/src/model/help_line_model.dart';
import 'package:user/src/screens/safety_qr/ctrl_safety_qr.dart';
import 'package:user/utils/Images.dart';
import 'package:user/utils/color.dart';
import 'package:user/utils/colornotifire.dart';
import 'package:carousel_slider/carousel_slider.dart';

class SafetyQrScreen extends StatelessWidget {
  SafetyQrScreen({Key? key}) : super(key: key);

  final SafetyQrController c = Get.put(SafetyQrController());

  @override
  Widget build(BuildContext context) {
    c.notifire = Provider.of<ColorNotifire>(context, listen: true);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: buttonColor,
        title: Text(
          'Suraksha Code',
          style: context.textTheme.titleLarge!.copyWith(color: Colors.white),
        ),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CarouselSlider.builder(
              itemCount: 3,
              itemBuilder:
                  (BuildContext context, int itemIndex, int pageViewIndex) {
                return Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        buttonColor,
                        proColor,
                      ],
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Know About us',
                                  style: context.textTheme.headlineMedium!
                                      .copyWith(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  'sit amet, consectetur, adipisci velit, sed quia non num.sit amet, consectetur, adipisci velit, sed quia non num.',
                                  style: context.textTheme.titleMedium!
                                      .copyWith(color: Colors.white),
                                ),
                              ],
                            ),
                          ),
                          Image.asset(
                            Images.knowQr,
                            width: 120,
                            height: 100,
                            fit: BoxFit.cover,
                          ),
                        ],
                      ),
                      Text(
                        'Learn More',
                        style: context.textTheme.titleLarge!.copyWith(
                          color: Colors.white,
                          decoration: TextDecoration.underline,
                          decorationStyle: TextDecorationStyle.dotted,
                        ),
                      )
                    ],
                  ).paddingSymmetric(horizontal: 20, vertical: 20),
                );
              },
              options: CarouselOptions(
                height: 200,
                aspectRatio: 16 / 9,
                viewportFraction: 1,
                initialPage: 0,
                enableInfiniteScroll: true,
                reverse: false,
                autoPlay: true,
                autoPlayInterval: Duration(seconds: 3),
                autoPlayAnimationDuration: Duration(milliseconds: 800),
                autoPlayCurve: Curves.fastOutSlowIn,
                enlargeCenterPage: true,
                // enlargeFactor: 0.5,
                scrollDirection: Axis.horizontal,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Categories',
              style: context.textTheme.titleLarge!.copyWith(
                color: c.notifire.textcolor,
                fontWeight: FontWeight.bold,
                decoration: TextDecoration.underline,
                decorationStyle: TextDecorationStyle.dotted,
              ),
            ),
            const SizedBox(height: 20),
            Obx(() {
              c.categorySelectedIndex.value;
              return GridView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: c.categoryList.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4),
                itemBuilder: (context, index) {
                  CategoryModel data = c.categoryList[index];
                  return InkWell(
                    onTap: () {
                      c.categorySelectedIndex.value = index;
                    },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 10),
                          decoration: BoxDecoration(
                            color: c.categorySelectedIndex.value == index
                                ? buttonColor
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: buttonColor,
                            ),
                          ),
                          child: Image.asset(
                            data.categoryIcon,
                            height: 30,
                            width: 30,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          data.categoryName,
                          style: context.textTheme.titleMedium!.copyWith(
                            color: c.notifire.textcolor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              );
            }),
            const SizedBox(height: 20),
            Text(
              'Scanner Info',
              style: context.textTheme.titleLarge!.copyWith(
                color: c.notifire.textcolor,
                fontWeight: FontWeight.bold,
                decoration: TextDecoration.underline,
                decorationStyle: TextDecorationStyle.dotted,
              ),
            ),
            const SizedBox(height: 20),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Image.asset(
                  Images.qrScanner,
                  height: 200,
                  width: 200,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    InkWell(
                      borderRadius: BorderRadius.circular(10),
                      onTap: () {},
                      child: Container(
                        height: 50,
                        width: 150,
                        decoration: BoxDecoration(
                          color: buttonColor,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Center(
                          child: Text(
                            'Scan Me',
                            style: context.textTheme.titleLarge!.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      'For multiple use case*',
                      style: context.textTheme.titleMedium!.copyWith(
                        color: c.notifire.textcolor,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20),
            Text(
              'Help - Line',
              style: context.textTheme.titleLarge!.copyWith(
                color: c.notifire.textcolor,
                fontWeight: FontWeight.bold,
                decoration: TextDecoration.underline,
                decorationStyle: TextDecorationStyle.dotted,
              ),
            ),
            const SizedBox(height: 20),
            ListView.separated(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  HelpLineModel data = c.helpLineList[index];
                  return Stack(
                    children: [
                      Card(
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Card(
                              elevation: 2,
                              margin: EdgeInsets.zero,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 20),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  gradient: LinearGradient(
                                    colors: [
                                      buttonColor,
                                      proColor,
                                    ],
                                  ),
                                ),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      data.title,
                                      style: context.textTheme.titleLarge!
                                          .copyWith(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Service Offered:",
                                        style: context.textTheme.titleMedium!
                                            .copyWith(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 5),
                                      Row(
                                        children: [
                                          for (var i = 0;
                                              i < data.services.length;
                                              i++) ...[
                                            Text(
                                              data.services[i],
                                              style: context
                                                  .textTheme.titleSmall!
                                                  .copyWith(
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            if (i != data.services.length - 1)
                                              Text(
                                                " | ",
                                                style: context
                                                    .textTheme.titleSmall!
                                                    .copyWith(
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ), // Add "/" if not the last item
                                          ],
                                        ],
                                      ).paddingOnly(left: 10),
                                      const SizedBox(height: 5),
                                      Row(
                                        children: [
                                          Text(
                                            "Languages: ",
                                            style: context.textTheme.titleSmall!
                                                .copyWith(
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Row(
                                            children: [
                                              for (var i = 0;
                                                  i < data.languages.length;
                                                  i++) ...[
                                                Text(
                                                  data.languages[i],
                                                  style: context
                                                      .textTheme.titleSmall!
                                                      .copyWith(
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                if (i !=
                                                    data.languages.length - 1)
                                                  Text(
                                                    ", ",
                                                    style: context
                                                        .textTheme.titleSmall!
                                                        .copyWith(
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ), // Add "/" if not the last item
                                              ],
                                            ],
                                          ),
                                        ],
                                      ).paddingOnly(left: 10),
                                    ],
                                  ),
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(5),
                                      decoration: BoxDecoration(
                                        border: Border.all(color: Colors.black),
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: const Icon(
                                        Icons.phone,
                                        color: Colors.green,
                                      ),
                                    ),
                                    Text(
                                      "Call: ${data.number}",
                                      style: context.textTheme.titleLarge!
                                          .copyWith(
                                        color: Colors.red,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ).paddingSymmetric(horizontal: 10, vertical: 15),
                          ],
                        ),
                      ),
                      Align(
                        alignment: Alignment.topRight,
                        child: Image.asset(
                          data.image,
                          height: 80,
                          width: 80,
                        ),
                      ),
                    ],
                  );
                },
                separatorBuilder: (context, index) {
                  return const SizedBox(height: 10);
                },
                itemCount: c.helpLineList.length)
          ],
        ).paddingSymmetric(horizontal: 16, vertical: 20),
      ),
    );
  }
}
