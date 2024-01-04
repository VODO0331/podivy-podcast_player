import 'dart:async';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:podivy/util/dialogs/description_dialog.dart';
// import 'dart:developer' as dev show log;

class PlayerPage extends StatefulWidget {
  const PlayerPage({Key? key});

  @override
  State<PlayerPage> createState() => _PlayerPageState();
}

class _PlayerPageState extends State<PlayerPage> {
  final List getEpisodeList = Get.arguments['episodes'];
  final Map podcasterData = Get.arguments['podcaster'];
  final int getIndex = Get.arguments['index'];

  late int currentIndex;
  late String getUrl;
  late Map getEpisodeData;

  bool isPlaying = false;
  double progress = 0.0;
  Duration duration = Duration.zero;
  Duration position = Duration.zero;
  AudioPlayer _audioPlayer = AudioPlayer();

  Future<void> _playEpisode(int index) async {
    setState(() {
      currentIndex = index; // 更新 currentIndex
      final newEpisodeData = getEpisodeList[index];
      getEpisodeData = newEpisodeData;
      getUrl = newEpisodeData['audioUrl'];
      isPlaying = false; // Pause the player while loading the new episode
    });
    await setAudio(getUrl);
    await _audioPlayer.resume(); // Start playing the new episode
  }

  @override
  void initState() {
    super.initState();

    currentIndex = getIndex;
    getEpisodeData = getEpisodeList[currentIndex];
    getUrl = getEpisodeData['audioUrl'];

    Future.delayed(Duration.zero, () {
      setAudio(getUrl);
    });
    _audioPlayer.onPlayerStateChanged.listen((state) {
      if (mounted) {
        setState(() {
          isPlaying = state == PlayerState.playing;
        });
      }
    });

    _audioPlayer.onDurationChanged.listen((newDuration) {
      if (mounted) {
        setState(() {
          duration = newDuration;
        });
      }
    });

    _audioPlayer.onPositionChanged.listen((newPosition) {
      if (mounted) {
        setState(() {
          position = newPosition;
        });
      }
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
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _buildSongCover(podcasterData),
            SizedBox(height: 20.h),
            _buildSongInfo(getEpisodeData, podcasterData),
            SizedBox(height: 20.h),
            _buildProgressBar(),
            _buildTimeLabels(),
            SizedBox(height: 20.h),
            _buildControlButtons(),
          ],
        ));
  }

  Widget _buildSongCover(Map? getPodcaster) {
    return Container(
      width: 200.w,
      height: 200.h,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        image: DecorationImage(
          image: NetworkImage(getPodcaster!['imageUrl']),
        ),
      ),
    );
  }

  Widget _buildSongInfo(Map getEpisodeData, Map getPodcaster) {
    return GestureDetector(
      onTap: () async {
        await showDescriptionDialog(context, getEpisodeData['htmlDescription']);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 8).w,
        child: Container(
          padding: const EdgeInsets.all(10).w,
          decoration: BoxDecoration(
              color: const Color(0xFF8A7F6E),
              boxShadow: const [
                BoxShadow(
                  color: Colors.grey,
                  offset: Offset(0, 7),
                  blurRadius: 10,
                  spreadRadius: 2,
                ),
              ],
              borderRadius: BorderRadius.circular(20.0)),
          child: Column(
            children: [
              Text(
                getEpisodeData['title'],
                style: TextStyle(fontSize: ScreenUtil().setSp(15)),
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                getPodcaster['title'],
                style: const TextStyle(fontSize: 16, color: Colors.grey),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
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
          icon: const Icon(Icons.skip_previous),
          onPressed: currentIndex == 0 ? null : _playPreviousEpisode,
        ),
        const SizedBox(width: 20),
        IconButton(
          icon: const Icon(Icons.replay_10),
          onPressed: () {
            _rewind();
          },
        ),
        const SizedBox(width: 20),
        IconButton(
          icon: Icon(isPlaying ? Icons.pause : Icons.play_arrow),
          iconSize: 50,
          onPressed: () async {
            _togglePlayPause();
          },
        ),
        const SizedBox(width: 20),
        IconButton(
          icon: const Icon(Icons.forward_10),
          onPressed: () {
            _fastForward();
          },
        ),
        const SizedBox(width: 20),
        IconButton(
          icon: const Icon(Icons.skip_next),
          onPressed: currentIndex == getEpisodeList.length - 1
              ? null
              : _playNextEpisode,
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

  void _rewind() async {
    final newPosition = position - const Duration(seconds: 10);
    await _audioPlayer.seek(newPosition);
  }

  void _fastForward() async {
    final newPosition = position + const Duration(seconds: 10);
    await _audioPlayer.seek(newPosition);
  }

  void _togglePlayPause() async {
    if (isPlaying) {
      await _audioPlayer.pause();
    } else {
      await _audioPlayer.resume();
    }
  }

  void _playPreviousEpisode() async {
    if (currentIndex > 0) {
      // Ensure there is a previous episode
      await _playEpisode(currentIndex - 1);
    } else {}
  }

  void _playNextEpisode() async {
    if (currentIndex < getEpisodeList.length - 1) {
      // Ensure there is a next episode
      await _playEpisode(currentIndex + 1);
    }
  }
}
