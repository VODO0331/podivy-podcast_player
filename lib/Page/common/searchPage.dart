import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:podivy/model/Episode.dart';
import 'package:podivy/model/Podcaster.dart';
import 'package:podivy/model/Search.dart';
import 'package:podivy/service/search/searchService.dart';
import 'package:podivy/util/recommendButton.dart';
import 'package:podivy/widget/loadImage.dart';
// import 'dart:developer' as dev show log;

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  String? keywords;
  late SearchService searchService;
  late TextEditingController textEditingController;
  @override
  void initState() {
    super.initState();
    searchService = SearchServiceForKeyword(keywords: keywords);
    textEditingController = TextEditingController();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    textEditingController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        color: const Color.fromARGB(196, 5, 8, 5),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 70, 20, 20).r,
          child: Column(children: [
            TextField(
              controller: textEditingController,
              cursorColor: const Color(0xFFABC4AA),
              textInputAction: TextInputAction.search,
              decoration: InputDecoration(
                prefixIcon: const Icon(
                  Icons.search,
                ),
                suffixIcon: IconButton(
                    onPressed: () {
                      textEditingController.clear();
                      setState(() {
                        keywords = " ";
                      });
                    },
                    icon: const Icon(Icons.clear)),
                label: const Text(
                  "search",
                  style: TextStyle(color: Color.fromARGB(255, 110, 127, 109)),
                ),
                border: const OutlineInputBorder(),
                focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFFABC4AA)),
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                ),
              ),
              onSubmitted: (value) {
                setState(() {
                  searchService = SearchServiceForKeyword(keywords: value);
                  keywords = value;
                });
              },
            ),
            const SizedBox(
              height: 15,
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "search:${keywords ?? "類型"}",
                style: TextStyle(
                  fontSize: ScreenUtil().setSp(20),
                ),
              ),
            ),
            Divider(
              endIndent: ScreenUtil().setWidth(170),
              color: const Color(0xFFABC4AA),
            ),
            Expanded(
              child: searchContent(),
            )
          ]),
        ),
      ),
    );
  }

// searchContent(getPodcasts, getEpisodes)
  Widget searchContent() {
    double screenHeight = MediaQuery.of(context).size.height;
    double appBarHeight = AppBar().preferredSize.height;

    if (keywords != null && keywords != " ") {
      return SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: FutureBuilder(
          future: getSearchData(searchService),
          builder: (
            BuildContext context,
            AsyncSnapshot<dynamic> snapshot,
          ) {
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
                height: screenHeight - appBarHeight,
                child: Flex(
                  direction: Axis.vertical,
                  children: [
                    Text(
                      'Podcast',
                      style: TextStyle(fontSize: ScreenUtil().setSp(20)),
                    ),
                    const Divider(),
                    Expanded(flex: 3, child: podcastBuilder(getPodcasts)),
                    Text(
                      'Episodes',
                      style: TextStyle(fontSize: ScreenUtil().setSp(20)),
                    ),
                    const Divider(),
                    Expanded(flex: 7, child: episodesBuilder(getEpisodes)),
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
    } else {
      return Wrap(
        spacing: 10,
        runSpacing: 5,
        children: [
          RecommendButton(
            text: 'News',
            onPressed: () {
              setState(() {
                keywords = 'News';
                searchService = SearchServiceForCategories(keywords: 'News');
              });
            },
          ),
          RecommendButton(text: '237923478'),
          RecommendButton(text: '123'),
        ],
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

  Widget podcastBuilder(List<Podcaster>? podcasts) {
    if (podcasts == null) {
      return const Center(
        child: Text('找尋不到資料'),
      );
    } else {
      return ListView.builder(
          key: UniqueKey(),
          itemCount: podcasts.length,
          scrollDirection: Axis.horizontal,
          itemBuilder: (BuildContext context, int index) {
            Podcaster podcast = podcasts[index];
            return GestureDetector(
              onTap: () => Get.toNamed('/podcaster', arguments: podcast.id),
              child: Padding(
                padding: const EdgeInsets.all(7.0).r,
                child: Flex(
                  direction: Axis.vertical,
                  children: [
                    Expanded(
                      flex: 8,
                      child: Center(
                          child: SizedBox(
                              height: 120.h,
                              width: 120.w,
                              child: LoadImageWidget(imageUrl: podcast.imageUrl,))),
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
              ),
            );
          });
    }
  }
}
