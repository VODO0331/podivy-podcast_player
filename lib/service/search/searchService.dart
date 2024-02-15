import 'dart:developer' as dev show log;
import 'package:get/get.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:podivy/Controller/ClientGlobalController.dart';
import 'package:podivy/model/Episode.dart';
import 'package:podivy/model/Search.dart';
import 'package:podivy/service/search/searchErrorException.dart';
import 'package:podivy/model/Podcaster.dart';

//functional programming

Future<Map?> getSearchData(SearchService searchService) async {
  if (searchService.keywords == null || searchService.keywords == "") {
    return null;
  }
  final Map? data = await _getData(searchService: searchService) as Map?;
  if (data == null) {
    dev.log('data is empty');
  }
  return data;
}

Future<Object?> _getData({required SearchService searchService}) async {
  try {
    var result = await _queryResult(searchService: searchService);
    if (result == null || result.hasException) {
      dev.log(result?.exception.toString() ?? 'Query result is null');
      throw GenericAuthException();
    }
    final List? podcasts = result.data?['podcasts']['data'];
    final List? episodes = result.data?['episodes'] != null
        ? result.data!['episodes']['data']
        : null;
    return searchDataProcessing(podcasts, episodes);
  } on Exception catch (e) {
    dev.log(e.toString());
    throw QueryResultException;
  }
}

Map<String, List<Object>?>? searchDataProcessing(
  List? podcasts,
  List? episodes,
) {
  if (podcasts == null && episodes == null) return null;
  List<Podcaster>? podcastList = podcasts
      ?.map((podcast) => Podcaster(
            id: podcast['id'],
            title: podcast['title'],
            imageUrl: podcast['imageUrl'],
          ))
      .toList();
  List<Episode>? episodeList = episodes
      ?.map((episode) => Episode(
            id: episode['id'],
            title: episode['title'],
            imageUrl: episode['podcast']['imageUrl'],
            audioUrl: episode['audioUrl'],
            description: episode['description'],
            airDate: episode['airDate'],
            podcast: Podcaster(
              id: episode['podcast']['id'],
              title: episode['podcast']['title'],
              imageUrl: episode['podcast']['imageUrl'],
            ),
          ))
      .toList();
  return {'podcastList': podcastList, 'episodeList': episodeList};
}

Future<QueryResult?> _queryResult(
    {required SearchService searchService}) async {
  final ClientGlobalController controller = Get.find();
  final GraphQLClient client = controller.client;
  try {
    var result = await client.query(searchService.queryOptions);
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
