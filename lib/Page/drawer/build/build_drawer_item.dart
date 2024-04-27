import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:modify_widget_repository/modify_widget_repository.dart';

Widget buildDrawerItems() {
  // final myAudioPlayer = Get.find<MyAudioPlayer>();
  return Column(
    children: [
      DrawerItem(
          icon: Icons.mic,
          title: 'follow'.tr,
          tileOption: () {
            Get.offAndToNamed("/follow");
          }),
      DrawerItem(
          icon: Icons.settings,
          title: 'setting'.tr,
          tileOption: () {
            Get.offAndToNamed(('/setting'));
          }),
    ],
  );
}

class DrawerItem extends StatelessWidget {
  const DrawerItem({
    Key? key,
    required this.icon,
    required this.title,
    required this.tileOption,
  }) : super(key: key);

  final IconData icon;
  final String title;
  final Function()? tileOption;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          leading: Icon(icon, size: 25.w),
          title: Text(title),
          onTap: tileOption,
        ),
        Divider(
          height: 1,
          thickness: 1.0,
          indent: 10.w,
          endIndent: 30.w,
          color: ThemeData().dividerColor,
        ),
      ],
    );
  }
}
