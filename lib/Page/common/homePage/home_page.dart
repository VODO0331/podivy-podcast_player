import 'dart:convert';

import 'package:firestore_service_repository/firestore_service_repository.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:modify_widget_repository/modify_widget_repository.dart';

import 'build/build_carousel.dart';

import 'build/build_explore/build_explore_content.dart';

//節省token
// import 'package:podivy/widget/carousel.dart';

// import 'dart:developer' as dev show log;

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final InformationController userController = Get.find();
    return SafeArea(
      right: false,
      left: false,
      child: Padding(
        padding: const EdgeInsets.only(top: 40).h,
        child: Column(
          children: [
            appBar(userController),
            const Divider(
              thickness: 2,
              color: Color.fromARGB(123, 255, 255, 255),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10).h,
              child:  SizedBox(
                height: 220.r,
                child: BuildCarousel(),
              )
            ),

            Divider(
              thickness: 0.5,
              indent: 30.r,
              endIndent: 30.r,
              color: const Color.fromARGB(255, 255, 255, 255),
            ),
            //佔位
            // Expanded(
            //     child: Container(
            //   color: Colors.amber,
            // ))
            ExploreContent(),
          ],
        ),
      ),
    );
  }
}

Widget appBar(InformationController userController) {
  return Flex(
    direction: Axis.horizontal,
    children: [
      Expanded(
        flex: 2,
        child: GestureDetector(
          onTap: () {
            Get.toNamed('/user');
          },
          child: Stack(alignment: Alignment.centerLeft, children: [
            SvgPicture.asset(
              "assets/images/homePage/userBackground.svg",
              height: 40.h,
            ),
            Align(
                alignment: Alignment.center,
                child: GestureDetector(
                  onTap: () => Get.toNamed('/user'),
                  child: Obx(() {
                    final UserInfo data = userController.userData;

                    if (data.img != "") {
                      return CircleAvatar(
                        backgroundImage: ResizeImage(
                            MemoryImage(base64Decode(data.img)),
                            height: 50,
                            width: 50),
                        radius: 15.r,
                      );
                    } else {
                      return SizedBox(
                          width: 20.r,
                          height: 20.r,
                          child: const CircularProgressIndicator(
                            strokeWidth: 2,
                          ));
                    }
                  }),
                ))
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
                    color: Get.theme.colorScheme.background,
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
                  color: Get.theme.colorScheme.primary,
                ),
              ),
            )
            
            ),
      )
    ],
  );
}
