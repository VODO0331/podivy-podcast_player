

import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:modify_widget_repository/modify_widget_repository.dart';
import 'package:search_service/search_service_repository.dart';

class PodcastBuilder extends StatelessWidget {
  final List<Podcaster>? podcasts;
  const PodcastBuilder({super.key,required this.podcasts});

  @override
  Widget build(BuildContext context) {
     if (podcasts == null) {
    return const Center(
      child: Text('找尋不到資料'),
    );
  } else {
    return GridView.builder(
      key: UniqueKey(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 1,
      ),
      // padding:const EdgeInsets.all(8).r,
      itemCount: podcasts!.length,
      scrollDirection: Axis.horizontal,
      itemBuilder: (BuildContext context, int index) {
        Podcaster podcast = podcasts![index];
        return GestureDetector(
          onTap: () => Get.toNamed('/podcaster', arguments: podcast.id),
          child: Flex(
            direction: Axis.vertical,
            children: [
              Expanded(
                flex: 8,
                child: Center(
                    child: SizedBox(
                  height: 120.h,
                  width: 120.w,
                  child: ClipRRect(
                    borderRadius: const BorderRadius.all(Radius.circular(8)),
                    child: FadeInImage.assetNetwork(
                      placeholderCacheWidth: 50,
                      placeholderCacheHeight: 50,
                      imageCacheHeight: 250,
                      imageCacheWidth: 250,
                      fit: BoxFit.cover,
                      placeholderFit: BoxFit.cover,
                      placeholder: "assets/images/generic/search_loading.gif",
                      image: podcast.imageUrl!,
                      imageErrorBuilder: (context, _, __) {
                        return Image.asset(
                          "assets/images/podcaster/defaultPodcaster.jpg",
                          fit: BoxFit.cover,
                          cacheHeight: 150,
                          cacheWidth: 150,
                        );
                      },
                    ),
                  ),
                )),
              ),
              Expanded(
                  flex: 2,
                  child: SizedBox(
                    width: 120.w,
                    child: Text(
                      podcast.title ?? 'error',
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                    ),
                  )),
            ],
          ),
        );
      },
    );
  }
}
}