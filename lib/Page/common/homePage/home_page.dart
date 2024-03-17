import 'dart:convert';

import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:information_management_service/information_management_service.dart';
import 'package:modify_widget_repository/modify_widget_repository.dart';

//節省token
// import 'package:podivy/widget/carousel.dart';

// import 'dart:developer' as dev show log;

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final InformationController userController = Get.find();
    return Padding(
      padding: const EdgeInsets.only(top: 100).h,
      child: Column(
        children: [
          appBar(userController),
          const Divider(
            thickness: 2,
            color: Color.fromARGB(123, 255, 255, 255),
          ),
          // Padding(
          //   padding: const EdgeInsets.symmetric(vertical: 10).h,
          //   child: const LatestPodcast(),
          // ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30).w,
            child: const Divider(
              thickness: 0.5,
              color: Color.fromARGB(255, 255, 255, 255),
            ),
          ),
          //  ExploreContent(),
        ],
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
                    color: Theme.of(Get.context!).colorScheme.background,
                    // border: Border.all(
                    //     color: Theme.of(Get.context!).colorScheme.onBackground,
                    //     width: 1.5),
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
                  color: Theme.of(Get.context!).colorScheme.primary,
                ),
              ),
            )
            // ElevatedButton.icon(
            //   style: ButtonStyle(
            //     shadowColor: MaterialStateProperty.all(
            //       Theme.of(Get.context!)
            //           .colorScheme
            //           .onBackground
            //           .withOpacity(0.7),
            //     ),
            //     alignment: Alignment.centerLeft,
            //     // backgroundColor: MaterialStateProperty.all(
            //     //   Theme.of(Get.context!)
            //     //       .colorScheme
            //     //       .onBackground
            //     //       .withOpacity(0.7),

            //     // ),
            //     shape: MaterialStateProperty.all(
            //       RoundedRectangleBorder(
            //         borderRadius: BorderRadius.circular(20),
            //       ),
            //     ),
            //   ),
            //   icon: Icon(
            //     Icons.search,
            //     color: Theme.of(Get.context!).colorScheme.primary,
            //   ),
            //   label: const Text(""),
            //   onPressed: () async {
            //     Get.toNamed('/search');
            //     // await getAccessToken();
            //   },
            // ),
            ),
      )
    ],
  );
}
