import 'package:authentication_repository/authentication_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firestore_service_repository/firestore_service_repository.dart';

import 'dart:developer' as dev show log;

import '../../../../error_exception/cloud_storage_exception.dart';

import '../models/follow.dart';
import 'constants.dart';

class FollowManagement {
  late final CollectionReference<Map<String, dynamic>> _follow;

  FollowManagement(AuthService authService) {
    String userId = authService.currentUser!.id;
    _follow = FirebaseFirestore.instance
        .collection("user")
        .doc(userId)
        .collection('follow');
  }

  Future<void> addFollow({
    required String podcastId,
    required String? podcastImg,
    required String? podcastName,
    required List? podcastCategory,
  }) async {
    await _follow
        .doc(podcastId)
        .set({
          followingPodcastId: podcastId,
          followingPodcastName: podcastName,
          followingPodcastImg: podcastImg,
          followingCategory: podcastCategory,
        })
        .then((value) => dev.log("Podcast added successfully!"))
        .catchError((error) {
          dev.log(error);
          throw CloudNotCreateException();
        });
  }

  Future<bool> unfollow({required String podcastId}) async {
    bool result = false;
    await _follow.doc(podcastId).delete().then((value) {
      dev.log("Podcast delete successfully!");
      result = true;
    }).catchError((error) {
      dev.log(error);
      throw FollowDeleteException();
    });
    return result;
  }

  Future<bool> haveFollow(String podcastId) async {
    return _follow
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

  Stream<Iterable<Follow>> homePageViewFollow() {
    try {
      return _follow.limit(3).snapshots().map((event) {
        List<Follow> followedList = [];
        for (var doc in event.docs) {
          followedList.add(Follow.fromSnapshot(doc));
        }
        return followedList;
      });
    } catch (_) {
      throw CloudNotGetException();
    }
  }

  Stream<Iterable<Follow>> allFollow() {
    try {
      return _follow.snapshots().map((event) {
        List<Follow> followedList = [];
        for (var doc in event.docs) {
          followedList.add(Follow.fromSnapshot(doc));
        }
        return followedList;
      });
    } catch (_) {
      throw CloudNotGetException();
    }
  }

  Future<void> deleteUser() async {
    await _follow.get().then((snapshot) async {
      for (DocumentSnapshot follow in snapshot.docs) {
        await follow.reference.delete();
      }
    });
  }
}
