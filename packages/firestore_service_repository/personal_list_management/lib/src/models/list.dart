import 'package:search_service/search_service_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import './constants.dart';

class UserList {
  final String listTitle;
  final int quantity;
  final Episode episode;

  UserList({
    required this.listTitle,
    required this.quantity,
    required this.episode,
  });

  UserList.fromSnapshot(QueryDocumentSnapshot<Map<String, dynamic>> snapshot)
      : listTitle = snapshot.data()[listName] as String,
        quantity = snapshot.data()[episodeQuantity] as int,
        episode = Episode(
            id: snapshot.data()[episodeId] as String,
            title: snapshot.data()[episodeName] as String,
            audioUrl: snapshot.data()[episodeAudio] as String,
            imageUrl: snapshot.data()[episodeImg] as String,
            description: snapshot.data()[episodeDescription] as String,
            airDate: snapshot.data()[episodeDate] as DateTime);
}
