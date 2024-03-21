import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:modify_widget_repository/modify_widget_repository.dart';
import 'package:search_service/search_service_repository.dart';

class BuildGridView extends StatelessWidget {
  final String category;
  const BuildGridView({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    SearchServiceForExploreContent exploreContent =
        SearchServiceForExploreContent(keywords: category);
    // dev.log(type);
    if (category != '') {
      return FutureBuilder(
        future: getGridViewData(exploreContent),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasError) {
              return Text('snapshot Error:${snapshot.error}');
            }
            final data = snapshot.data;
            final getPodcasts = data?.podcastList;
            if (data == null || getPodcasts == null) {
              return Center(
                child: Text(
                  'dataError'.tr,
                  style: TextStyle(fontSize: ScreenUtil().setSp(14)),
                ),
              );
            }
            return GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.only(left: 50, right: 50, bottom: 50).h,
              shrinkWrap: true,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 12.0,
                crossAxisSpacing: 12.0,
              ),
              itemCount: getPodcasts.length,
              itemBuilder: (BuildContext context, int index) {
                final Podcaster podcaster = getPodcasts[index];
                return GestureDetector(
                  onTap: () {
                    Get.toNamed('/podcaster', arguments: podcaster.id);
                  },
                  child: Container(
                      key: UniqueKey(),
                      decoration: const BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey,
                            offset: Offset(2, 5),
                            blurRadius: 4,
                            spreadRadius: 1,
                          ),
                        ],
                      ),
                      child: Stack(
                        children: [
                          FadeInImage.assetNetwork(
                            placeholderCacheWidth: 50,
                            placeholderCacheHeight: 50,
                            imageCacheHeight: 150,
                            imageCacheWidth: 150,
                            fit: BoxFit.cover,
                            placeholderFit: BoxFit.cover,
                            placeholder:
                                "assets/images/generic/search_loading.gif",
                            image: podcaster.imageUrl!,
                            imageErrorBuilder: (context, _, __) {
                              return Image.asset(
                                "assets/images/podcaster/defaultPodcaster.jpg",
                                fit: BoxFit.cover,
                                cacheHeight: 100,
                                cacheWidth: 100,
                              );
                            },
                          ),
                          Align(
                            alignment: Alignment.bottomCenter,
                            child: Container(
                              width: double.infinity,
                              color: const Color(0x7C191B18),
                              child: Text(
                                podcaster.title,
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.center,
                                style:
                                    TextStyle(fontSize: ScreenUtil().setSp(16)),
                              ),
                            ),
                          ),
                        ],
                      )),
                );
              },
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      );
    } else {
      return const Center(child: CircularProgressIndicator());
    }
  }
}
