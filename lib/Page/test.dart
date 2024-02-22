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
  final Episode testEpisode = Episode(
      id: '123',
      title: '123',
      audioUrl: '123',
      imageUrl: '123',
      description: '123',
      airDate: DateTime(2203),
      podcast: Podcaster(id: '123'));

  @override
  void initState() {
    super.initState();
    listManagement = ListManagement();
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
                  await listManagement.addEpisodeToList(
                      'testListName', testEpisode);
                },
                child: const Text("addEpisodeToList"),
              ),
              ElevatedButton(
                onPressed: () async {
                  await listManagement.deleteEpisodeFromList(
                      'testListName', testEpisode);
                },
                child: const Text("DeleteEpisodeFromList"),
              )
            ])));
  }
}


// \$categoriesFilter :[String] categories: \$categoriesFilter
// sort: {sortBy: \$sortBy, direction: \$sortdirection},
//\$sortBy: PodcastSortType!,
//  \$sortdirection: SortDirection,

