import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:modify_widget_repository/modify_widget_repository.dart';
import 'package:my_audio_player/my_audio_player.dart';
import 'package:podivy/util/dialogs/description_dialog.dart';
class BuildEpisodeInfo extends StatelessWidget {
  final MediaItem currentEpisodeData;
  const BuildEpisodeInfo({super.key, required this.currentEpisodeData});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 200.r,
          height: 200.r,
          decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(30)),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey,
                  blurRadius: 50,
                  spreadRadius: 5,
                )
              ]),
          child: GestureDetector(
            onTap: ()=>Get.offAndToNamed('/podcaster',arguments: currentEpisodeData.extras!['podcasterId']),
            child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: FadeInImage.assetNetwork(
                  placeholderCacheWidth: 50.r.toInt(),
                  placeholderCacheHeight: 50.r.toInt(),
                  imageCacheHeight: 300.r.toInt(),
                  imageCacheWidth: 300.r.toInt(),
                  fit: BoxFit.cover,
                  placeholderFit: BoxFit.cover,
                  placeholder: "assets/images/generic/search_loading.gif",
                  image: currentEpisodeData.artUri.toString(),
                  imageErrorBuilder: (context, _, __) {
                    return Image.asset(
                      "assets/images/podcaster/defaultPodcaster.jpg",
                      fit: BoxFit.cover,
                      cacheHeight: 100.r.toInt(),
                      cacheWidth: 100.r.toInt(),
                    );
                  },
                )),
          ),
        ),
        SizedBox(height: 20.h),
        GestureDetector(
          onTap: () async {
            if (currentEpisodeData.displayDescription != null) {
              await showDescriptionDialog(
                  context, currentEpisodeData.displayDescription!);
            } else {
              null;
            }
          },
          child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 40, vertical: 8).r,
              child: SizedBox(
                height: 110.r,
                width: 500.w,
                child: Container(
                  
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                      border: Border.all(
                    color: Theme.of(context).primaryColor,
                    width: 5
                  )),
                  child: ListTile(
                    titleAlignment: ListTileTitleAlignment.center,
                    title: Text(
                      maxLines: 2,
                      currentEpisodeData.title,
                      style: TextStyle(fontSize: ScreenUtil().setSp(15)),
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                    ),
                    subtitle: Text(
                      currentEpisodeData.artist!,
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              )),
        ),
      ],
    );
  }
}