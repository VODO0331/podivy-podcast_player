
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:podivy/widget/UserAvatar.dart';



class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Stack(
    children: [
      Align(
        alignment: Alignment.topRight,
        child: Image.asset(
          "images/drawer/vine1.png",
          width: 200.0.w,
          height: 200.0.h,
          fit: BoxFit.cover,
          color: const Color.fromARGB(255, 146, 146, 146),
        ),
      ),
      Align(
        alignment: Alignment.bottomRight,
        child: Image.asset(
          "images/drawer/vine2.png",
          width: 150.0.w,
          height: 150.0.h,
          fit: BoxFit.cover,
          color: const Color.fromARGB(255, 146, 146, 146),
        ),
      ),
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 90.h,
            ),
            UserAvatar(user: Image.asset("images/drawer/people1.png"), radius: 27),
            SizedBox(
              height: 12.h,
            ),
            const Text('User Name'),
            SizedBox(
              height: 12.h,
            ),
            Container(
              height: 0.6.h,
              width: 200.w,
              decoration: const BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.white,
                    spreadRadius: 1,
                    blurRadius: 4,
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 25.h,
            ),
            ListTile(
              leading: Icon(
                Icons.settings,
                size: 25.w,
              ),
              title: Text("設定"),
              //onTap: () { },
            ),
            Divider(
              height: 1,
              thickness: 2.0,
            ),
            ListTile(
              leading: Icon(
                Icons.account_box,
                size: 25.w,
              ),
              title: Text("選項一"),
              //onTap: () { },
            ),
            Divider(
              height: 1,
              thickness: 2.0,
            ),
            ListTile(
              leading: Icon(
                Icons.alarm,
                size: 25.w,
              ),
              title: Text("選項2"),
              //onTap: () { },
            ),
            Divider(
              height: 1,
              thickness: 2.0,
            ),
          ],
        ),
      ),
    ],
  ));
  }
}