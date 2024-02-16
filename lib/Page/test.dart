import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'dart:developer' as dev show log;



class TestPage extends StatefulWidget {
  const TestPage({super.key});

  @override
  State<TestPage> createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> with TickerProviderStateMixin {
  final GlobalKey<ScaffoldState> sKey = GlobalKey<ScaffoldState>();
 


  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        key: sKey,
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: 
          Query(
            options: QueryOptions(
              document: gql(getPodcasts),
              variables: const {
                'languageFilter': 'zh',
                'first': 6,
                'sortBy': 'FOLLOWER_COUNT',
                'sortdirection': 'DESCENDING',
                'episodesFirst':1,
                'categoriesFilter': ['News'],
                //FOLLOWER_COUNT ASCENDING
              },
            ),
            builder: (result, {fetchMore, refetch}) {
              if (result.hasException) {
                dev.log(result.exception.toString());
                return Text(result.exception.toString());
              }

              if (result.isLoading) {
                return const CircularProgressIndicator();
              }

              List? getPodcasts = result.data?['podcasts']?['data'];
              if (getPodcasts == null) {
                return const Text('No repositories');
              }

              return ListView.builder(
                  itemCount: getPodcasts.length,
                  itemBuilder: (context, index) {
                    final repository = getPodcasts[index];
                    // print(repository);
                    // final slug = getPodcasts[index]['categories'];s
                    return TextButton(
                        onPressed: () {
                          // dev.log(repository);
                        },
                        child: Text(repository['title']?? 'fail'));
                  });
            },
          ),
        ));
  }

}
String getPodcasts = """
  query GetPodcasts(
     \$languageFilter: String,
     \$first : Int, 
     \$episodesFirst: Int,
     \$categoriesFilter :[String],
     \$sortBy: PodcastSortType!,
     \$sortdirection: SortDirection,
  ){
    podcasts(
      filters: {
        language: \$languageFilter,
        categories: \$categoriesFilter
      },
      first: \$first, 
      sort: {sortBy: \$sortBy, direction: \$sortdirection},
    ){
      data {
        id
        title
        imageUrl
        categories {
          slug
        }
        episodes(first: \$episodesFirst) {
          data {
            title
            audioUrl
          }
        }
      }
    }
  }
""";

// \$categoriesFilter :[String] categories: \$categoriesFilter
// sort: {sortBy: \$sortBy, direction: \$sortdirection},
//\$sortBy: PodcastSortType!,
//  \$sortdirection: SortDirection,

