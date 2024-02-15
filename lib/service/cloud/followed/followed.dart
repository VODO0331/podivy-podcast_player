

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:podivy/service/cloud/followed/constants.dart';

class Followed {
  final String podcastId;
  final String userId;
  final String podcastImg;
  final String podcastName;

  Followed(
      {required this.userId,
        required this.podcastId,
    
      required this.podcastImg,
      required this.podcastName});


  Followed.fromSnapshot(QueryDocumentSnapshot<Map<String, dynamic>> snapshot):
    userId = snapshot.id,
    podcastId = snapshot.data()[followingPodcastId] as String,
    podcastName = snapshot.data()[followingPodcastName] as String,
    podcastImg = snapshot.data()[followingPodcastImg] as String;
  
}
