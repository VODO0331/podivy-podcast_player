import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:text_scroll/text_scroll.dart';
import 'package:get/get.dart';
import 'dart:developer' as dev show log;

class PlayerPage extends StatefulWidget {
  const PlayerPage({super.key});

  @override
  State<PlayerPage> createState() => _PlayerPageState();
}

class _PlayerPageState extends State<PlayerPage> {
  final String getEpisodeID = Get.arguments;

  bool isPlaying = false;
  double progress = 0.3; // 示例进度值
  AudioPlayer _audioPlayer = AudioPlayer();

  void playAudio(String audioUrl) {
    _audioPlayer.play(UrlSource(audioUrl));
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Music Player'),
        ),
        body: Query(
          options: QueryOptions(document: gql(getEpisode), variables: {
            'episodeID': getEpisodeID,
            'identifierType': 'PODCHASER'
          }),
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

            Map? getEpisodeData = result.data?['episode'];

            if (getEpisodeData == null) {
              return const Text('No repositories');
            }
            Map? getPodcast = getEpisodeData['podcast'];
            dev.log(getEpisodeData.toString());
            dev.log(getPodcast.toString());
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // 歌曲封面
                Container(
                  width: 200,
                  height: 200,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                        image: NetworkImage(
                            getPodcast!['imageUrl']) // 可以替换成实际的封面图片
                        ),
                    // 歌曲封面图片可以放在这里
                  ),
                ),
                // 歌曲信息
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: TextScroll(
                    getEpisodeData['title'],
                    fadedBorder: true,
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold),
                    intervalSpaces: 12,
                    velocity: const Velocity(pixelsPerSecond: Offset(80, 0)),
                    delayBefore: const Duration(seconds: 1),
                    pauseBetween: const Duration(seconds: 2),
                  ),
                ),
                Text(
                  getPodcast['title'],
                  style: const TextStyle(fontSize: 16, color: Colors.grey),
                ),
                const SizedBox(height: 20),
                // 进度条
                Slider(
                  value: progress,
                  onChanged: (value) {
                    setState(() {
                      progress = value;
                    });
                  },
                ),
                const SizedBox(height: 20),
                // 控制按钮
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // 快退按钮
                    IconButton(
                      icon: const Icon(Icons.replay_10),
                      onPressed: () {
                        // 处理快退逻辑
                      },
                    ),
                    const SizedBox(width: 20),
                    // 播放/暂停按钮
                    IconButton(
                      icon: Icon(isPlaying ? Icons.pause : Icons.play_arrow),
                      iconSize: 50,
                      onPressed: () {
                        setState(() {
                          isPlaying = !isPlaying;
                          playAudio(getEpisodeData['audioUrl']);
                        });
                      },
                    ),
                    const SizedBox(width: 20),
                    // 快进按钮
                    IconButton(
                      icon: const Icon(Icons.forward_10),
                      onPressed: () {
                        // 处理快进逻辑
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                // 上一曲按钮
                IconButton(
                  icon: const Icon(Icons.skip_previous),
                  onPressed: () {
                    // 处理上一曲逻辑
                  },
                ),
                const SizedBox(height: 20),
                // 下一曲按钮
                IconButton(
                  icon: const Icon(Icons.skip_next),
                  onPressed: () {
                    // 处理下一曲逻辑
                  },
                ),
              ],
            );
          },
        ));
  }
}

String getEpisode = """
  query  getEpisode(
    \$episodeID : String!
    \$identifierType : EpisodeIdentifierType!
  ){
   episode(identifier:{id: \$episodeID, type:\$identifierType}){
        id,
        title,
        airDate,
        audioUrl,
        length,
        podcast{
            title
            imageUrl
        }
   }
}

""";
