import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'dart:developer' as dev show log;

class TestPage extends StatefulWidget {
  const TestPage({super.key});

  @override
  State<TestPage> createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> with TickerProviderStateMixin {
  final GlobalKey<ScaffoldState> sKey = GlobalKey<ScaffoldState>();

  Future<Uint8List> imgCompress() async {
    try {
      XFile data = XFile("assets/images/userPic/defaultUser.png");
      Uint8List imageData = await data.readAsBytes();
      final imgData = await FlutterImageCompress.compressWithList(
        imageData,
        minHeight: 400,
        minWidth: 400,
        format: CompressFormat.png,
      );
      return imgData;
    } on CompressError catch (e) {
      dev.log(e.message);
      throw Exception();
    } catch (e) {
      dev.log(e.toString());
      throw Exception();
    }
  }

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
            child: FutureBuilder(
              future: imgCompress(),
              builder: (context, snapshot) {
                if(snapshot.connectionState == ConnectionState.done){
                  if(snapshot.hasError || !snapshot.hasData){
                  return const Center( child: Text("error"),);
                }else{
                  final data=  snapshot.data;
                  return Center(child: Image.memory(data!),);
                }
                }else{
                  return const Center(child: CircularProgressIndicator(),);
                }
              },
            )));
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

