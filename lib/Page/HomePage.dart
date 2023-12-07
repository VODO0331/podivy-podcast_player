import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'dart:developer' as dev show log;
import 'package:podivy/widget/UserAvatar.dart';
import 'package:podivy/widget/carousel.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 100),
      child: Column(
        children: [
          appBar(),
          const Divider(
            thickness: 2,
            color: Color.fromARGB(123, 255, 255, 255),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: MyCarousel(),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 30),
            child: Divider(
              thickness: 0.5,
              color: Color.fromARGB(137, 65, 65, 65),
            ),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: <Widget>[
                cusButton(),
                cusButton(),
                cusButton(),
                cusButton(),
                cusButton(),
                cusButton(),
                cusButton(),
                cusButton(),
                cusButton(),
                cusButton(),
              ],
            ),
          ),
          Expanded(
            child: GridView.count(
              scrollDirection: Axis.horizontal,
              crossAxisCount: 2,
              childAspectRatio: 1.0,
              children: const <Widget>[
                Icon(Icons.home),
                Icon(Icons.ac_unit),
                Icon(Icons.search),
                Icon(Icons.settings),
              ],
            ),
          )
        ],
      ),
    );
  }
}

Widget cusButton() {
  return Padding(
    padding: EdgeInsets.symmetric(horizontal: 3),
    child: TextButton(
        style: ButtonStyle(
            backgroundColor:
                MaterialStateProperty.all(const Color(0xFFABC4AA))),
        onPressed: () {},
        child: const Text('類型')),
  );
}

Widget appBar() {
  return Flex(
    direction: Axis.horizontal,
    children: [
      Expanded(
        flex: 2,
        child: GestureDetector(
          onTap: () {
            dev.log('open user page');
          },
          child: Stack(alignment: Alignment.centerLeft, children: [
            SvgPicture.asset(
              "images/homePage/userBackground.svg",
              height: 40.h,
            ),
            Align(
                alignment: Alignment.center,
                child: UserAvatar(
                  user: Image.asset("images/userPic/people1.png"),
                  radius: 17,
                ))
          ]),
        ),
      ),
      Expanded(
        flex: 7,
        child: Padding(
          padding: const EdgeInsets.only(right: 8.0),
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
            onPressed: () {
              Get.toNamed('/search');
            },
          ),
        ),
      )
    ],
  );
}
