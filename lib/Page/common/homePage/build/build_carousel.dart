
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:modify_widget_repository/modify_widget_repository.dart';

import 'package:podivy/Page/common/homePage/build/build_turntable_animation.dart';
import 'package:share_plus/share_plus.dart';
import 'package:get/get.dart';
import 'dart:developer' as dev show log;

class LatestPodcast extends StatelessWidget {
  const LatestPodcast({super.key});
  
  @override
  Widget build(BuildContext context) {
    return Query(
      options: QueryOptions(
        document: gql(getPodcasts),
        variables: const {
          'languageFilter': 'ZH',
          'first': 3,
          'podcastsSortBy': 'DATE_OF_FIRST_EPISODE',
          'episodeDirection': 'DESCENDING',
          'episodesortBy': 'AIR_DATE',
        },
      ),
      builder: _buildQueryResult,
    );
  }

  Widget _buildQueryResult(result, {fetchMore, refetch}) {
    if (result.hasException) {
      dev.log(result.exception.toString());
      return Text(result.exception.toString());
    }
    if (result.isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
    List<Map<String, dynamic>>? podcastsData =
        result.data?['podcasts']?['data']?.cast<Map<String, dynamic>>();
    if (podcastsData == null) {
      return const Text('NO repositories');
    }

    List<TurnTable> turnTables = [];
    for (var podcastData in podcastsData) {
      List<Map<String, dynamic>>? latestEpisode =
          podcastData['episodes']['data']?.cast<Map<String, dynamic>>();
      if (latestEpisode != null) {
        turnTables.add(TurnTable(
          isCentered: false,
          isLiked: false.obs,
          reminder: false.obs,
          podcasterData: podcastData,
          latestEpisode: latestEpisode,
        ));
      }
    }
    return MyCarousel(items: turnTables);
  }
}

class MyCarousel extends StatefulWidget {
  final List<TurnTable> items;

  const MyCarousel({Key? key, required this.items}) : super(key: key);

  @override
  State<MyCarousel> createState() => _MyCarouselState();
}

class _MyCarouselState extends State<MyCarousel> {
  late CarouselController controller;
  double currentIndex = 0;

  @override
  void initState() {
    controller = CarouselController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CarouselSlider(
          carouselController: controller,
          items: widget.items,
          options: CarouselOptions(
            height: 200.0,
            enlargeCenterPage: true,
            enableInfiniteScroll: false,
            autoPlay: false,
            aspectRatio: 20 / 9,
            viewportFraction: 0.9,
            onPageChanged: _handlePageChanged,
          ),
        ),
        DotsIndicator(
          dotsCount: widget.items.length,
          position: currentIndex.round().toDouble(),
          decorator: _buildDotsDecorator(),
        ),
      ],
    );
  }

  void _handlePageChanged(int index, CarouselPageChangedReason reason) {
    setState(() {
      currentIndex = index.toDouble();
      for (int i = 0; i < widget.items.length; i++) {
        if (i == index) {
          widget.items[i] = widget.items[i].updateIsCentered(true);
        } else {
          if (widget.items[i].isCentered == true) {
            widget.items[i] = widget.items[i].updateIsCentered(false);
          }
        }
      }
    });
  }

  DotsDecorator _buildDotsDecorator() {
    return DotsDecorator(
      color: const Color(0xFF2B312A),
      activeColor: const Color(0xFFF0FDF0),
      size: const Size.square(12.0),
      activeSize: const Size(24.0, 12.0),
      activeShape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
    );
  }
}

class TurnTable extends StatefulWidget {
  final bool isCentered;
  final RxBool isLiked;
  final RxBool reminder;
  final Map podcasterData;
  final List<Map> latestEpisode;

  const TurnTable({
    Key? key,
    required this.isCentered,
    required this.isLiked,
    required this.reminder,
    required this.podcasterData,
    required this.latestEpisode,
  }) : super(key: key);

  TurnTable updateIsCentered(bool value) {
    return TurnTable(
      isCentered: value,
      reminder: reminder,
      isLiked: isLiked,
      podcasterData: podcasterData,
      latestEpisode: latestEpisode,
    );
  }

  @override
  State<TurnTable> createState() => _TurnTableState();
}

class _TurnTableState extends State<TurnTable> {
  late RxBool isLiked;
  late RxBool reminder;
  late bool isCentered;

  @override
  void initState() {
    super.initState();
    isLiked = widget.isLiked;
    reminder = widget.reminder;
    isCentered = widget.isCentered;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(5).r,
      width: 360.w,
      height: 210.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: const Color(0x9F22261F),
        border: Border.all(color: Colors.white70),
      ),
      child: Flex(
        direction: Axis.horizontal,
        children: [
          Expanded(
            flex: 3,
            child: _buildPodcasterInfo(),
          ),
          const VerticalDivider(
            thickness: 1,
            color: Color.fromARGB(255, 129, 145, 122),
          ),
          Expanded(
            flex: 6,
            child: _buildPodcastLatestContent(),
          ),
        ],
      ),
    );
  }

  Widget _buildPodcasterInfo() {
    return IntrinsicHeight(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextScroll(
            widget.podcasterData['title'],
            intervalSpaces: 5,
            velocity: const Velocity(pixelsPerSecond: Offset(50, 0)),
            delayBefore: const Duration(seconds: 2),
            pauseBetween: const Duration(seconds: 2),
          ),
          SizedBox(
            height: 5.h,
          ),
          Expanded(
            child: Stack(
              alignment: Alignment.bottomRight,
              children: [
                GestureDetector(
                  onTap: _handlePodcasterTap,
                  child: TurntableAnimation(
                    isCentered: widget.isCentered,
                    child: CircleAvatar(
                      radius: 37,
                      child: CircleAvatar(
                        backgroundImage: widget.podcasterData['imageUrl'],
                        radius: 40.r,
                      ),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.topRight,
                  child: Image.asset(
                    'assets/images/turnTable/record2.png',
                  ),
                ),
              ],
            ),
          ),
          buttonGroup(isLiked, reminder, widget.podcasterData['title']),
        ],
      ),
    );
  }

  Widget _buildPodcastLatestContent() {
    return Container(
      width: 200.w,
      height: 165.h,
      decoration: BoxDecoration(
        color: const Color.fromARGB(96, 76, 74, 74),
        border: Border.all(color: Colors.white60),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(5.0),
          topRight: Radius.circular(16.0),
          bottomLeft: Radius.circular(5.0),
          bottomRight: Radius.circular(16.0),
        ),
      ),
      child: podcastLatestContent(widget.latestEpisode, widget.podcasterData),
    );
  }

  void _handlePodcasterTap() {
    Get.toNamed('/podcaster', arguments: widget.podcasterData['id']);
  }
}

Widget buttonGroup(RxBool isLiked, RxBool reminder, String name) {
  return Row(
    children: [
      Flexible(
        child: IconButton(
          onPressed: () {
            Share.share('分享$name');
          },
          icon: const Icon(Icons.share),
        ),
      ),
      Flexible(
        child: IconButton(
          onPressed: () {
            isLiked.toggle();
          },
          icon: Obx(() {
            return Icon(
              isLiked.value ? Icons.favorite : Icons.favorite_border,
              color: isLiked.value ? Colors.red : null,
            );
          }),
        ),
      ),
      Flexible(
        child: IconButton(
          onPressed: () {
            reminder.toggle();
          },
          icon: Obx(() {
            return Icon(
              reminder.value
                  ? Icons.notifications_active
                  : Icons.notifications_active_outlined,
              color: reminder.value ? Colors.yellow : null,
            );
          }),
        ),
      ),
    ],
  );
}

Widget podcastLatestContent(List<Map> latestList, Map podcasterDate) {
  return ListView.builder(
    padding: EdgeInsets.zero,
    itemCount: 3,
    itemBuilder: (BuildContext context, int index) {
      final Map episodeData = latestList[index];
      return Column(
        children: [
          ListTile(
            title: TextScroll(
              episodeData['title'],
              intervalSpaces: 12,
              velocity: const Velocity(pixelsPerSecond: Offset(90, 0)),
              delayBefore: const Duration(seconds: 3),
              pauseBetween: const Duration(seconds: 5),
            ),
            onTap: () {
              Get.toNamed('/player', arguments: {
                'podcaster': podcasterDate,
                'episodes': latestList,
                'index': index
              });
            },
          ),
          if (index < 2)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40.0).w,
              child: const Divider(
                thickness: 1,
                color: Colors.white,
              ),
            ),
        ],
      );
    },
  );
}

String getPodcasts = """
  query GetPodcasts(
    \$languageFilter: String,
    \$first: Int, 
    \$podcastsSortBy: PodcastSortType!,
    \$episodeDirection: SortDirection,
    \$episodesortBy: EpisodeSortType!
  ){
    podcasts(
      filters: {language: \$languageFilter,},
      first: \$first, 
      sort: {sortBy: \$podcastsSortBy},
    ){
      data{
        id
        title
        imageUrl
        episodes(
          sort:{sortBy: \$episodesortBy, direction:\$episodeDirection}
        ){
            data{
              id
              title
              audioUrl
              htmlDescription
            }
        }
      }
    }
  }
""";
