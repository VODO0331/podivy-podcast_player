import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:internationalization_repository/internationalization.dart';
import 'package:intl/intl.dart';

import '../service/query.dart';

// import 'dart:developer' as dev show log;
//利用語言分類 改變
//根據使用者  追隨清單 改變 SearchServiceForLatestList 資料
sealed class SearchService {
  final String keywords;
  final int numberOfEpisodesResults;
  final int numberOfPodcastResults;
  final QueryOptions queryOptions;

  SearchService({
    required this.numberOfEpisodesResults,
    required this.numberOfPodcastResults,
    required this.keywords,
    required this.queryOptions,
  });
}

class SearchServiceForKeyword extends SearchService {
  SearchServiceForKeyword({
    required super.keywords,
    super.numberOfPodcastResults = 6,
    super.numberOfEpisodesResults = 15,
  }) : super(
            queryOptions: QueryOptions(
          document: gql(queryForKeyword),
          variables: {
            'searchTerm': keywords,
            'podcastFirst': numberOfPodcastResults,
            'episodesFirst': numberOfEpisodesResults,
            'episodesSortBy': 'RELEVANCE',
            'sortDirection': 'DESCENDING',
            'podcastSort':'RELEVANCE',
            'airDateForm':
                DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime(2019)),
            'airDateTo':
                DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now())
          },
        ));
}

class SearchServiceForCategories extends SearchService {
  SearchServiceForCategories({
    required super.keywords,
    super.numberOfPodcastResults = 6,
    super.numberOfEpisodesResults = 15,
  }) : super(
            queryOptions: QueryOptions(
          document: gql(queryForCategories),
          variables: {
            'categories': keywords,
            'podcastFirst': numberOfPodcastResults,
            'language': TranslationService().currentLanguage,
            'episodesFirst': numberOfEpisodesResults,
            'episodesSortBy': 'FOLLOWER_COUNT',
            'sortDirection': 'DESCENDING',
            'podcastSort':'FOLLOWER_COUNT',
            'airDateForm':
                DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime(2019)),
            'airDateTo':
                DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now())
          },
        ));
}

class SearchServiceForExploreContent extends SearchServiceForCategories {
  SearchServiceForExploreContent({
    required super.keywords,
    super.numberOfPodcastResults = 4,
    // required super.language,
  });
  @override
  QueryOptions get queryOptions {
    return QueryOptions(
      document: gql(queryForExploreContent),
      variables: {
        'language': TranslationService().currentLanguage,
        'categories': keywords,
        'podcastFirst': numberOfPodcastResults,
        'includeRemoved':false,
        'podcastsSortBy': 'DATE_OF_FIRST_EPISODE',
      },
    );
  }
}


