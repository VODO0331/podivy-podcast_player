import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:glass/glass.dart';
import 'package:podivy/widget/userAvatar.dart';

class UserPage extends StatelessWidget {
  const UserPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(221, 15, 20, 15),
      body: Column(children: [
        Stack(
          children: [
            Image.asset(
              'images/background/userPageBackGround.jpg',
              width: double.infinity,
              height: 280.h,
              fit: BoxFit.cover,
            ),
            SizedBox(
              width: double.infinity,
              height: 320.h,
            ).asGlass(),
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 60, 12, 0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        iconSize: 35.r,
                        onPressed: () {
                          Get.back();
                        },
                        icon: const Icon(
                          Icons.arrow_back_ios_rounded,
                        ),
                      ),
                      IconButton(
                        iconSize: 35.r,
                        onPressed: () {},
                        icon: const Icon(Icons.more_vert_sharp),
                      ),
                    ],
                  ),
                  const Divider(
                    color: Colors.white12,
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 20),
                    child: UserAvatar(
                      imgPath: 'images/userPic/people1.png',
                      radius: 60,
                      boraderthinness: 65,
                      color: Color(0xFFABC4AA),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
        Padding(
          padding: EdgeInsets.all(15.0),
          child: Column(
            children: [
              ListTile(
                title: Text(
                  'Name : UserName',
                  style: TextStyle(fontSize: ScreenUtil().setSp(18)),
                ),
              ),
              Divider(),
              ListTile(
                title: Text(
                  '電子郵件 : exmple@gmail.com',
                  style: TextStyle(fontSize: ScreenUtil().setSp(18)),
                ),
              ),
              Divider(),
            ],
          ),
        )
      ]),
    );
  }
}
