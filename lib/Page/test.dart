// import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:list_management_service/personal_list_management.dart';
// import 'dart:developer' as dev show log;

import 'package:search_service/search_service_repository.dart';

class TestPage extends StatefulWidget {
  const TestPage({super.key});

  @override
  State<TestPage> createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> with TickerProviderStateMixin {
  final GlobalKey<ScaffoldState> sKey = GlobalKey<ScaffoldState>();
  late final ListManagement listManagement;
  late final ListManagement listManagement2;
  late final UserList list;
  final Episode testEpisode = Episode(
      id: '123',
      title: '4565',
      audioUrl: '456',
      imageUrl: '546',
      description: '456',
      airDate: DateTime(123),
      podcast: Podcaster(id: '456'));
      final Episode testEpisode2 = Episode(
      id: '123456',
      title: '456',
      audioUrl: '456',
      imageUrl: '546',
      description: '456',
      airDate: DateTime(1234),
      podcast: Podcaster(id: '456'));

  @override
  void initState() {
    super.initState();
    listManagement = ListManagement();
    listManagement2  = ListManagement();
    list = UserList(listTitle: 'TagList');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        key: sKey,
        body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(children: [
              ElevatedButton(
                onPressed: () async {
                  await listManagement2.addEpisodeToList(
                      list, testEpisode);
                },
                child: const Text("addEpisodeToList1"),
              ),
              ElevatedButton(
                onPressed: () async {
                  await listManagement.addEpisodeToList(
                      list, testEpisode2);
                },
                child: const Text("addEpisodeToList2"),
              ),
              ElevatedButton(
                onPressed: () async {
                  await listManagement.deleteEpisodeFromList(
                      list, testEpisode2);
                },
                child: const Text("DeleteEpisodeFromList"),
              ),
              ElevatedButton(
                onPressed: () async {
                  await listManagement.deleteList(
                      list);
                },
                child: const Text("DeleteList"),
              ),
            ])));
  }
}


// \$categoriesFilter :[String] categories: \$categoriesFilter
// sort: {sortBy: \$sortBy, direction: \$sortdirection},
//\$sortBy: PodcastSortType!,
//  \$sortdirection: SortDirection,

