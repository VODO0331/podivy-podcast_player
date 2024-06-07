import 'dart:convert';

import 'package:firestore_service_repository/firestore_service_repository.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:modify_widget_repository/modify_widget_repository.dart';

import 'build/build_carousel/build_carousel.dart';

import 'build/build_explore/build_explore_content.dart';

//節省token
// import 'package:podivy/widget/carousel.dart';

// import 'dart:developer' as dev show log;
typedef OpenDrawerCallBack = void Function();
class HomePage extends StatelessWidget {
  final FirestoreServiceProvider fsp;
final OpenDrawerCallBack openDrawer;
  const HomePage({
    super.key,
    required this.fsp,
    required this.openDrawer,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      right: false,
      left: false,
      child: Padding(
        padding: const EdgeInsets.only(top: 30).h,
        child: Column(
          children: [
            appBar(context),
            const Divider(
              thickness: 2,
              color: Color.fromARGB(123, 255, 255, 255),
            ),
            Padding(
                padding: const EdgeInsets.symmetric(vertical: 5).h,
                child: SizedBox(
                  height: 220.r,
                  child: BuildCarousel(
                    fsp: fsp,
                  ),
                )),
            Image.asset(
              Get.isDarkMode
                  ? 'assets/images/podchaser/bow.png'
                  : 'assets/images/podchaser/wob.png',
              height: 30.r,
              width: 180.r,
              cacheHeight: 30.r.toInt(),
              cacheWidth: 180.r.toInt(),
              fit: BoxFit.cover,
            ),
            Divider(
              thickness: 0.5,
              indent: 30.r,
              endIndent: 30.r,
              color: const Color.fromARGB(255, 255, 255, 255),
            ),
            ExploreContent(
              fsp: fsp,
            ),
          ],
        ),
      ),
    );
  }

  Widget appBar(BuildContext context) {
    return Flex(
      direction: Axis.horizontal,
      children: [
        Expanded(
          flex: 2,
          child: GestureDetector(
            onTap: () {
              openDrawer();
            },
            child: Stack(alignment: Alignment.centerLeft, children: [
              SvgPicture.asset(
                "assets/images/homePage/userBackground.svg",
                height: 40.h,
              ),
              Align(
                alignment: Alignment.center,
                child: Obx(() {
                  final UserInfo data = fsp.info.userData;

                  if (data.img != "") {
                    return CircleAvatar(
                      backgroundImage: ResizeImage(
                          MemoryImage(base64Decode(data.img)),
                          height: 50,
                          width: 50),
                      radius: 15.r,
                    );
                  } else {
                    return Center(
                      child: SizedBox(
                          height: 20.r,
                          width: 20.r,
                          child: const CircularProgressIndicator(
                            strokeWidth: 1,
                          )),
                    );
                  }
                }),
              )
            ]),
          ),
        ),
        Expanded(
          flex: 7,
          child: Padding(
              padding: const EdgeInsets.only(right: 8.0).w,
              child: GestureDetector(
                onTap: () => Get.toNamed('/search'),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6).r,
                  alignment: Alignment.centerLeft,
                  decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.background,
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: const [
                        BoxShadow(
                            color: Colors.grey,
                            blurRadius: 10,
                            // spreadRadius: 0.1,
                            offset: Offset(2, 3))
                      ]),
                  child: Icon(
                    Icons.search,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              )),
        )
      ],
    );
  }
}
