import 'dart:developer' as dev show log;
import 'package:get/get.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:search_service/src/service/query.dart';
import '../controller/client_global_controller.dart';
import '../error_exception/search_error_exception.dart';

import '../models/episode.dart';
import '../models/podcaster.dart';

//functional programming

Future<Podcaster?> getSinglePodcasterData(Podcaster podcastData) async {
  return await _getData(podcastData: podcastData) as Podcaster;
}

// //完成LatestList 處理
// Future<List<Podcaster>?> getLatestList(
//     SearchServiceForLatestList? latestList) async {}

Future<Object?> _getData({
  required Podcaster podcastData,
}) async {
  try {
    var result = await _queryResult(podcastData: podcastData);
    if (result == null) return null;
    if (result.hasException) {
      dev.log(result.exception.toString());
      throw GenericAuthException();
    }
    Map? getPodcast = result.data?['podcast'];
    List? getEpisodes = getPodcast?['episodes']['data'];
    final Podcaster? data =
        singlePodcastDataProcessing(getPodcast, getEpisodes);

    return data; // Podcaster
  } on Exception catch (e) {
    dev.log(e.toString());
    throw QueryResultException;
  }
}

Podcaster? singlePodcastDataProcessing(
  Map? podcast,
  List? episodes,
) {
  if (podcast == null) return null;

  try {
    List<Episode> episodeList = [];
    if (episodes != null) {
      for (var episode in episodes) {
        episodeList.add(Episode(
          id: episode['id'],
          title: episode['title'],
          imageUrl: podcast['imageUrl'],
          audioUrl: episode['audioUrl'],
          description: episode['description'],
          airDate: DateTime.parse(episode['airDate']),
          podcast: Podcaster(
              id: podcast['id'],
              title: podcast['title'],
              imageUrl: podcast['imageUrl']),
        ));
      }
    }

    List categories = [];
    for (var category in podcast['categories']) {
      categories.add(category['title']);
    }

    final Podcaster podcaster = Podcaster(
      id: podcast['id'],
      title: podcast['title'],
      imageUrl: podcast['imageUrl'],
      categories: categories,
      language: podcast['language'],
      description: podcast['description'],
      socialLinks: SocialLinks(
        twitter: podcast['socialLinks']['twitter'],
        facebook: podcast['socialLinks']['facebook'],
        instagram: podcast['socialLinks']['instagram'],
      ),
      episodesList: episodeList,
    );
    return podcaster;
  } catch (_) {
    throw DataProcessingException();
  }
}

Future<QueryResult?> _queryResult({
  required Podcaster podcastData,
}) async {
  final ClientGlobalController controller = Get.find();
  final GraphQLClient client = controller.client;
  try {
    late QueryResult result;
    result = await client.query(QueryOptions(
      document: gql(queryPodcastData),
      variables: {
        'podcastId': podcastData.id,
        'identifierType': 'PODCHASER',
        'episodesFirst': podcastData.numberOfEpisodesResults,
        'episodesortBy': 'AIR_DATE',
        'episodedirection': 'DESCENDING'
      },
    ));

    if (result.hasException) {
      dev.log(result.exception.toString());
      throw QueryException;
    }
    return result;
  } catch (e) {
    dev.log(e.toString());
    throw QueryException;
  }
}
