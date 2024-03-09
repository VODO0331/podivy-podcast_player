import 'package:flutter/material.dart';
import 'package:followed_management_service/followed_management.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:interests_management_service/interests.management.dart';
import 'package:modify_widget_repository/modify_widget_repository.dart';
import 'package:nil/nil.dart';
import 'package:podivy/Page/common/podcasterPage/build/build_profile_information.dart';
import 'package:search_service/search_service_repository.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:developer' as dev show log;

class ShowDescription extends StatelessWidget {
  final Podcaster podcasterData;
  final double opacity;
  final RxBool isFollowed;
  final FollowedManagement followedManagement;
  final InterestsManagement interestsManagement;
  const ShowDescription(
      {super.key,
      required this.podcasterData,
      required this.opacity,
      required this.isFollowed,
      required this.followedManagement,
      required this.interestsManagement});

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
                      // if (podcasterData.categories != null) {
                      //   for (var category in podcasterData.categories!) {
                      //     // dev.log(category);
                      //   }
                      // }
                    },
                    icon: const Icon(Icons.share),
                    label: const Text("分享"),
                  ),
                  FutureBuilder(
                    future: followedManagement.isFollowed(podcasterData.id),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
                        isFollowed.value = snapshot.data!;

                        return Obx(() {
                          final Rx<IconData> btIcon = isFollowed.value
                              ? Icons.favorite.obs
                              : Icons.favorite_border.obs;
                          final Rx<Color> btColor = isFollowed.value
                              ? Colors.red.obs
                              : Colors.white.obs;
                          return OutlinedButton.icon(
                            style: OutlinedButton.styleFrom(
                                fixedSize: Size(
                                  ScreenUtil().setWidth(150),
                                  ScreenUtil().setWidth(40),
                                ),
                                foregroundColor: btColor.value,
                                side: BorderSide(color: btColor.value)),
                            onPressed: () async {
                              await changeBtState(
                                followedManagement,
                                interestsManagement,
                                podcasterData,
                                isFollowed.value,
                              );
                              isFollowed.value = !isFollowed.value;
                            },
                            icon: Icon(
                              btIcon.value,
                              color: btColor.value,
                            ),
                            label: const Text("追隨"),
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
                          label: const Text("追隨"),
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
                  children: [socialButton(podcasterData.socialLinks),
                  Text(podcasterData.language!)],
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
  if (socialLinks == null) return nil;

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
