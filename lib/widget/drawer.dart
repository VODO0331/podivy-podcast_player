import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:podivy/service/auth/bloc/authBLOC.dart';
import 'package:podivy/service/auth/bloc/authEvent.dart';
import 'package:podivy/util/dialogs/logout_dialog.dart';
import 'package:podivy/widget/userAvatar.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Stack(
        children: [
          _buildBackgroundImages(),
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 8, 8, 60),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildUserProfile(),
                SizedBox(height: 12.h),
                _buildDivider(),
                SizedBox(height: 25.h),
                _buildDrawerItems(),
                Expanded(child: Container()),
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
          child: _buildVineImage("images/drawer/vine1.png", 200.0),
        ),
        Align(
          alignment: Alignment.bottomRight,
          child: _buildVineImage("images/drawer/vine2.png", 150.0),
        ),
      ],
    );
  }

  Widget _buildVineImage(String imagePath, double size) {
    return Image.asset(
      imagePath,
      width: size.w,
      height: size.h,
      fit: BoxFit.cover,
      color: const Color.fromARGB(255, 146, 146, 146),
    );
  }

  Widget _buildUserProfile() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 90.h),
        const UserAvatar(
          imgPath: "images/userPic/people1.png",
          radius: 27,
          isNetwork: false,
        ),
        SizedBox(height: 12.h),
        const Text(
          'User Name',
          overflow: TextOverflow.ellipsis,
        ),
        SizedBox(height: 12.h),
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
      ],
    );
  }

  Widget _buildDivider() {
    return Divider(
      indent: ScreenUtil().setWidth(10),
      endIndent: ScreenUtil().setWidth(120),
      height: 1,
      thickness: 2.0,
      color: Colors.white10,
    );
  }

  Widget _buildDrawerItems() {
    return Column(
      children: [
        DrawerItem(icon: Icons.mic, title: '追隨', tileOption: () {Get.toNamed("/followed");}),
        DrawerItem(icon: Icons.access_alarm_rounded, title: 'test2', tileOption: () {}),
        DrawerItem(icon: Icons.settings, title: '設定', tileOption: () {}),
      ],
    );
  }

  Widget _buildLogoutButton(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: ListTile(
        leading: const Icon(Icons.logout, size: 35, color: Colors.red),
        title: const Text(
          "登出",
          style: TextStyle(color: Colors.red),
        ),
        onTap: () async {
          final result = await showLogOutDialog(context);
          if (result) {
            context.read<AuthBloc>().add(const AuthEventLogOut());
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

    // Add any other parameters you may need
  }) : super(key: key);

  final IconData icon;
  final String title;
  final Function()? tileOption;
  // Add any other parameters you may need

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          leading: Icon(icon, size: 25.w),
          title: Text(title),
          onTap: tileOption,
          // Add any other ListTile properties or callbacks you need
        ),
        const Divider(
          height: 1,
          thickness: 2.0,
          color: Color(0x0DFFFFFF),
        ),
      ],
    );
  }
}

