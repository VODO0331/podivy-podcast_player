import 'package:authentication_repository/authentication_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:developer' as dev show log;

import '../error_exception/cloud_storage_exception.dart';
import '../models/followed.dart';
import 'constants.dart';

class FollowedManagement {
  get userId => AuthService.firebase().currentUser!.id;
  final CollectionReference<Map<String, dynamic>> user =
      FirebaseFirestore.instance.collection("user");
  late final CollectionReference<Map<String, dynamic>> followed;

  static final FollowedManagement _shard = FollowedManagement._shardInstance();
  FollowedManagement._shardInstance() {
    followed = user.doc(userId).collection('followed');
  }
  factory FollowedManagement() => _shard;

  Future<void> addFollowed({
    required String podcastId,
    required String? podcastImg,
    required String? podcastName,
  }) async {
    try {
      await followed
          .doc(podcastId)
          .set({
            followingPodcastId: podcastId,
            followingPodcastName: podcastName,
            followingPodcastImg: podcastImg,
          })
          .then((value) => dev.log("Podcast added successfully!"))
          .catchError((error) => dev.log(error));
    } catch (_) {
      throw CloudNotCreateException();
    }
  }

  Future<void> deleteFollowed({required String podcastId}) async {
    try {
      await followed
          .doc(podcastId)
          .delete()
          .then((value) => dev.log("Podcast delete successfully!"))
          .catchError((error) => dev.log(error));
    } catch (_) {
      throw CloudDeleteException();
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
    try {
  final allFollowed = followed
      .snapshots()
      .map((event) => event.docs.map((doc) => Followed.fromSnapshot(doc)));
  return allFollowed;
} catch (_) {
  throw CloudNotGetException();
}
  }
}
