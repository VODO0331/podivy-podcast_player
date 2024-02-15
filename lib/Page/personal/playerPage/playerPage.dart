import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:podivy/model/Episode.dart';
import 'package:podivy/model/Podcaster.dart';
import 'package:podivy/widget/loadImage.dart';
import 'package:podivy/Page/personal/playerPage/build/buildPlayerControl.dart';


class PlayerPage extends StatefulWidget {
  const PlayerPage({super.key});

  @override
  State<PlayerPage> createState() => _PlayerPageState();
}

class _PlayerPageState extends State<PlayerPage> {
  final List<Episode> getEpisodeList = Get.arguments['episodes'];
  final Podcaster? podcasterData = Get.arguments['podcaster'];
  final int getIndex = Get.arguments['index'];
  late String? imageUrl;

 @override
  void initState() {
    // TODO: implement initState
    super.initState();
   
    final Episode currentEpisodeData = getEpisodeList[getIndex];
   imageUrl = currentEpisodeData.podcast?.imageUrl ?? podcasterData!.imageUrl;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Music Player'),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
                width: 200.w,
                height: 200.h,
                decoration: const BoxDecoration(shape: BoxShape.circle),
                child: LoadImageWidget(imageUrl: imageUrl)),
            SizedBox(height: 20.h),
            PlayerControl(
              getEpisodeList: getEpisodeList,
              getIndex: getIndex,
              podcasterData: podcasterData,
          
              onParameterChanged: (newImageUrl) {
                if (imageUrl != newImageUrl) {
                  setState(() {
                    imageUrl = newImageUrl;
                  });
                }
              },
            ),
          ],
        ));
  }
}
