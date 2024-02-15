import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:podivy/Page/personal/followedPage/build/buildFollowedList.dart';
import 'package:podivy/service/cloud/followed/firebaseCloudStroge.dart';

class FollowedPage extends StatelessWidget {
  const FollowedPage({super.key});

  @override
  Widget build(BuildContext context) {
    final _followedStorageService = Get.put(PodcastFollowedStorage());
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
              "images/background/followed.png",
              
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
