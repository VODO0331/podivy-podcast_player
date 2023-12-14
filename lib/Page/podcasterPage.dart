import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:glass/glass.dart';
import 'package:podivy/service/auth/podcaster/podcasterData.dart';
import 'package:podivy/widget/drawer.dart';
import 'package:podivy/widget/userAvatar.dart';
import 'package:text_scroll/text_scroll.dart';

class PodcasterPage extends StatelessWidget {
  PodcasterPage({super.key});

  Widget profileInformation(PodcasterData podcasterdata) {
    return Stack(
      children: [
        ShaderMask(
          shaderCallback: (Rect bounds) {
            return const LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.black, Colors.transparent],
            ).createShader(bounds);
          },
          blendMode: BlendMode.dstIn,
          child: Image.asset(
            podcasterdata.imagePath,
            fit: BoxFit.cover,
            height: 300.h,
            width: double.infinity,
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(15, 60, 15, 0).r,
          child: Container(
            height: 220.h,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              color: Colors.black45,
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      iconSize: 35.r,
                      onPressed: () {
                        Get.back();
                      },
                      icon: const Icon(Icons.arrow_back_ios_rounded),
                    ),
                    IconButton(
                      iconSize: 35.r,
                      onPressed: () {},
                      icon: const Icon(Icons.more_vert_sharp),
                    ),
                  ],
                ),
                const Divider(),
                Padding(
                  padding: const EdgeInsets.only(left: 8, top: 5).r,
                  child: Row(
                    children: [
                      UserAvatar(
                        imgPath: podcasterdata.imagePath,
                        radius: 60,
                        boraderthinness: 65,
                        color: const Color(0xFFABC4AA),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 30).w,
                        child: TextScroll(
                          podcasterdata.name,
                          style: TextStyle(
                            fontSize: ScreenUtil().setSp(20),
                          ),
                          intervalSpaces: 5,
                          velocity:
                              const Velocity(pixelsPerSecond: Offset(60, 0)),
                          delayBefore: const Duration(seconds: 3),
                          pauseBetween: const Duration(seconds: 10),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ).asGlass(),
        )
      ],
    );
  }

  final GlobalKey<ScaffoldState> sKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final titleList = [
      'overflowoverflowoverflowoverflowoverflowoverflow',
      'title2',
      'title2',
      'title2',
      'title2'
    ];
    final podcasterdata = Get.arguments;
    return GestureDetector(
      onHorizontalDragUpdate: (details) {
        if (details.primaryDelta != 0 && details.primaryDelta! > 10) {
          (details);
          sKey.currentState?.openDrawer();
        }
      },
      child: Scaffold(
        key: sKey,
        drawer: const MyDrawer(),
        body: Column(children: [
          profileInformation(podcasterdata),
          Expanded(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color(0xFF7B7060),
                      Color(0xFF2C271D),
                    ],
                    stops: [
                      0.7,
                      1
                    ]),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0).r,
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                            onPressed: () {
                              print('sort');
                            },
                            icon: const Icon(Icons.sort_sharp)),
                        Text('${titleList.length} 部'),
                      ],
                    ),
                    const Divider(
                      thickness: 1,
                    ),
                    Expanded(
                      child: ListView.builder(
                        padding: EdgeInsets.zero,
                        itemCount: titleList.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Column(
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 10).h,
                                child: ListTile(
                                  title: Text(
                                    titleList[index],
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  trailing: const Icon(Icons.more_vert),
                                  onTap: () {
                                    Get.toNamed("/player", arguments: {
                                      'title': titleList[index],
                                      'podcasterData': podcasterdata
                                    });
                                  },
                                ),
                              )
                            ],
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
        ]),
      ),
    );
  }
}
