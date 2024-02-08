import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:podivy/model/Episode.dart';
import 'package:podivy/model/Podcaster.dart';
import 'package:podivy/query.dart';
// import 'dart:developer' as dev show log;

//利用語言分類 改變
//根據使用者  追隨清單 改變 SearchServiceForLatestList 資料
sealed class SearchService {
  final String? keywords;
  final int numberOfEpisodesResults;
  final int numberOfPodcastResults;
  final List<Podcaster>? podcasterList;
  final List<Episode>? episodeList;
  final QueryOptions queryOptions;
  SearchService({
    required this.numberOfEpisodesResults,
    required this.numberOfPodcastResults,
    required this.keywords,
    required this.queryOptions,
    required this.podcasterList,
    required this.episodeList,
  });
}

class SearchServiceForKeyword extends SearchService {
  SearchServiceForKeyword({
    required super.keywords,
    super.episodeList,
    super.podcasterList,
    super.numberOfPodcastResults = 3,
    super.numberOfEpisodesResults = 5,
  }) : super(
            queryOptions: QueryOptions(
          document: gql(queryForKeyword),
          variables: {
            'searchTerm': keywords,
            'podcastFirst': numberOfPodcastResults,
            'episodesFirst': numberOfEpisodesResults,
            'episodesSortBy': 'RELEVANCE',
          },
        ));
}

class SearchServiceForCategories extends SearchService {
  SearchServiceForCategories({
    required super.keywords,
    super.podcasterList,
    super.episodeList,
    super.numberOfPodcastResults = 3,
    super.numberOfEpisodesResults = 5,
  }) : super(
            queryOptions: QueryOptions(
          document: gql(queryForCategories),
          variables: {
            'categories': keywords,
            'podcastFirst': numberOfPodcastResults,
            'episodesFirst': numberOfEpisodesResults,
            'episodesSortBy': 'RELEVANCE',
          },
        ));
}

class SearchServiceForExploreContent extends SearchServiceForCategories {
  SearchServiceForExploreContent({
    required super.keywords,
    super.numberOfPodcastResults = 4,
  });
  @override
  QueryOptions get queryOptions {
    return QueryOptions(
      document: gql(queryForExploreContent),
      variables: {
        'categories': keywords,
        'podcastFirst': numberOfPodcastResults,
      },
    );
  }
}

class SearchServiceForLatestList extends SearchServiceForCategories {
  //追隨清單中 Episode更新最新 的前三個podcast , 
  //如果不足三個或Null 用隨機podcast(依照使用者喜好)
  final List<int>? idList; 
  SearchServiceForLatestList( {
    required this.idList,
    required super.keywords,
  });

  @override
  QueryOptions get queryOptions {
    return QueryOptions(
      document: gql(queryLatestList),
      variables: const {
        'languageFilter': 'ZH',
        'first': 3,
        'podcastsSortBy': 'DATE_OF_FIRST_EPISODE',
        'episodeDirection': 'DESCENDING',
        'episodesortBy': 'AIR_DATE',
      },
    );
  }
}
