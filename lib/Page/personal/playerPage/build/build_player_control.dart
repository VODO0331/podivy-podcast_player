import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:modify_widget_repository/modify_widget_repository.dart';
import 'package:podivy/util/dialogs/cannot_play.dart';
import 'package:podivy/util/dialogs/description_dialog.dart';
import 'dart:developer' as dev show log;

import 'package:search_service/search_service_repository.dart';

typedef ImgCallback = String? Function(String? newImageUrl);
class PlayerControl extends StatefulWidget {
  final List<Episode> getEpisodeList;
  final Podcaster? podcasterData;
  final int getIndex;
  final ImgCallback onParameterChanged;

  const PlayerControl({
    super.key,
    required this.getEpisodeList,
    required this.podcasterData,
    required this.getIndex,
    required this.onParameterChanged,
  });

  @override
  State<PlayerControl> createState() => _PlayerControlState();
}

class _PlayerControlState extends State<PlayerControl> {
  late int currentIndex;
  late String getUrl;
  late Episode getEpisodeData;
  late String? currentImageUrl;
  bool isPlaying = false;
  double progress = 0.0;
  Duration duration = Duration.zero;
  Duration position = Duration.zero;
  late AudioPlayer _audioPlayer;

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
    currentIndex = widget.getIndex;
    getEpisodeData = widget.getEpisodeList[currentIndex];
    getUrl = getEpisodeData.audioUrl;

    currentImageUrl = widget.podcasterData?.imageUrl ?? getEpisodeData.imageUrl;

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
    // _audioPlayer.setAudioContext(AudioContext(android: AudioContextAndroid()));
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildSongInfo(
            getEpisodeData, widget.podcasterData ?? getEpisodeData.podcast!),
        SizedBox(height: 20.h),
        _buildProgressBar(),
        _buildTimeLabels(),
        SizedBox(height: 20.h),
        _buildControlButtons(),
      ],
    );
  }

  Widget _buildSongInfo(Episode getEpisodeData, Podcaster getPodcaster) {
    return GestureDetector(
      onTap: () async {
        await showDescriptionDialog(context, getEpisodeData.description);
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
                getEpisodeData.title,
                style: TextStyle(fontSize: ScreenUtil().setSp(15)),
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                getPodcaster.title!,
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
            onPressed: currentIndex == 0 ? null : _playPreviousEpisode),
        const SizedBox(width: 20),
        IconButton(
          icon: const Icon(Icons.replay_10),
          onPressed: () => _rewind(),
        ),
        const SizedBox(width: 20),
        IconButton(
          icon: Icon(isPlaying ? Icons.pause : Icons.play_arrow),
          iconSize: 50,
          onPressed: _togglePlayPause,
        ),
        const SizedBox(width: 20),
        IconButton(
          icon: const Icon(Icons.forward_10),
          onPressed: () => _forward(),
        ),
        const SizedBox(width: 20),
        IconButton(
            icon: const Icon(Icons.skip_next),
            onPressed: () {
              if (currentIndex != widget.getEpisodeList.length - 1) {
                _playNextEpisode();
              }
            }),
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
    try {
      _audioPlayer.setReleaseMode(ReleaseMode.stop);
      await _audioPlayer.play(UrlSource(url));
    } catch (e) {
      context.mounted
          ? await showPlayErrorDialog(context, '音訊錯誤，請收聽其他節目')
          : null;
      dev.log('Unexpected error: $e');
    }
  }

  Future<void> _playEpisode(int index) async {
    setState(() {
      dev.log(currentImageUrl ?? "null");
      currentIndex = index; // 更新 currentIndex
      getEpisodeData = widget.getEpisodeList[currentIndex];
      getUrl = getEpisodeData.audioUrl;
      isPlaying = false;
      
    });
    //如果EpisodeList 為隨機EpisodeList(e.g. 搜尋出來的EpisodeList,個人List)
    currentImageUrl = getEpisodeData.imageUrl;
    if (currentImageUrl != null) {
      widget.onParameterChanged(currentImageUrl);
    }
  dev.log(currentImageUrl ?? "null");
    await setAudio(getUrl);
    await _audioPlayer.resume();
  }

  void _rewind() async {
    final newPosition = position - const Duration(seconds: 10);
    await _audioPlayer.seek(newPosition);
  }

  void _forward() async {
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
      final newIndex = currentIndex - 1;
      await _playEpisode(newIndex);
    }
  }

  void _playNextEpisode() async {
    if (currentIndex < widget.getEpisodeList.length - 1) {
      final newIndex = currentIndex + 1;
      await _playEpisode(newIndex);
    }
  }
}
