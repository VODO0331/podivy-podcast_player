

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:glass/glass.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:podivy/widget/drawer.dart';
import 'package:podivy/widget/userAvatar.dart';
import 'package:text_scroll/text_scroll.dart';
import 'package:get/get.dart';
import 'dart:developer' as dev show log;

class PodcasterPage extends StatelessWidget {
  PodcasterPage({super.key});
  final String podcasterId = Get.arguments;
  final GlobalKey<ScaffoldState> sKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onHorizontalDragUpdate: (details) {
        if (details.primaryDelta != 0 && details.primaryDelta! > 10) {
          sKey.currentState?.openDrawer();
        }
      },
      child: Scaffold(
        key: sKey,
        drawer: const MyDrawer(),
        body: Query(
          options: QueryOptions(
            document: gql(getPodcast),
            variables: {
              'podcastId': podcasterId,
              'identifierType': 'PODCHASER',
              'episodesFirst': 30,
              'episodesortBy': 'AIR_DATE',
              'episodedirection': 'DESCENDING'
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

            Map? getPodcast = result.data?['podcast'];
            List? getEpisodes = getPodcast?['episodes']['data'];

            if (getPodcast == null) {
              return const Text('No repositories');
            }
            return Column(
              children: [
                _buildProfileInformation(getPodcast),
                _buildEpisodesSection(getEpisodes),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildProfileInformation(Map? podcasterdata) {
    return Stack(
      children: [
        ShaderMask(
          shaderCallback: (Rect bounds) {
            return const LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.black, Colors.transparent],
            ).createShader(bounds);
          },
          blendMode: BlendMode.dstIn,
          child: Image.network(
            podcasterdata!['imageUrl'],
            fit: BoxFit.cover,
            height: 300.h,
            width: double.infinity,
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(15, 60, 15, 0).r,
          child: Container(
            height: 220.h,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              color: Colors.black45,
            ),
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
                      icon: const Icon(Icons.arrow_back_ios_rounded),
                    ),
                    IconButton(
                      iconSize: 35.r,
                      onPressed: () {},
                      icon: const Icon(Icons.more_vert_sharp),
                    ),
                  ],
                ),
                const Divider(),
                Padding(
                  padding: const EdgeInsets.only(left: 8, top: 5).r,
                  child: Row(
                    children: [
                      _buildUserAvatar(podcasterdata),
                      Flexible(
                        child: _buildTextScroll(podcasterdata),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ).asGlass(),
        )
      ],
    );
  }

  Widget _buildUserAvatar(Map? podcasterdata) {
    return UserAvatar(
      imgPath: podcasterdata!['imageUrl'],
      radius: 60,
      borderThickness: 65,
      isNetwork: true,
      color: const Color(0xFFABC4AA),
    );
  }

  Widget _buildTextScroll(Map? podcasterdata) {
    return TextScroll(
      podcasterdata!['title'] ?? 'Unknown Title',
      style: TextStyle(
        fontSize: ScreenUtil().setSp(20),
      ),
      intervalSpaces: 5,
      velocity: const Velocity(pixelsPerSecond: Offset(60, 0)),
      delayBefore: const Duration(seconds: 3),
      pauseBetween: const Duration(seconds: 10),
      fadedBorder: true,
    );
  }

  Widget _buildEpisodesSection(List? getEpisodes) {
    return Expanded(
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF7B7060),
              Color(0xFF2C271D),
            ],
            stops: [
              0.7,
              1
            ],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0).r,
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: () {
                      print('sort');
                    },
                    icon: const Icon(Icons.sort_sharp),
                  ),
                  Text('${getEpisodes!.length} 部'),
                ],
              ),
              const Divider(
                thickness: 1,
              ),
              _buildEpisodesList(getEpisodes),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEpisodesList(List? getEpisodes) {
    return Expanded(
      child: ListView.builder(
        padding: EdgeInsets.zero,
        itemCount: getEpisodes!.length,
        itemBuilder: (BuildContext context, int index) {
          final getEpisode = getEpisodes[index];

          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 10).h,
            child: ListTile(
              title: Text(
                getEpisode['title'] ?? 'Unknown Title',
                overflow: TextOverflow.ellipsis,
              ),
              trailing: const Icon(Icons.more_vert),
              onTap: () {
                Get.toNamed("/player", arguments: {
                  'id':getEpisode['id'],
                  'url':getEpisode['audioUrl'],
                });
              },
            ),
          );
        },
      ),
    );
  }
}

String getPodcast = """
  query GetPodcast(
    \$podcastId : String!,
    \$identifierType : PodcastIdentifierType!,
    \$episodesFirst : Int,
    \$episodesortBy : EpisodeSortType!,
    \$episodedirection : SortDirection,
){
    podcast(identifier : {id : \$podcastId , type: \$identifierType}){
      title
      imageUrl
      language
      socialLinks{
        twitter
        facebook
        instagram
      } 
      episodes(first : \$episodesFirst, 
      sort:{sortBy: \$episodesortBy, direction: \$episodedirection}){
        data {
          id
          title
          audioUrl
        }
      }
    }
  }
     
  
  
""";
