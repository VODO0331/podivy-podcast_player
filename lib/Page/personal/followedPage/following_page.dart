import 'package:firestore_service_repository/firestore_service_repository.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:modify_widget_repository/modify_widget_repository.dart';
import 'package:podivy/Page/personal/followedPage/build/build_following_list.dart';
import 'package:podivy/util/toast/unfollow_toast.dart';

class FollowPage extends StatelessWidget {
  FollowPage({super.key});

  final fsp = Get.find<FirestoreServiceProvider>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              Get.back();
            },
            icon: const Icon(Icons.arrow_back_ios_rounded),
          ),
          actions: [
            IconButton(
                onPressed: () async {
                  await showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text("tip".tr),
                      content: SizedBox(
                        height: 300.r,
                        width: 300.r,
                        child: Column(
                          children: [
                            Divider(
                              color: ThemeData().dividerColor,
                            ),
                            Container(
                              height: 200.r,
                              width: 400.r,
                              decoration: const BoxDecoration(
                                  image: DecorationImage(
                                      image: AssetImage(
                                          'assets/images/tip/tip_follow.png'))),
                            ),
                          ],
                        ),
                      ),
                      actions: [
                        TextButton(
                            onPressed: () => Get.back(),
                            child: const Text('OK'))
                      ],
                    ),
                  );
                },
                icon: const Icon(Icons.info_outline))
          ],
          // foregroundColor: Colors.black87,
          backgroundColor: Theme.of(context).colorScheme.primary,
          title: Text(
            "Following",
            style: GoogleFonts.borel(
                fontSize: 20.r,
                fontWeight: FontWeight.w900,
                color: Theme.of(context).colorScheme.onPrimary),
          ),
          centerTitle: true,
        ),
        body: Stack(children: [
          Align(
            alignment: Alignment.bottomRight,
            child: Image.asset(
              "assets/images/background/followed.png",
              height: 270.r,
              width: 270.r,
              cacheHeight: 350.r.toInt(),
              cacheWidth: 350.r.toInt(),
            ),
          ),
          StreamBuilder(
            stream: fsp.follow.allFollow(),
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.waiting:
                case ConnectionState.active:
                  if (snapshot.hasData) {
                    final allFollow = snapshot.data;
                    return FollowList(
                      allFollow: allFollow!,
                      onDelete: (following) async {
                        if (await fsp.follow.unfollow(
                            podcastId: following.id)) {
                          await fsp.interests.updateInterests(
                              following.categories, false);
                          toastUnfollow();
                        }
                      },
                      onTap: (following) {
                        Get.toNamed("/follow/podcaster",
                            arguments: following.id);
                      },
                    );
                  } else {
                    return const Center(child: CircularProgressIndicator());
                  }
                default:
                  return const Center(child: CircularProgressIndicator());
              }
            },
          ),
        ]));
  }
}
