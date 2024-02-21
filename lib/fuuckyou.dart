import 'package:flutter/material.dart';
// import 'dart:developer' as dev show log;

import 'package:list_management_service/personal_list_management.dart';
import 'package:search_service/search_service_repository.dart';

void main() {
  runApp(const TestPage2());
}

class TestPage2 extends StatefulWidget {
  const TestPage2({super.key});

  @override
  State<TestPage2> createState() => _TestPageState();
}

class _TestPageState extends State<TestPage2> with TickerProviderStateMixin {
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
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    listManagement;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          appBar: AppBar(),
          key: sKey,
          body: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                onPressed: () {
                  listManagement.addEpisodeToList('testList', testEpisode);
                },
                child: const Text("text"),
              ))),
    );
  }
}
