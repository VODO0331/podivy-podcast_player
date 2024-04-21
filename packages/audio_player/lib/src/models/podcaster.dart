
import 'episode.dart';
import 'social_link.dart';



class Podcaster {
  final String id;
  final String title;
  final List? categories;
  final String? imageUrl;
  final String? language;
  final String? description;
  final SocialLinks? socialLinks;
  final List<Episode>? episodesList;

  Podcaster(
      {required this.id,
       required this.title,
       this.categories,
       this.imageUrl,
       this.language,
       this.description,
       this.socialLinks,
       this.episodesList});


       
}
