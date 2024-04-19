import 'dart:developer' as dev show log;

import 'package:get/get.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import '../controller/client_global_controller.dart';
import '../models/episode.dart';
import '../models/podcaster.dart';
import '../models/search.dart';
import '../error_exception/search_error_exception.dart';

//functional programming

Future<({List<Podcaster> podcastList, List<Episode> episodeList})>
    getSearchData(
        (
          SearchServiceForKeyword,
          SearchServiceForCategories
        ) searchService) async {
  // if (searchService.keywords == null || searchService.keywords == "") {
  //   return ;
  // }
  ({List<Podcaster> podcastList, List<Episode> episodeList}) data;
  if (searchService.$1.keywords != '') {
    data = await _getData(searchService: searchService.$1);
  } else {
    data = await _getData(searchService: searchService.$2);
  }

  return data;
}

Future<({List<Podcaster> podcastList, List<Episode> episodeList})>
    getGridViewData(SearchServiceForExploreContent searchService) async {
  
  final data = await _getData(searchService:searchService);

  return data;
}

Future<({List<Podcaster> podcastList, List<Episode> episodeList})> _getData(
    {required SearchService searchService}) async {
  try {
    var result = await _queryResult(searchService: searchService);

    final List? podcasts = result.data?['podcasts']['data'];
    final List? episodes = result.data?['episodes'] != null
        ? result.data!['episodes']['data']
        : null;
    return _dataProcessing(podcasts, episodes);
  } catch (e) {
    dev.log("_getData : ${e.toString()}");
    throw QueryResultException;
  }
}

({List<Podcaster> podcastList, List<Episode> episodeList}) _dataProcessing(
  List? podcasts,
  List? episodes,
) {
  try {
    List<Podcaster> podcastList = [];
    for (var podcast in podcasts!) {
      podcastList.add(Podcaster(
        id: podcast['id'],
        title: podcast['title'],
        imageUrl: podcast['imageUrl'],
      ));
    }

    List<Episode> episodeList = [];
    if (episodes != null) {
      for (var episode in episodes) {
        episodeList.add(Episode(
          id: episode['id'],
          title: episode['title'],
          imageUrl: episode['podcast']['imageUrl'],
          audioUrl: episode['audioUrl'],
          description: episode['description'],
          airDate: DateTime.parse(episode['airDate']),
          podcast: Podcaster(
            id: episode['podcast']['id'],
            title: episode['podcast']['title'],
            imageUrl: episode['podcast']['imageUrl'],
          ),
        ));
      }
    }

    return (podcastList: podcastList, episodeList: episodeList);
  } catch (e) {
    dev.log("searchDataProcessing: ${e.toString()}");
    throw DataProcessingException();
  }
}

Future<QueryResult> _queryResult({required SearchService searchService}) async {
  final ClientGlobalController controller = Get.put(ClientGlobalController());
  final GraphQLClient client = controller.client;
  
  try {
    var result = await client.query(searchService.queryOptions);
    if (result.hasException || result.data == null) {
      dev.log("_queryResult: ${result.exception.toString()}");
      throw QueryException;
    }
    return result;
  } catch (e) {
    dev.log("_queryResult: ${e.toString()}");
    throw QueryException;
  }
}
