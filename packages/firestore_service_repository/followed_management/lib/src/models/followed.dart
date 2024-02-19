import 'package:cloud_firestore/cloud_firestore.dart';

import '../service/constants.dart';

class Followed {
  final String podcastId;
  final String podcastImg;
  final String podcastName;

  Followed({
    required this.podcastId,
    required this.podcastImg,
    required this.podcastName,
  });

  Followed.fromSnapshot(QueryDocumentSnapshot<Map<String, dynamic>> snapshot)
      : podcastId = snapshot.data()[followingPodcastId] as String,
        podcastName = snapshot.data()[followingPodcastName] as String,
        podcastImg = snapshot.data()[followingPodcastImg] as String;
}
