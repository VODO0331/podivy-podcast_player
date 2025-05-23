import 'package:firestore_service_repository/firestore_service_repository.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:modify_widget_repository/modify_widget_repository.dart';
import 'package:my_audio_player/my_audio_player.dart'show Podcaster,SocialLinks;
import 'package:podivy/util/change_follow_state.dart';

import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class ShowDescription extends StatelessWidget {
  final Podcaster podcasterData;
  final double opacity;
  final RxBool haveFollow;
  final FirestoreServiceProvider fsp;
 
  const ShowDescription(
      {super.key,
      required this.podcasterData,
      required this.opacity,
      required this.haveFollow,
      required this.fsp,});

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: opacity,
      child: Visibility(
        visible: opacity > 0.75,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 20).r,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                      fixedSize: Size(ScreenUtil().setWidth(150),
                          ScreenUtil().setWidth(40)),
                    ),
                    onPressed: () {
                      Share.share('share ${podcasterData.title}');
                    },
                    icon: const Icon(Icons.share),
                    label: Text("share".tr),
                  ),
                  FutureBuilder(
                    future: fsp.follow.haveFollow(podcasterData.id),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
                        haveFollow.value = snapshot.data!;

                        return Obx(() {
                          final Rx<IconData> btIcon = haveFollow.value
                              ? Icons.favorite.obs
                              : Icons.favorite_border.obs;
                          final Rx<Color> btColor = haveFollow.value
                              ? Colors.red.obs
                              : Colors.grey.obs;
                          return OutlinedButton.icon(
                            style: OutlinedButton.styleFrom(
                                fixedSize: Size(
                                  ScreenUtil().setWidth(150),
                                  ScreenUtil().setWidth(40),
                                ),
                                foregroundColor: btColor.value,
                                side: BorderSide(color: btColor.value)),
                            onPressed: () async {
                              await changeFollowState(
                                podcasterData,
                                haveFollow.value,
                              );
                              haveFollow.value = !haveFollow.value;
                            },
                            icon: Icon(
                              btIcon.value,
                              color: btColor.value,
                            ),
                            label: Text("follow".tr),
                          );
                        });
                      } else {
                        return OutlinedButton.icon(
                          style: OutlinedButton.styleFrom(
                            fixedSize: Size(
                              ScreenUtil().setWidth(150),
                              ScreenUtil().setWidth(40),
                            ),
                          ),
                          onPressed: null,
                          icon: const Icon(Icons.favorite_border),
                          label: Text("follow".tr),
                        );
                      }
                    },
                  )
                ],
              ),
              SizedBox(
                height: 12.h,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 9).r,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    socialButton(podcasterData.socialLinks),
                    Text(podcasterData.language!)
                  ],
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Text(podcasterData.description!),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Widget socialButton(SocialLinks? socialLinks) {
  if (socialLinks == null) return const SizedBox.shrink();

  Widget buildIconButton(String url, IconData iconData) {
    return IconButton(
      onPressed: () async {
        final uri = Uri.parse(url);
        if (await canLaunchUrl(uri)) {
          await launchUrl(uri, mode: LaunchMode.externalApplication);
        } else {
          throw 'Could not launch $url';
        }
      },
      icon: Icon(iconData),
    );
  }

  List<Widget> socialList = [];
  if (socialLinks.facebook != null) {
    socialList.add(buildIconButton(
        "https://www.facebook.com/${socialLinks.facebook!}/",
        FontAwesomeIcons.facebook));
  }
  if (socialLinks.twitter != null) {
    socialList.add(buildIconButton(
        "https://www.twitter.com/${socialLinks.twitter!}/",
        FontAwesomeIcons.xTwitter));
  }
  if (socialLinks.instagram != null) {
    socialList.add(buildIconButton(
        "https://www.instagram.com/${socialLinks.instagram!}/",
        FontAwesomeIcons.instagram));
  }

  return Row(children: socialList);
}
