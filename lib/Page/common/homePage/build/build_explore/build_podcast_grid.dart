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
                            blurRadius: 10,
                            spreadRadius: 0.2,
                          ),
                        ],
                      ),
                      child: Stack(
                        children: [
                          FadeInImage.assetNetwork(
                            placeholderCacheWidth: 50.r.toInt(),
                            placeholderCacheHeight: 50.r.toInt(),
                            imageCacheHeight: 150.r.toInt(),
                            imageCacheWidth: 150.r.toInt(),
                            fit: BoxFit.cover,
                            placeholderFit: BoxFit.cover,
                            placeholder:
                                "assets/images/generic/search_loading.gif",
                            image: podcaster.imageUrl!,
                            imageErrorBuilder: (context, _, __) {
                              return Image.asset(
                                height: 150.r,
                                width: 150.r,
                                "assets/images/podcaster/defaultPodcaster.jpg",
                                fit: BoxFit.cover,
                                cacheHeight: 100.r.toInt(),
                                cacheWidth: 100.r.toInt(),
                              );
                            },
                          ),
                          Align(
                            alignment: Alignment.bottomCenter,
                            child: Container(
                              width: double.infinity,
                              color: Theme.of(context)
                                  .colorScheme
                                  .background
                                  .withOpacity(0.85),
                              child: Text(
                                podcaster.title,
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.center,
                                style:
                                    TextStyle(fontSize: ScreenUtil().setSp(12)),
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
