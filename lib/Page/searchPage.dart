import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:podivy/util/recommendButton.dart';

import 'dart:developer' as dev show log;

class SerchPage extends StatefulWidget {
  const SerchPage({super.key});

  @override
  State<SerchPage> createState() => _SerchPageState();
}

class _SerchPageState extends State<SerchPage> {
  late bool searched;
  String? keywords;

  @override
  void initState() {
    super.initState();
    searched = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        color: const Color.fromARGB(196, 5, 8, 5),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 90, 20, 20).r,
          child: Column(children: [
            TextField(
              cursorColor: const Color(0xFFABC4AA),
              textInputAction: TextInputAction.search,
              decoration: const InputDecoration(
                prefixIcon: Icon(
                  Icons.search,
                ),
                suffixIcon: Icon(Icons.clear),
                // IconButton(onPressed:(){}, icon: Icon(Icons.clear)),
                label: Text(
                  "search",
                  style: TextStyle(color: Color.fromARGB(255, 110, 127, 109)),
                ),
                border: OutlineInputBorder(),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFFABC4AA)),
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                ),
              ),
              onSubmitted: (value) {
                setState(() {
                  keywords = value;
                  searched = true;
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
                  fontSize: ScreenUtil().setSp(25),
                ),
              ),
            ),
            Divider(
              endIndent: ScreenUtil().setWidth(170),
              color: const Color(0xFFABC4AA),
            ),
            Query(
              options: QueryOptions(
                document: gql(searchQuery),
                variables: {
                  'podcastFirst': 5,
                  'episodesFirst': 12,
                  'searchTerm': keywords,
                  'episodesSortBy': 'RELEVANCE'
                },
              ),
              builder: (result, {fetchMore, refetch}) {
                if (result.hasException) {
                  dev.log(result.exception.toString());
                  return Text(result.exception.toString());
                }

                if (result.isLoading) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                List? getPodcasts = result.data?['podcasts']['data'];
                List? getEpisodes = result.data?['episodes']['data'];
                if (getEpisodes == null) return const Text('no episodes');
                if (getPodcasts == null) return const Text('no podcasts');

                return Expanded(child: searchContent(getPodcasts, getEpisodes));
              },
            ),
          ]),
        ),
      ),
    );
  }

  Widget searchContent(List podcasts, List episodes) {
    double screenHeight = MediaQuery.of(context).size.height;
    double appBarHeight = AppBar().preferredSize.height;

    Widget episodesBuiler = ListView.builder(
      key: UniqueKey(),
      itemCount: episodes.length,
      itemBuilder: (BuildContext context, int index) {
        Map episode = episodes[index];
        Map podcast = episode['podcast'];
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 10).h,
          child: ListTile(
            title: Text(
              episode['title'] ?? 'error',
              overflow: TextOverflow.ellipsis,
            ),
            leading: Image.network(podcast['imageUrl']),
            trailing: const Icon(Icons.more_vert),
            onTap: () {
              Get.toNamed('/player',arguments: {
                'episodes':  episodes,
                'podcaster': podcast,
                'index': index,
              });
            },
          ),
        );
      },
    );
    Widget podcastBuilder = ListView.builder(
        key: UniqueKey(),
        itemCount: podcasts.length,
        scrollDirection: Axis.horizontal,
        itemBuilder: (BuildContext context, int index) {
          Map podcast = podcasts[index];
          return GestureDetector(
            onTap: () => Get.toNamed('/podcaster',arguments: podcast['id']),
            child: Padding(
              padding: const EdgeInsets.all(7.0).r,
              child: Flex(
                direction: Axis.vertical,
                children: [
                  Expanded(
                    flex: 8,
                    child: Image.network(podcast['imageUrl'] ??
                        Image.asset('images/podcaster/defaultPodcaster.jpg')),
                  ),
                  Expanded(
                      flex: 2,
                      child: SizedBox(
                        width: 120.w,
                        child: Text(
                          podcast['title'],
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                        ),
                      )),
                ],
              ),
            ),
          );
        });

    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: searched
          ? Expanded(
              child: SizedBox(
                height: screenHeight - appBarHeight,
                child: Column(
                  children: [
                    Text(
                      'Podcast',
                      style: TextStyle(fontSize: ScreenUtil().setSp(20)),
                    ),
                    const Divider(),
                    Expanded(flex: 3, child: podcastBuilder),
                    Text(
                      'Episodes',
                      style: TextStyle(fontSize: ScreenUtil().setSp(20)),
                    ),
                    const Divider(),
                    Expanded(flex: 7, child: episodesBuiler),
                  ],
                ),
              ),
            )
          : Wrap(
              spacing: 10,
              runSpacing: 5,
              children: [
                RecommendButton(
                  text: '123',
                  onPressed: () {
                    setState(() {
                      searched = true;
                      keywords = '123';
                    });
                  },
                ),
                RecommendButton(text: '237923478'),
                RecommendButton(text: '123'),
              ],
            ),
    );
  }
}

String searchQuery = """
query  search(
    \$podcastFirst: Int,
    \$episodesFirst: Int,
    \$searchTerm: String,
    \$episodesSortBy: EpisodeSortType!
  ){
    podcasts(
      first: \$podcastFirst, 
      searchTerm: \$searchTerm){
      data{
        id
        title
        imageUrl
      }
    }
    episodes(
      first: \$episodesFirst, 
      searchTerm: \$searchTerm, 
      sort:{sortBy: \$episodesSortBy}){
        data{
          id
          title
          audioUrl
          htmlDescription 
            podcast{
              imageUrl
              }
        }
    }

}

""";
