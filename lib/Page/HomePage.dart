import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'dart:developer' as dev show log;

class HomePage extends StatelessWidget {
  const HomePage({super.key});

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
          const SizedBox(
            height: 20,
          ),
          turnTable(),
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
            dev.log('open user page');
          },
          child: Stack(alignment: Alignment.centerLeft, children: [
            SvgPicture.asset(
              "images/homePage/userBackground.svg",
              height: 40.h,
            ),
            Align(
              alignment: Alignment.center,
              child: CircleAvatar(
                backgroundColor: Colors.white,
                radius: 17.h,
                child: CircleAvatar(
                  radius: 16.h,
                  child: Image.asset("images/drawer/people1.png"),
                ),
              ),
            )
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

Widget podcastLatestContent() {
  return ListView(
    padding: EdgeInsets.zero,
    semanticChildCount: 3,
    children: const [
      Padding(
        padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
        child: Text(
          'tile1',
          style: TextStyle(fontSize: 17.0),
        ),
      ),
      Padding(
        padding: EdgeInsets.symmetric(horizontal: 40.0),
        child: Divider(
          thickness: 1,
          color: Colors.white,
        ),
      ),
      Padding(
        padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
        child: Text(
          'tile1',
          style: TextStyle(fontSize: 17.0),
        ),
      ),
      Padding(
        padding: EdgeInsets.symmetric(horizontal: 40.0),
        child: Divider(
          thickness: 1,
          color: Colors.white,
        ),
      ),
      Padding(
        padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
        child: Text(
          'tile1',
          style: TextStyle(fontSize: 17.0),
        ),
      ),
    ],
  );
}

Widget turnTable() {
  return Container(
    padding: const EdgeInsets.all(8),
    width: 360.w,
    height: 200.h,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(20),
      color: const Color.fromARGB(160, 73, 57, 34),
      border: Border.all(color: Colors.white70),
    ),
    child: Flex(direction: Axis.horizontal, children: [
      Expanded(
        flex: 3,
        child: Column(
          children: [
            Text('podcaster'),
            SizedBox(
              height: 4.h,
            ),
            //podcaster
            CircleAvatar(
              radius: 55,
              backgroundImage: AssetImage('images/turnTable/record.png'),
              child: CircleAvatar(
                radius: 40,
                child: Image.asset(
                  'images/drawer/people2.png',
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(
              height: 4.h,
            ),
            Row(
              children: [
                Expanded(
                  child: IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.share),
                    constraints:
                        BoxConstraints(maxHeight: 40.h, maxWidth: 40.w),
                  ),
                ),
                Expanded(
                  child: IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.favorite_outline),
                    constraints:
                        BoxConstraints(maxHeight: 40.h, maxWidth: 40.w),
                  ),
                ),
                Expanded(
                  child: IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.notifications_active_outlined),
                    constraints:
                        BoxConstraints(maxHeight: 40.h, maxWidth: 40.w),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
      const VerticalDivider(
        thickness: 1,
        color: Color.fromARGB(255, 237, 186, 145),
      ),
      Expanded(
          flex: 6,
          child: Container(
              width: 200.w,
              height: 165.h,
              decoration: BoxDecoration(
                color: const Color.fromARGB(96, 76, 74, 74),
                border: Border.all(color: Colors.white60),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(5.0),
                  topRight: Radius.circular(16.0),
                  bottomLeft: Radius.circular(5.0),
                  bottomRight: Radius.circular(16.0),
                ),
              ),
              child: podcastLatestContent()))
    ]),
  );
}
