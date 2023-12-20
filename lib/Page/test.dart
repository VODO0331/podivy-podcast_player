import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:podivy/Page/HomePage.dart';
import 'package:podivy/Page/mediaPage.dart';
import 'package:podivy/widget/backgound.dart';
import 'dart:developer' as dev show log;

class TestPage extends StatefulWidget {
  @override
  _TestPageState createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> with TickerProviderStateMixin {
  static const int totalPage = 2;
  final GlobalKey<ScaffoldState> sKey = GlobalKey<ScaffoldState>();
  int _currentPage = 0;
  static const List<String> names = [
    'Home',
    'Media',
  ];

  List<IconData> icons = [
    Icons.home_rounded,
    Icons.all_inbox,
  ];

  final List<Widget> _pages = [const HomePage(), const MediaPage()];

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
          padding: const EdgeInsets.all(16.0),
          child: Query(
            options: QueryOptions(
              document: gql(getPodcasts),
              variables: const {
                'laguageFilter': 'zh',
                // 'countryFilter': 'rs',
                'first': 10,
                'sortBy': 'TRENDING',
                'sortdirection': 'DESCENDING'
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
              var getResult = result.data;
              print(getResult);
              if (getPodcasts == null) {
                return const Text('No repositories');
              }

              return ListView.builder(
                  itemCount: getPodcasts.length,
                  itemBuilder: (context, index) {
                    final repository = getPodcasts[index];

                    return TextButton(
                        onPressed: () {
                          // dev.log(repository);
                        },
                        child: Text(repository['title'] ?? ''));
                  });
            },
          ),
        ));
  }

  String getPodcasts = """
  query GetPodcasts(
     \$languageFilter: String,
     \$first : Int, 
     \$sortBy: PodcastSortType!,
     \$sortdirection: SortDirection){
    podcasts(
      filters: {language: \$languageFilter}
      first: \$first, 
      sort: {sortBy: \$sortBy, direction: \$sortdirection}){
        data{
          title
        }
    }
  }
""";
  String readRepositories = """
  query GetPodcastById(\$podcastId: String!, \$identifierType: PodcastIdentifierType!) {
  podcast(identifier: { id: \$podcastId, type: \$identifierType }) {
    id
    title
    description
    webUrl
  }
}
""";

  Widget _getBottomBar() {
    return BottomNavigationBar(
      iconSize: 35.0,
      showSelectedLabels: false,
      showUnselectedLabels: false,
      currentIndex: _currentPage,
      onTap: (index) {
        _currentPage = index;
        setState(() {});
      },
      type: BottomNavigationBarType.fixed,
      items: List.generate(
        totalPage,
        (index) => BottomNavigationBarItem(
          icon: Icon(icons[index]),
          label: names[index],
        ),
      ),
    );
  }

  Widget _getBody(int index) {
    return GestureDetector(
        onHorizontalDragUpdate: (details) {
          if (details.primaryDelta != 0 && details.primaryDelta! > 10) {
            sKey.currentState?.openDrawer();
          }
        },
        child: MyBackGround(child: _pages[index]));
  }
}
