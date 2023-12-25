import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:get/get.dart';
import 'dart:developer' as dev show log;

class PlayerPage extends StatefulWidget {
  const PlayerPage({Key? key});

  @override
  State<PlayerPage> createState() => _PlayerPageState();
}

class _PlayerPageState extends State<PlayerPage> {
  final String getEpisodeID = Get.arguments['id'];
  final String getUrl = Get.arguments['url'];
  bool isPlaying = false;
  double progress = 0.0;
  Duration duration = Duration.zero;
  Duration position = Duration.zero;
  AudioPlayer _audioPlayer = AudioPlayer();

  @override
  void initState() {
    super.initState();
    setAudio(getUrl);
    _audioPlayer.onPlayerStateChanged.listen((state) {
      setState(() {
        isPlaying = state == PlayerState.playing;
      });
    });

    _audioPlayer.onDurationChanged.listen((newDuration) {
      setState(() {
        duration = newDuration;
      });
    });
    _audioPlayer.onPositionChanged.listen((newPosition) {
      setState(() {
        position = newPosition;
      });
    });
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
        options: QueryOptions(
          document: gql(getEpisode),
          variables: {'episodeID': getEpisodeID, 'identifierType': 'PODCHASER'},
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

          Map? getEpisodeData = result.data?['episode'];

          if (getEpisodeData == null) {
            return const Text('No repositories');
          }
          Map getPodcast = getEpisodeData['podcast'];

          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _buildSongCover(getPodcast),
              _buildSongInfo(getEpisodeData,getPodcast),
              const SizedBox(height: 20),
              _buildProgressBar(),
              _buildTimeLabels(),
              const SizedBox(height: 20),
              _buildControlButtons(),
              const SizedBox(height: 20),
              _buildNavigationButtons(),
            ],
          );
        },
      ),
    );
  }

  Widget _buildSongCover(Map? getPodcast) {
    return Container(
      width: 200,
      height: 200,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        image: DecorationImage(
          image: NetworkImage(getPodcast!['imageUrl']),
        ),
      ),
    );
  }

  Widget _buildSongInfo(Map getEpisodeData, Map getPodcast) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 6).w,
          child: Text(
            getEpisodeData['title'],
            style: TextStyle(fontSize: ScreenUtil().setSp(15)),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        Text(
          getPodcast['title'],
          style: const TextStyle(fontSize: 16, color: Colors.grey),
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildProgressBar() {
    return Slider(
      min: 0,
      max: duration.inSeconds.toDouble(),
      value: position.inSeconds.toDouble(),
      onChanged: (value) async {
        final position = Duration(seconds: value.toInt());
        await _audioPlayer.seek(position);
        await _audioPlayer.resume();
      },
    );
  }

  Widget _buildTimeLabels() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24).w,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(formatTime(position)),
          Text(formatTime(duration)),
        ],
      ),
    );
  }

  Widget _buildControlButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          icon: const Icon(Icons.replay_10),
          onPressed: () {
            // Handle rewind logic
          },
        ),
        const SizedBox(width: 20),
        IconButton(
          icon: Icon(isPlaying ? Icons.pause : Icons.play_arrow),
          iconSize: 50,
          onPressed: () async {
            if (isPlaying) {
              await _audioPlayer.pause();
            } else {
              await _audioPlayer.resume();
            }
          },
        ),
        const SizedBox(width: 20),
        IconButton(
          icon: const Icon(Icons.forward_10),
          onPressed: () {
            // Handle fast forward logic
          },
        ),
      ],
    );
  }

  Widget _buildNavigationButtons() {
    return Column(
      children: [
        IconButton(
          icon: const Icon(Icons.skip_previous),
          onPressed: () {
            // Handle previous track logic
          },
        ),
        const SizedBox(height: 20),
        IconButton(
          icon: const Icon(Icons.skip_next),
          onPressed: () {
            // Handle next track logic
          },
        ),
      ],
    );
  }

  String formatTime(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = twoDigits(duration.inHours);
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return [
      if (duration.inHours > 0) hours,
      minutes,
      seconds,
    ].join(':');
  }

  Future<void> setAudio(String url) async {
    _audioPlayer.setReleaseMode(ReleaseMode.stop);
    await _audioPlayer.play(UrlSource(url));
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

