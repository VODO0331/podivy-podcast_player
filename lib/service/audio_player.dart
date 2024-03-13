import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'dart:developer' as dev show log;

import 'package:search_service/search_service_repository.dart';

class MyAudioPlayer {
  final AudioPlayer _audioPlayer = AudioPlayer();
  final Rx<Episode> _currentEpisodeData = Episode.defaultEpisode().obs;
  final List<Episode> episodeList;
  final int index;
  final Rx<Duration> _currentPosition = Duration.zero.obs;
  final Rx<Duration> _currentDuration = Duration.zero.obs;
  final RxString _currentImageUrl = ''.obs;

  Rx<Duration> get duration => _currentDuration;
  Rx<Duration> get position => _currentPosition;
  int? get previousIndex => _audioPlayer.previousIndex;
  int? get currentIndex => _audioPlayer.currentIndex;
  Rx<String> get currentImageUrl => _currentImageUrl;
  Rx<Episode> get currentEpisodeData => _currentEpisodeData;
  Future<void> get dispose => _audioPlayer.dispose();
  Stream<int?> get currentIndexStream => _audioPlayer.currentIndexStream;
  Stream<bool> get playingStream => _audioPlayer.playingStream;

  MyAudioPlayer({required this.episodeList, required this.index}) {
    _currentEpisodeData.value = episodeList[index];
    currentImageUrl.value = currentEpisodeData.value.imageUrl;
    _initAudioPlayer();
    _sliderChanges();
    _indexChanges();
  }
  void _imgChanged() {
    if (_currentImageUrl.value !=
        episodeList[_audioPlayer.currentIndex!].imageUrl) {
      _currentImageUrl.value = episodeList[_audioPlayer.currentIndex!].imageUrl;
    }
  }

  Future<void> seek(Duration? position, {int? index}) =>
      _audioPlayer.seek(position, index: index);

  void _sliderChanges() {
    _audioPlayer.positionStream.listen((position) {
      _currentPosition.value = position;
    });
    _audioPlayer.durationStream.listen((duration) {
      if (duration != null) {
        _currentDuration.value = duration;
      }
    });
  }

  void _indexChanges() {
    _audioPlayer.currentIndexStream.listen((index) {
      if (index != null) {
        _currentEpisodeData.value = episodeList[index];
      }
    });
  }

  void _initAudioPlayer() async {
    try {
      await _audioPlayer.setAudioSource(
        listProcessing(),
        initialIndex: index,
        initialPosition: Duration.zero,
      );
      await _audioPlayer.play();

      // isPlaying = true;
    } catch (e) {
      dev.log("設定音訊來源時發生錯誤：$e");
    }
  }

  ConcatenatingAudioSource listProcessing() {
    final List<AudioSource> resultList = [];
    for (int i = 0; i < episodeList.length; i++) {
      final episode = episodeList[i];

      resultList.add(AudioSource.uri(Uri.parse(episode.audioUrl),
          tag: episode.toMediaItem()));
    }
    return ConcatenatingAudioSource(
        useLazyPreparation: true,
        children: resultList,
        shuffleOrder: DefaultShuffleOrder());
  }

  void togglePlayPause() async {
    if (_audioPlayer.playing) {
      await _audioPlayer.pause();
    } else {
      await _audioPlayer.play();
    }
  }

  void playPreviousEpisode() async {
    await _audioPlayer.seekToPrevious();
    _imgChanged();
    await _audioPlayer.play();
  }

  void playNextEpisode() async {
    await _audioPlayer.seekToNext();
    _imgChanged();
    await _audioPlayer.play();
  }

  void durationChanges(bool isForward) async {
    final Duration newDuration;
    if (isForward) {
      newDuration = const Duration(seconds: 10);
    } else {
      newDuration = const Duration(seconds: -10);
    }
    await _audioPlayer.seek(_currentPosition.value + newDuration);
  }
}
