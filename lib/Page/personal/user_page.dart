import 'package:flutter/material.dart';
import 'package:modify_widget_repository/modify_widget_repository.dart';
import 'package:podivy/widget/drawer.dart';
import 'package:podivy/widget/user_avatar.dart';
import 'package:get/get.dart';
class UserPage extends StatelessWidget {
  const UserPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const MyDrawer(),
      backgroundColor: const Color.fromARGB(221, 15, 20, 15),
      body: Column(children: [
        Stack(
          children: [
            Image.asset(
              'images/background/userPageBackGround.jpg',
              width: double.infinity,
              height: 280.h,
              fit: BoxFit.cover,
              cacheHeight: 100,
              cacheWidth: 100,
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
                      isNetwork: false,
                      color: Color(0xFFABC4AA),
                      borderThickness: 65,
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
        Padding(
          padding:const EdgeInsets.all(15.0),
          child: Column(
            children: [
              ListTile(
                title: Text(
                  'Name : UserName',
                  style: TextStyle(fontSize: ScreenUtil().setSp(18)),
                ),
              ),
              const Divider(),
              ListTile(
                title: Text(
                  '電子郵件 : exmple@gmail.com',
                  style: TextStyle(fontSize: ScreenUtil().setSp(18)),
                ),
              ),
              const Divider(),
            ],
          ),
        )
      ]),
    );
  }
}
