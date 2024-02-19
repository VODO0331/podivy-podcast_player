import 'package:authentication_repository/authentication_repository.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:information_management_service/personal_information_management.dart';
import 'package:modify_widget_repository/modify_widget_repository.dart';
import 'package:podivy/util/dialogs/logout_dialog.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final InformationManagementWithGetX userController = Get.find();
    return Drawer(
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
      cacheHeight: 200,
      cacheWidth: 150,
      fit: BoxFit.cover,
      color: const Color.fromARGB(255, 146, 146, 146),
    );
  }

  Widget _buildUserProfile(InformationManagementWithGetX userController) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 90.h),
        GestureDetector(
          onTap: () => Get.toNamed('/user'),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Obx(() {
              final UserInfo? data = userController.userData;
              if (data != null) {
                return CircleAvatar(
                  backgroundImage:
                      MemoryImage(data.img!),
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
              if (userController.userData != null) {
                return Text(
                  userController.userData!.name,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                );
              } else {
                return const Text("loading...");
              }
            })),
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
        DrawerItem(
            icon: Icons.mic,
            title: '追隨',
            tileOption: () {
              Get.toNamed("/followed");
            }),
        DrawerItem(
            icon: Icons.access_alarm_rounded,
            title: 'test2',
            tileOption: () {}),
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
            Get.delete<InformationManagementWithGetX>();
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
        const Divider(
          height: 1,
          thickness: 2.0,
          color: Color(0x0DFFFFFF),
        ),
      ],
    );
  }
}
