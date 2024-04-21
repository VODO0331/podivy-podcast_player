import 'package:firestore_service_repository/firestore_service_repository.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:modify_widget_repository/modify_widget_repository.dart';
import 'package:my_audio_player/my_audio_player.dart' show Podcaster, Episode;
import 'package:podivy/Page/common/search/build/build_header_delegate.dart';
import 'package:podivy/Page/common/search/build/build_result_podcast.dart';
import 'package:podivy/Page/common/search/build/build_result_episode.dart';
import 'package:podivy/util/translator.dart';
import 'package:search_service/search_service_repository.dart';

typedef KeywordCallback = void Function(String keywords);

class SearchResult extends StatelessWidget {
  final KeywordCallback onSearched;
  final RxBool isSearched;
  final (
    Rx<SearchServiceForKeyword>,
    Rx<SearchServiceForCategories>
  ) searchService;
  const SearchResult({
    super.key,
    required this.searchService,
    required this.isSearched,
    required this.onSearched,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (isSearched.value) {
        return _SearchResults(
          searchService: (searchService.$1.value, searchService.$2.value),
        );
      } else {
        return _Recommendations(
          recommendCallBack: (searchServiceC) {
            isSearched.value = true;
            onSearched(searchServiceC.keywords);
            searchService.$2.value = searchServiceC;
            searchService.$1.value = SearchServiceForKeyword(keywords: '');
          },
        );
      }
    });
  }
}

class _SearchResults extends StatelessWidget {
  final (SearchServiceForKeyword, SearchServiceForCategories) searchService;

  const _SearchResults({Key? key, required this.searchService})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getSearchData(searchService),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError) {
            snapshot.error.printInfo;
            return Text('snapshot Error:${snapshot.error}');
          }
          final data = snapshot.data;
          if (data == null) {
            return Center(
              child: Text(
                'data is null',
                style: TextStyle(fontSize: ScreenUtil().setSp(14)),
              ),
            );
          }
          List<Podcaster> getPodcasts = data.podcastList;
          List<Episode> getEpisodes = data.episodeList;
          if (getPodcasts.isEmpty && getEpisodes.isEmpty) {
            return Center(
              child: Text(
                'dataNotFind'.tr,
                style: TextStyle(fontSize: ScreenUtil().setSp(14)),
              ),
            );
          }
          return CustomScrollView(
            slivers: [
              if (getPodcasts.isNotEmpty)
                sliverGroup(
                  "Podcasts",
                  PodcastBuilder(podcasts: getPodcasts),
                ),
              if (getEpisodes.isNotEmpty)
                sliverGroup(
                  "Episodes",
                  EpisodesBuilder(episodes: getEpisodes),
                ),
            ],
          );
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}

typedef RecommendCallBack = void Function(
    SearchServiceForCategories searchService);

class _Recommendations extends StatelessWidget {
  final RecommendCallBack recommendCallBack;
  // final SearchService searchService;
  _Recommendations({Key? key, required this.recommendCallBack})
      : super(key: key);
  final InterestsManagement _interestsManagement =
      Get.find<InterestsManagement>();
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: _interestsManagement.interestsCategory(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting ||
              snapshot.connectionState == ConnectionState.active) {
            if (snapshot.hasError) {
              return Text("Error: ${snapshot.error}");
            } else if (snapshot.hasData) {
              final interests = snapshot.data!;

              return Stack(
                children: [
                  Wrap(
                    spacing: 10,
                    runSpacing: 5,
                    children: [
                      for (var interest in interests)
                        ElevatedButton(
                            child: FutureBuilder(
                              future: translation(interest.category),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return const SizedBox.shrink();
                                } else if (snapshot.hasError) {
                                  return Text('Error: ${snapshot.error}');
                                } else if (snapshot.hasData) {
                                  return Text(snapshot.data as String);
                                } else {
                                  return const Text('Translation Error');
                                }
                              },
                            ),
                            onPressed: () {
                              recommendCallBack(SearchServiceForCategories(
                                  keywords: interest.category));
                            })
                    ],
                  ),
                  Align(
                      alignment: Alignment.bottomLeft,
                      child: Image.asset(
                        'assets/images/background/search.png',
                        width: 250.r,
                        height: 250.r,
                        cacheHeight: 656.r.toInt(),
                        cacheWidth: 656.r.toInt(),
                        fit: BoxFit.cover,
                        color: Theme.of(Get.context!).colorScheme.onBackground,
                      ))
                ],
              );
            } else {
              return Text("loading".tr);
            }
          } else {
            return Text("Connection state: ${snapshot.connectionState}");
          }
        });
  }
}

Widget sliverGroup(String title, Widget sliver) {
  return SliverMainAxisGroup(slivers: [
    SliverPadding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      sliver: SliverPersistentHeader(
        pinned: true,
        delegate: HeaderDelegate(title),
      ),
    ),
    sliver
  ]);
}
