import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:modify_widget_repository/modify_widget_repository.dart';
//節省token
// import 'package:podivy/widget/carousel.dart';
import 'package:podivy/widget/user_avatar.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 100).h,
      child: Column(
        children: [
          appBar(),
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

Widget appBar() {
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
              "images/homePage/userBackground.svg",
              height: 40.h,
            ),
            const Align(
              alignment: Alignment.center,
              child: UserAvatar(
                imgPath: "images/userPic/people1.png",
                radius: 17,
                isNetwork: false,
              ),
            )
          ]),
        ),
      ),
      Expanded(
        flex: 7,
        child: Padding(
          padding: const EdgeInsets.only(right: 8.0).w,
          child: ElevatedButton.icon(
            style: ButtonStyle(
              alignment: Alignment.centerLeft,
              backgroundColor: MaterialStateProperty.all(Colors.black45),
              shape: MaterialStateProperty.all(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
            icon: const Icon(
              Icons.search,
              color: Colors.white,
            ),
            label: const Text(""),
            onPressed: () async {
              Get.toNamed('/search');
              // await getAccessToken();
            },
          ),
        ),
      )
    ],
  );
}

