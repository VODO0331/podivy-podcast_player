// searchContent(getPodcasts, getEpisodes)
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:modify_widget_repository/modify_widget_repository.dart';
import 'package:podivy/util/recommend_bt.dart';
import 'package:podivy/widget/load_image.dart';
import 'package:search_service/search_service_repository.dart';

class SearchResult extends StatelessWidget {
  final String? keywords;
  final SearchService searchService;
  const SearchResult({super.key, this.keywords, required this.searchService});

  @override
  Widget build(BuildContext context) {
    return keywords != null && keywords != " "
        ? _SearchResults(
            searchService: searchService,
          )
        : _Recommendations(
            searchService: searchService,
            keywords: keywords,
          );
  }
}

class _Recommendations extends StatefulWidget {
  final String? keywords;
  final SearchService searchService;
  const _Recommendations(
      {Key? key, required this.keywords, required this.searchService})
      : super(key: key);

  @override
  State<_Recommendations> createState() => _RecommendationsState();
}

class _RecommendationsState extends State<_Recommendations> {
  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 10,
      runSpacing: 5,
      children: [
        RecommendButton(
          text: 'News',
          onPressed: () {
            setState(() {
              // widget.keywords = 'News';
              // searchService = SearchServiceForCategories(keywords: 'News');
            });
          },
        ),
        const RecommendButton(text: '237923478'),
        const RecommendButton(text: '123'),
      ],
    );
  }
}

class _SearchResults extends StatelessWidget {
  final SearchService searchService;

  const _SearchResults({Key? key, required this.searchService})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    double appBarHeight = AppBar().preferredSize.height;
    double screenHeight = ScreenUtil().screenHeight - appBarHeight;
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: FutureBuilder(
        future: getSearchData(searchService),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasError) {
              return Text('snapshot Error:${snapshot.error}');
            }
            final Map? data = snapshot.data;
            if (data == null) {
              return Center(
                child: Text(
                  '搜尋不到相關資料',
                  style: TextStyle(fontSize: ScreenUtil().setSp(14)),
                ),
              );
            }
            List<Podcaster>? getPodcasts = data['podcastList'];
            List<Episode>? getEpisodes = data['episodeList'];

            return SizedBox(
              height: screenHeight,
              child: Flex(
                direction: Axis.vertical,
                children: [
                  Text(
                    'Podcast',
                    style: TextStyle(fontSize: ScreenUtil().setSp(20)),
                  ),
                  const Divider(),
                  Expanded(flex: 2, child: podcastBuilder(getPodcasts)),
                  Text(
                    'Episodes',
                    style: TextStyle(fontSize: ScreenUtil().setSp(20)),
                  ),
                  const Divider(),
                  Expanded(flex: 8, child: episodesBuilder(getEpisodes)),
                ],
              ),
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}

Widget podcastBuilder(List<Podcaster>? podcasts) {
  if (podcasts == null) {
    return const Center(
      child: Text('找尋不到資料'),
    );
  } else {
    return GridView.builder(
      key: UniqueKey(),
      gridDelegate:
          const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount:1,),
          // padding:const EdgeInsets.all(8).r,
      itemCount: podcasts.length,
      scrollDirection: Axis.horizontal,
      itemBuilder: (BuildContext context, int index) {
        Podcaster podcast = podcasts[index];
        return GestureDetector(
          onTap: () => Get.toNamed('/podcaster', arguments: podcast.id),
          child:  Flex(
              direction: Axis.vertical,
              children: [
                Expanded(
                  flex: 8,
                  child: Center(
                      child: SizedBox(
                          height: 120.h,
                          width: 120.w,
                          child: LoadImageWidget(
                            imageUrl: podcast.imageUrl,
                          ))),
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

Widget episodesBuilder(
  List<Episode>? episodes,
) {
  if (episodes == null) {
    return const Center(
      child: Text('找尋不到資料'),
    );
  } else {
    return ListView.builder(
      key: UniqueKey(),
      prototypeItem: _prototypeItemForEpisodeBuilder(),
      itemCount: episodes.length,
      itemBuilder: (BuildContext context, int index) {
        Episode episode = episodes[index];

        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8).h,
          child: ListTile(
            title: Text(
              episode.title,
              overflow: TextOverflow.ellipsis,
            ),
            leading: SizedBox(
              height: 60.h,
              width: 60.w,
              child: LoadImageWidget(
                imageUrl: episode.imageUrl,
              ),
            ),
            trailing: const Icon(Icons.more_vert),
            onTap: () {
              Get.toNamed('/player', arguments: {
                'episodes': episodes,
                'index': index,
              });
            },
          ),
        );
      },
    );
  }
}

Widget _prototypeItemForEpisodeBuilder() {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8).h,
    child: ListTile(
      title: const Text(
        "episode.title",
        overflow: TextOverflow.ellipsis,
      ),
      leading: SizedBox(
        height: 60.h,
        width: 60.w,
        child: const LoadImageWidget(
          imageUrl: "episode.imageUrl",
        ),
      ),
      trailing: const Icon(Icons.more_vert),
      onTap: null,
    ),
  );
}


