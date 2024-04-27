import 'dart:developer' as dev show log;
import 'package:get/get.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:my_audio_player/my_audio_player.dart';
import 'package:search_service/src/service/query.dart';
import '../controller/client_controller.dart';
import '../error_exception/search_error_exception.dart';

//functional programming
const numberOfEpisodesResults = 10;


Future<Podcaster?> getSinglePodcasterData({required String id}) async {
  return await _getData(id: id,numberOfEpisodesResults: numberOfEpisodesResults);
}

Future<Podcaster> _getData({
  required String id,
  required int numberOfEpisodesResults,
}) async {
  try {
    var result = await _queryResult(id: id);

    if (result.hasException) {
      dev.log(result.exception.toString());
      throw GenericAuthException();
    }
    Map? getPodcast = result.data?['podcast'];
    List? getEpisodes = getPodcast?['episodes']['data'];
    final Podcaster? data = _dataProcessing(getPodcast, getEpisodes);
    if (data != null) {
      return data;
    } else {
      throw QueryResultException;
    }
  } on Exception catch (e) {
    dev.log(e.toString());
    throw QueryResultException;
  }
}

Podcaster? _dataProcessing(
  Map? podcast,
  List? episodes,
) {
  if (podcast == null || episodes == null) return null;

  try {
    List<Episode> episodeList = [];

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

Future<QueryResult> _queryResult({
  required String id,
}) async {
  final ClientController controller = Get.put(ClientController());
  final GraphQLClient client = controller.client;
  try {
    late QueryResult result;
    result = await client.query(QueryOptions(
      document: gql(queryPodcastData),
      variables: {
        'podcastId': id,
        'identifierType': 'PODCHASER',
        'episodesFirst': numberOfEpisodesResults,
        'episodesortBy': 'AIR_DATE',
        'episodedirection': 'DESCENDING'
      },
    ));

    if (result.hasException || result.data == null) {
      dev.log(result.exception.toString());
      throw QueryException;
    }
    return result;
  } catch (e) {
    dev.log(e.toString());
    throw QueryException;
  }
}
