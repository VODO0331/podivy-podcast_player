import 'package:get/get.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

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
  final QueryOptions<Object> queryOptions;
  final int numberOfEpisodesResults;
  final String? title;
  final String? imageUrl;
  final String? language;
  final String? description;
  final SocialLinks? socialLinks;
  final List<Episode>? episodesList;
  Podcaster({
    required this.id,
    this.title,
    this.imageUrl,
    this.language,
    this.description,
    this.socialLinks,
    this.episodesList,
    this.numberOfEpisodesResults = 4,
  })  : 
        queryOptions = QueryOptions(
          document: gql(_queryPodcastData),
          variables: {
            'podcastId': id,
            'identifierType': 'PODCHASER',
            'episodesFirst': numberOfEpisodesResults,
            'episodesortBy': 'AIR_DATE',
            'episodedirection': 'DESCENDING'
          },
        );
}

const String _queryPodcastData = """
  query GetPodcast(
    \$podcastId : String!,
    \$identifierType : PodcastIdentifierType!,
    \$episodesFirst : Int,
    \$episodesortBy : EpisodeSortType!,
    \$episodedirection : SortDirection,
){
    podcast(identifier : {id : \$podcastId , type: \$identifierType}){
      id
      title
      imageUrl
      language
      description
      numberOfEpisodes
      socialLinks{
        twitter
        facebook
        instagram
      } 
      episodes(first : \$episodesFirst, 
      sort:{sortBy: \$episodesortBy, direction: \$episodedirection}){
        data {
          id
          title
          audioUrl
          description
          airDate
          
        }
      }
    }
  }
     
  
""";
