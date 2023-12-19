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
              document: gql(readRepositories),
              variables: {
                'podcastId': '554412', 
                'identifierType': 'PODCHASER', 
              }
                
              ,
            ),
            builder: (result, {fetchMore, refetch}) {
              if (result.hasException) {
                return Text(result.exception.toString());
              }

              if (result.isLoading) {
                return const CircularProgressIndicator();
              }

              Map? getPodcastById = result.data?['podcast'];

              if (getPodcastById == null) {
                return const Text('No repositories');
              }

              return Text(getPodcastById['title']+getPodcastById['id']+'\n'+getPodcastById['webUrl']);
              // ListView.builder(
              //     itemCount: getPodcastById.length,
              //     itemBuilder: (context, index) {
              //       final repository = getPodcastById[index];

              //       return TextButton(onPressed: (){
              //         dev.log(repository);
              //       }, child: Text(repository['title'] ?? ''));
              //     });
            },
          ),
        ));
  }

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
