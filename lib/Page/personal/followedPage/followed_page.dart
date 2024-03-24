

import 'package:firestore_service_repository/firestore_service_repository.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:modify_widget_repository/modify_widget_repository.dart';
import 'package:podivy/Page/personal/followedPage/build/build_followed_list.dart';

class FollowedPage extends StatefulWidget {
  const FollowedPage({super.key});

  @override
  State<FollowedPage> createState() => _FollowedPageState();
}

class _FollowedPageState extends State<FollowedPage> {
   late FollowedManagement _followedStorageService;

  @override
  void initState() {
    super.initState();
    _followedStorageService =FollowedManagement();
  }
  @override
  void dispose() {
    _followedStorageService;
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor:Theme.of(context).colorScheme.inversePrimary,
        appBar: AppBar(
          // foregroundColor: Colors.black87,
          backgroundColor: Theme.of(context).colorScheme.primary,
          title: Text(
            "Following",
            style: GoogleFonts.borel(
              fontSize: 20.r,
              fontWeight: FontWeight.w900,
              color: Theme.of(context).colorScheme.onPrimary
            ),
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
            stream: _followedStorageService.allFollowed(),
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.waiting:
                case ConnectionState.active:
                  if (snapshot.hasData) {
                    final allFollowed = snapshot.data;
                    return FollowedList(
                      allFollowed: allFollowed!,
                      onDelete: (followed) async {
                        await _followedStorageService.deleteFollowed(
                            podcastId: followed.podcastId);
                      },
                      onTap: (followed) {
                        Get.toNamed("/podcaster",
                            arguments: {"id": followed.podcastId});
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
