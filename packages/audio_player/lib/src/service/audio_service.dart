import 'package:firestore_service_repository/firestore_service_repository.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'dart:developer' as dev show log;

import '../../exception/player_exception.dart';
import '../models/models.dart';

class MyAudioPlayer extends ChangeNotifier {
  late AudioPlayer _audioPlayer;
  final  fsp = Get.find<FirestoreServiceProvider>();
  final Rxn<List<Episode>?> episodeList = Rxn<List<Episode>?>();
  final Rx<Episode?> _currentEpisodeData = Episode.defaultEpisode().obs;
  final RxnInt _index = RxnInt();
  final Rx<Duration> _currentPosition = Duration.zero.obs;
  final Rx<Duration> _currentDuration = Duration.zero.obs;

  //Getter
  int? get index => _index.value;
  AudioPlayer get player => _audioPlayer;
  Rx<Episode?> get episodeData => _currentEpisodeData;
  Rx<Duration> get duration => _currentDuration;
  Rx<Duration> get position => _currentPosition;
  bool get isIdle => player.playerState.processingState == ProcessingState.idle;

//constructor
  MyAudioPlayer() {
    _audioPlayer = AudioPlayer();
    _sliderChanges();
    _indexChanges();
  }

  set setPlayList(List<Episode> value) {
    if (listEquals(value, episodeList.value)) return;
    episodeList.value = value;
  }

  Future<void> init() async {
    _audioPlayer = AudioPlayer();
  }

  void setIndex(int newIndex, List<Episode> value) {
    //如果list = null
    if (episodeList.value == null) {
      setPlayList = value;
      _index.value = newIndex;
      _currentEpisodeData.value = episodeList.value![_index.value!];
      _play();
    }

    if (listEquals(value, episodeList.value)) {
      //如果 list 相同

      if (_index.value != null && _index.value != newIndex) {
        //如果List 相同、但索引不相同
        _index.value = newIndex;
        _currentEpisodeData.value = episodeList.value![_index.value!];
        _play();
      } else {
        //如果List相同、索引相同
        if (_currentEpisodeData.value!.id != value[newIndex].id) {
          //如果List相同、索引相同、播放內容不相同
          _currentEpisodeData.value = episodeList.value![_index.value!];
          _play();
        } else {
          //如果List相同、索引相同、播放內容相同
          return;
        }
      }
    } else {
      //如果list不相同
      setPlayList = value;
      _index.value = newIndex;
      _currentEpisodeData.value = episodeList.value![_index.value!];
      _play();
    }
    
  }

  Future<void> seek(Duration? position, {int? index}) =>
      _audioPlayer.seek(position, index: index);

  Future<void> _play() async {
    _audioPlayer.playbackEventStream.listen((event) {},
        onError: (Object e, StackTrace stack) {
      dev.log('playbackEventStream error');
    });
    try {
      await _audioPlayer.setAudioSource(
        listProcessing(),
        initialIndex: _index.value,
        initialPosition: Duration.zero,
      );
      fsp.list.addToHistory(_currentEpisodeData.value!);
      await _audioPlayer.play();
    } catch (e) {
      throw CanNotPlayingException();
    }
  }

  void _indexChanges() {
    _audioPlayer.currentIndexStream.listen((index) {
      if (index != null) {
        _currentEpisodeData.value = episodeList.value![index];
        fsp.list.addToHistory(_currentEpisodeData.value!);
      }
    });
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
    try {
      final List<AudioSource> resultList = [];
      for (int i = 0; i < episodeList.value!.length; i++) {
        final episode = episodeList.value![i];

        resultList.add(AudioSource.uri(Uri.parse(episode.audioUrl),
            tag: episode.toMediaItem()));
      }
      return ConcatenatingAudioSource(
          useLazyPreparation: true,
          children: resultList,
          shuffleOrder: DefaultShuffleOrder());
    } on Exception catch (_) {
      throw ListProcessingException();
    }
  }
}
