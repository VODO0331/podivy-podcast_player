import 'package:firestore_service_repository/firestore_service_repository.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'dart:developer' as dev show log;

import 'package:search_service/search_service_repository.dart';

class MyAudioPlayer {
  final AudioPlayer _audioPlayer = AudioPlayer();
  final ListManagement _listManagement =ListManagement();
  late final List<Episode> _episodeList;
  final Rx<Episode?> _currentEpisodeData = Episode.defaultEpisode().obs;
  final int index;
  final Rx<Duration> _currentPosition = Duration.zero.obs;
  final Rx<Duration> _currentDuration = Duration.zero.obs;
  AudioPlayer get player => _audioPlayer;
  Rx<Episode?> get episodeData => _currentEpisodeData;
  Rx<Duration> get duration => _currentDuration;
  Rx<Duration> get position => _currentPosition;

  MyAudioPlayer({required List<Episode> episodeList, required this.index}) {
    _episodeList = episodeList;
    _currentEpisodeData.value = episodeList[index];
    _listManagement.addToHistory(_currentEpisodeData.value!);
    _init();
    _sliderChanges();
    _indexChanges();
  }

  void _indexChanges() {
    _audioPlayer.currentIndexStream.listen((index) {
      if (index != null) {
        _currentEpisodeData.value = _episodeList[index];
        _listManagement.addToHistory(_currentEpisodeData.value!);
      }
    });
  }

  Future<void> seek(Duration? position, {int? index}) =>
      _audioPlayer.seek(position, index: index);

  Future<void> _init() async {
    _audioPlayer.playbackEventStream.listen((event) {},
        onError: (Object e, StackTrace stack) {
      //
      dev.log("Stream error", name: 'AudioPlayer');
    });
    try {
      
      await _audioPlayer.setAudioSource(
        listProcessing(),
        initialIndex: index,
        initialPosition: Duration.zero,
      );
      await _audioPlayer.play();
    } catch (e) {
      dev.log("error loading playlist", name: "AudioPlayer");
    }
  }

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

  ConcatenatingAudioSource listProcessing() {
    final List<AudioSource> resultList = [];
    for (int i = 0; i < _episodeList.length; i++) {
      final episode = _episodeList[i];

      resultList.add(AudioSource.uri(Uri.parse(episode.audioUrl),
          tag: episode.toMediaItem()));
    }
    return ConcatenatingAudioSource(
        useLazyPreparation: true,
        children: resultList,
        shuffleOrder: DefaultShuffleOrder());
  }

  void dispose() {
    _audioPlayer.dispose();
  }
}
