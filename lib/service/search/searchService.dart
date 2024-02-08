import 'dart:developer' as dev show log;
import 'package:get/get.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:podivy/Controller/ClientGlobalController.dart';
import 'package:podivy/model/Episode.dart';
import 'package:podivy/model/Search.dart';
import 'package:podivy/service/search/searchErrorException.dart';
import 'package:podivy/model/Podcaster.dart';

//functional programming

Future<Map?> getSearchData(SearchService? searchService) async {
  if (searchService == null) return null;
  if (searchService.keywords != null && searchService.keywords != "") {
    final Map? data = await _getData(searchService: searchService) as Map?;

    if (data == null) {
      dev.log('data is empty');
      return null;
    }

    return data;
  }
  return null;
}

Future<Podcaster?> getSinglePodcasterData(Podcaster? podcastData) async {
  if (podcastData == null) return null;
  return await _getData(podcastData: podcastData) as Podcaster;
}

//完成LatestList 處理
Future<List<Podcaster>?> getLatestList(
    SearchServiceForLatestList? latestList) async {}

Future<Object?> _getData({
  SearchService? searchService,
  Podcaster? podcastData,
}) async {
  try {
  if (searchService != null) {
    var result = await _queryResult(searchService: searchService);
    if (result == null) return null;
    if (result.hasException) {
      dev.log(result.exception.toString());
      throw GenericAuthException();
    }
    final List? podcasts = result.data?['podcasts']['data'];
    late List? episodes;
    if(result.data?['episodes'] != null){
      episodes = result.data!['episodes']['data'];
    }else{
      episodes = null;
    }
    
    final Map? data = searchDataProcessing(
      podcasts, //List<Podcaster>?
      episodes, //List<Episode>?
    );
    return data;
  }
  
  if (podcastData != null) {
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
  }
  return null;
} on Exception catch (e) {
  dev.log(e.toString());
  throw QueryResultException;
}
}

Podcaster? singlePodcastDataProcessing(
  Map? podcast,
  List? episodes,
) {
  if (podcast == null && podcast == null) return null;
  List<Episode>? episodeList = [];

  try {
    if (episodes != null) {
      for (int i = 0; i < episodes.length; i++) {
        final Map episode = episodes[i];
        final Episode episodesInfo = Episode(
          id: episode['id'],
          title: episode['title'],
          imageUrl: podcast['imageUrl'],
          audioUrl: episode['audioUrl'],
          description: episode['description'],
          airDate: episode['airDate'],
        );
        episodeList.add(episodesInfo);
      }
    }

    final Podcaster podcaster = Podcaster(
      id: podcast['id'],
      title: podcast['title'],
      imageUrl: podcast['imageUrl'],
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

Map<String, List<Object>?>? searchDataProcessing(
  List? podcasts,
  List? episodes,
) {
  if (podcasts == null && episodes == null) return null;
  List<Podcaster>? podcastList = [];
  List<Episode>? episodeList = [];

  try {
    if (podcasts != null) {
      for (int i = 0; i < podcasts.length; i++) {
        final Map podcast = podcasts[i];
        final Podcaster podcasterInfo = Podcaster(
          id: podcast['id'],
          title: podcast['title'],
          imageUrl: podcast['imageUrl'],
        );
        podcastList.add(podcasterInfo);
      }
    }
    if (episodes != null) {
      for (int i = 0; i < episodes.length; i++) {
        final Map episode = episodes[i];
        final Podcaster podcaster = Podcaster(
          id: episode['podcast']['id'],
          title: episode['podcast']['title'],
          imageUrl: episode['podcast']['imageUrl'],
        );
        final Episode episodesInfo = Episode(
          id: episode['id'],
          title: episode['title'],
          imageUrl: episode['podcast']['imageUrl'],
          audioUrl: episode['audioUrl'],
          description: episode['description'],
          airDate: episode['airDate'],
          podcast: podcaster,
        );
        episodeList.add(episodesInfo);
      }
    }
    final Map<String, List<Object>?> result = {
      'podcastList': podcastList,
      'episodeList': episodeList
    };
    return result;
  } catch (_) {
    throw DataProcessingException();
  }
}

Future<QueryResult?> _queryResult({
  SearchService? searchService,
  Podcaster? podcastData,
}) async {
  final ClientGlobalController controller = Get.find();
  final GraphQLClient client = controller.client;
  try {
    late QueryResult result;
    if (searchService != null) {
      result = await client.query(searchService.queryOptions);
    }
    if (podcastData != null) {
      result = await client.query(podcastData.queryOptions);
    }
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
