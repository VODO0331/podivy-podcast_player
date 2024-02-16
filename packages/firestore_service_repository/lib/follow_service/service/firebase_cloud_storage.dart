
import 'package:authentication_repository/service/auth_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firestore_service_repository/follow_service/error_exception/cloud_storage_exception.dart';
import 'package:firestore_service_repository/follow_service/models/followed.dart';
import 'dart:developer' as dev show log;

import 'constants.dart';

class PodcastFollowedStorage {
  String get userId => AuthService.firebase().currentUser!.id;
  final CollectionReference<Map<String, dynamic>> userIF =
      FirebaseFirestore.instance.collection("user");
  late final CollectionReference<Map<String, dynamic>> followed;

  static final PodcastFollowedStorage _shard =
      PodcastFollowedStorage._shardInstance();
  PodcastFollowedStorage._shardInstance() {
    followed = userIF.doc(userId).collection('followed');
  }
  factory PodcastFollowedStorage() => _shard;

  Future<void> addFollowed({
    required podcastId,
    required podcastImg,
    required podcastName,
  }) async {
    return await followed
        .doc(podcastId)
        .set({
          ownerUserId: userId,
          followingPodcastId: podcastId,
          followingPodcastName: podcastName,
          followingPodcastImg: podcastImg,
        })
        .then((value) => dev.log("Podcast added successfully!"))
        .catchError((error) => dev.log(error));
  }

  Future<void> deleteFollowed({required String podcastId}) async {
    try {
      await followed
          .doc(podcastId)
          .delete()
          .then((value) => dev.log("Podcast delete successfully!"))
          .catchError((error) => dev.log(error));
    } catch (_) {
      throw CloudNotDeleteAllNoteException();
    }
  }

  Future<void> updateFollowed() async {
    return;
  }

  Future<bool> isFollowed(String podcastId) async {
    return followed
        .where(followingPodcastId, isEqualTo: podcastId)
        .count()
        .get()
        .then((value) {
      if (value.count != 0) {
        return true;
      } else {
        return false;
      }
    });
  }

  Stream<Iterable<Followed>> allFollowed() {
    final allFollowed = followed
        .snapshots()
        .map((event) => event.docs.map((doc) => Followed.fromSnapshot(doc)));
    return allFollowed;
  }
}
