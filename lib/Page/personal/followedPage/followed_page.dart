

import 'package:flutter/material.dart';
import 'package:followed_management_service/followed_management.dart';
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
        // backgroundColor:Color.fromARGB(255, 113, 96, 90),
        appBar: AppBar(
          foregroundColor: Colors.black87,
          backgroundColor: const Color(0xFFEAD1AB),
          title: Text(
            "Following",
            style: GoogleFonts.borel(
              fontSize: 20.r,
              fontWeight: FontWeight.w900,
              color: const Color(0xFF745E4D),
            ),
          ),
          centerTitle: true,
        ),
        body: Stack(children: [
          Align(
            alignment: Alignment.bottomRight,
            child: Image.asset(
              "assets/images/background/followed.png",
              
              height: 270,
              width: 270,
              cacheHeight: 350,
              cacheWidth: 350,
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
