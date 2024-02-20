import 'podcaster.dart';

class Episode {
  final String id;
  final String title;
  final String audioUrl;
  final String imageUrl;
  final String description;
  final DateTime airDate;
  final Podcaster? podcast;

  Episode(
      {required this.id,
      required this.title,
      required this.audioUrl,
      required this.imageUrl,
      required this.description,
      required this.airDate,
      this.podcast});
}
