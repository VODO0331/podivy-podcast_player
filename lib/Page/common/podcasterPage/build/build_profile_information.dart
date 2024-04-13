import 'package:firestore_service_repository/firestore_service_repository.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:modify_widget_repository/modify_widget_repository.dart';
import 'package:podivy/Controller/widget_animation_controller.dart';
import 'package:podivy/Page/common/podcasterPage/build/build_description.dart';
import 'package:search_service/search_service_repository.dart';

class ProfileInformation extends StatelessWidget {
  final Podcaster podcasterData;
  ProfileInformation({super.key, required this.podcasterData});
  final _widgetController = Get.put(WidgetController());
  final RxBool isFollowed = false.obs;
  // final _followedStorageService = Get.find<FollowedManagement>();
  final _followedStorageService = Get.find<FollowedManagement>();

  // final InterestsManagement _interestsManagement = Get.find();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        _buildShaderMask(podcasterData.imageUrl!),
        Padding(
            padding: const EdgeInsets.all(9).r,
            child: AnimatedBuilder(
              animation: _widgetController.animationController!,
              builder: (context, child) {
                return SizedBox(
                  height: _widgetController.heightAnimation!.value.h,
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
                            color: Theme.of(context).colorScheme.primary,
                            icon: const Icon(Icons.arrow_back_rounded),
                          ),
                          Image.asset(
                            Get.isDarkMode
                                ? 'assets/images/podchaser/white.png'
                                : 'assets/images/podchaser/black.png',
                            height: 30.r,
                            width: 170.r,
                            cacheHeight: 30.r.toInt(),
                            cacheWidth: 170.r.toInt(),
                            fit: BoxFit.cover,
                          ),
                          IconButton(
                            iconSize: 35.r,
                            onPressed: null,
                            color: Theme.of(context).colorScheme.primary,
                            icon: const Icon(Icons.podcasts),
                          ),
                        ],
                      ),
                      const Divider(),
                      GestureDetector(
                        onTap: () {
                          _widgetController.changeAnimation();
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8).r,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              _buildUserAvatar(
                                podcasterData.imageUrl!,
                                _widgetController.avatarSizeAnimation!.value,
                                _widgetController.opacityAnimation!.value!,
                              ),
                              Flexible(
                                child: _buildTitleTextScroll(
                                  podcasterData.title,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        child: ShowDescription(
                          podcasterData: podcasterData,
                          opacity: _widgetController.opacityAnimation!.value!,
                          isFollowed: isFollowed,
                          followedManagement: _followedStorageService,
                        ),
                      ),
                      Transform.rotate(
                        angle: _widgetController.rotateAnimation!.value,
                        child: GestureDetector(
                          onTap: () {
                            _widgetController.changeAnimation();
                          },
                          child: Icon(
                            Icons.keyboard_arrow_down_outlined,
                            size: 30.r,
                          ),
                        ),
                      ),
                    ],
                  ),
                ).asGlass(
                  tintColor: Theme.of(context).colorScheme.background,
                  clipBorderRadius: BorderRadius.circular(30),
                );
              },
            ))
      ],
    );
  }
}

Widget _buildUserAvatar(String imageUrl, double size, double opacity) {
  return Visibility(
    visible: size > 0,
    child: Opacity(
      opacity: 1 - opacity,
      child: Padding(
        padding: const EdgeInsets.only(right: 20).r,
        child: SizedBox(
          height: size * 2,
          width: size * 2,
          child: Card(
            clipBehavior: Clip.antiAlias,
            shape: const CircleBorder(),
            color: Colors.transparent,
            child: FadeInImage.assetNetwork(
              placeholderCacheWidth: 90.r.toInt(),
              placeholderCacheHeight: 90.r.toInt(),
              imageCacheHeight: 160.r.toInt(),
              imageCacheWidth: 160.r.toInt(),
              fit: BoxFit.cover,
              placeholderFit: BoxFit.cover,
              placeholder: "assets/images/generic/search_loading.gif",
              image: imageUrl,
              imageErrorBuilder: (context, _, __) {
                return Image.asset(
                  "assets/images/podcaster/defaultPodcaster.jpg",
                  fit: BoxFit.cover,
                  cacheHeight: 100.r.toInt(),
                  cacheWidth: 100.r.toInt(),
                );
              },
            ),
          ),
        ),
      ),
    ),
  );
}

Widget _buildTitleTextScroll(
  String? title,
) {
  return TextScroll(
    title ?? 'Unknown Title',
    style: TextStyle(
      fontSize: ScreenUtil().setSp(20),
    ),
    intervalSpaces: 5,
    velocity: const Velocity(pixelsPerSecond: Offset(65, 0)),
    delayBefore: const Duration(seconds: 3),
    pauseBetween: const Duration(seconds: 10),
    fadedBorder: true,
  );
}

Widget _buildShaderMask(String imageUrl) {
  return ShaderMask(
    shaderCallback: (Rect bounds) {
      return LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Theme.of(Get.context!).colorScheme.background,
          Colors.transparent,
        ],
      ).createShader(bounds);
    },
    blendMode: BlendMode.dstIn,
    child: Image.network(
      imageUrl,
      fit: BoxFit.cover,
      height: 300.h,
      width: double.infinity,
      cacheHeight: 594.r.toInt(),
      cacheWidth: 594.r.toInt(),
      errorBuilder: (context, error, stackTrace) => Image.asset(
        "assets/images/podcaster/defaultPodcaster.jpg",
        fit: BoxFit.cover,
        cacheHeight: 100.r.toInt(),
        cacheWidth: 100.r.toInt(),
      ),
    ),
  );
}
