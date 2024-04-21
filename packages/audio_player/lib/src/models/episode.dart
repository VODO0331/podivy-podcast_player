import 'package:audio_service/audio_service.dart';

import 'podcaster.dart';


class Episode {
  final String id;
  final String title;
  final String audioUrl;
  final String imageUrl;
  final String description;
  final DateTime airDate;
  final Podcaster podcast;

  Episode(
      {required this.id,
      required this.title,
      required this.audioUrl,
      required this.imageUrl,
      required this.description,
      required this.airDate,
      required this.podcast});
  factory Episode.defaultEpisode() => Episode(
      id: 'id',
      title: 'title',
      audioUrl: 'audioUrl',
      imageUrl: 'imageUrl',
      description: 'description',
      airDate: DateTime(10),
      podcast: Podcaster(id: 'id', title: 'title'));

  MediaItem toMediaItem() => MediaItem(
        id: id,
        title: title,
        artist: podcast.title,
        displayDescription: description,
        artUri: Uri.parse( imageUrl),
        extras: {
          'podcasterId':podcast.id
        }
      );
}
