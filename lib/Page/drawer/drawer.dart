import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:modify_widget_repository/modify_widget_repository.dart';
import 'package:my_audio_player/my_audio_player.dart';
import 'package:podivy/Page/drawer/build/build_background.dart';
import 'package:podivy/Page/drawer/build/build_small_player.dart';
import 'package:provider/provider.dart';

import 'build/build_drawer_item.dart';
import 'build/build_logout_bt.dart';
import 'build/build_user_profile.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Get.isDarkMode
          ? null
          : Theme.of(context).colorScheme.primaryContainer,
      child: Stack(
        children: [
          const BuildDrawerBackground(),
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 8, 8, 60),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                BuildUserProfile(),
                SizedBox(height: 30.h),
                buildDrawerItems(),
                SizedBox(height: 30.h),
                Consumer<MyAudioPlayer>(builder: (context, ctr, child) {
                  if (!ctr.isIdle) {
                    return Padding(
                        padding: const EdgeInsets.only(top: 30).h,
                        child: SmallPlayer(
                          ctr: ctr,
                        ));
                  } else {
                    return const SizedBox.shrink();
                  }
                }),
                const Expanded(child: SizedBox()),
                const BuildLogoutButton(),
                _buildDivider(),
              ],
            ),
          ),
        ],
      ),
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
}
