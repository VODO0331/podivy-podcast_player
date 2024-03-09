import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:modify_widget_repository/modify_widget_repository.dart';
import 'package:podivy/Page/common/search/build/build_header_delegate.dart';
import 'package:podivy/Page/common/search/build/build_result_podcast.dart';
import 'package:podivy/Page/common/search/build/build_result_episode.dart';
import 'package:podivy/util/recommend_bt.dart';
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

class _SearchResults extends StatelessWidget {
  final SearchService searchService;

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

          return CustomScrollView(
            slivers: [
              sliverGroup(
                "Podcast",
                PodcastBuilder(podcasts: getPodcasts),
              ),
              sliverGroup(
                "Episode",
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
