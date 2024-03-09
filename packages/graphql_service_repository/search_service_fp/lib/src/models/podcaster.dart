import 'package:get/get.dart';

import '../controller/client_global_controller.dart';
import 'episode.dart';

final ClientGlobalController controller = Get.find();

class SocialLinks {
  late String? twitter;
  late String? facebook;
  late String? instagram;

  SocialLinks({this.twitter, this.facebook, this.instagram});
}

class Podcaster {
  final String id;
  final int numberOfEpisodesResults;
  final String? title;
  final List? categories;
  final String? imageUrl;
  final String? language;
  final String? description;
  final SocialLinks? socialLinks;
  final List<Episode>? episodesList;

  Podcaster(
      {required this.id,
       this.numberOfEpisodesResults = 5,
       this.title,
       this.categories,
       this.imageUrl,
       this.language,
       this.description,
       this.socialLinks,
       this.episodesList});
}
