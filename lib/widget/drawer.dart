import 'dart:convert';

import 'package:authentication_repository/authentication_repository.dart';
import 'package:firestore_service_repository/firestore_service_repository.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:modify_widget_repository/modify_widget_repository.dart';
import 'package:podivy/util/dialogs/logout_dialog.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final InformationController userController = Get.find();
    return Drawer(
      backgroundColor: Get.isDarkMode
          ? null
          : Theme.of(context).colorScheme.primaryContainer,
      child: Stack(
        children: [
          _buildBackgroundImages(),
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 8, 8, 60),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildUserProfile(userController),
                SizedBox(height: 30.h),
                _buildDrawerItems(),
                const Expanded(child: SizedBox()),
                _buildLogoutButton(context),
                _buildDivider(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBackgroundImages() {
    return Stack(
      children: [
        Align(
          alignment: Alignment.topRight,
          child: _buildVineImage("assets/images/drawer/vine1.png"),
        ),
        Align(
          alignment: Alignment.bottomRight,
          child: _buildVineImage("assets/images/drawer/vine2.png"),
        ),
      ],
    );
  }

  Widget _buildVineImage(String imagePath) {
    return Image.asset(
      imagePath,
      width: 200.r,
      height: 190.r,
      cacheHeight: 250.r.toInt(),
      cacheWidth: 240.r.toInt(),
      fit: BoxFit.cover,
      color: Theme.of(Get.context!).colorScheme.onBackground.withOpacity(0.7),
    );
  }

  Widget _buildUserProfile(InformationController userController) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 90.h),
        GestureDetector(
          onTap: () => Get.toNamed('/user'),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Obx(() {
              final UserInfo data = userController.userData;

              if (data.img != '') {
                return CircleAvatar(
                  backgroundImage: MemoryImage(base64Decode(data.img)),
                  radius: 35.r,
                );
              } else {
                return const CircularProgressIndicator();
              }
            }),
          ),
        ),
        SizedBox(height: 12.h),
        SizedBox(
            width: 200.r,
            child: Obx(() {
              // if (userController.userData != null) {/
              return Text(
                userController.userData.name,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              );
              // } else {
              //   return const Text("loading...");
              // }
            })),
        SizedBox(height: 12.h),
        Container(
          height: 0.6.h,
          width: 200.w,
          decoration: const BoxDecoration(
            color: Colors.grey,
            boxShadow: [
              BoxShadow(
                color: Colors.grey,
                spreadRadius: 1,
                blurRadius: 4,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDivider() {
    return Divider(
      indent: 10.w,
      endIndent: 70.w,
      height: 1,
      thickness: 2.0,
      color: ThemeData.light().dividerColor,
    );
  }

  Widget _buildDrawerItems() {
    return Column(
      children: [
        DrawerItem(
            icon: Icons.mic,
            title: 'follow'.tr,
            tileOption: () {
              Get.offAndToNamed("/followed");
            }),
        DrawerItem(
            icon: Icons.access_alarm_rounded,
            title: 'test2',
            tileOption: () {}),
        DrawerItem(
            icon: Icons.settings,
            title: 'setting'.tr,
            tileOption: () {
              
              Get.offAllNamed(('/setting'));
            }),
      ],
    );
  }

  Widget _buildLogoutButton(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: ListTile(
        leading: const Icon(Icons.logout, size: 35, color: Colors.red),
        title: Text(
          "logOut".tr,
          style: const TextStyle(color: Colors.red),
        ),
        onTap: () async {
          final result = await showLogOutDialog(context);
          if (result) {
            Get.delete<InformationController>();
            Get.delete<ListManagement>();
            context.mounted
                ? context.read<AuthBloc>().add(const AuthEventLogOut())
                : null;
          }
        },
      ),
    );
  }
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
