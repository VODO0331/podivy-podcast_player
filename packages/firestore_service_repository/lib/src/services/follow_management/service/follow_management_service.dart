import 'package:authentication_repository/authentication_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firestore_service_repository/firestore_service_repository.dart';

import 'dart:developer' as dev show log;

import '../../../../error_exception/cloud_storage_exception.dart';

import '../models/followed.dart';
import 'constants.dart';

class FollowManagement {
   late final String _userId ;
  final CollectionReference<Map<String, dynamic>> user =
      FirebaseFirestore.instance.collection("user");
  late final CollectionReference<Map<String, dynamic>> _followed;


  FollowManagement(AuthService authService) {
    _userId = authService.currentUser!.id;
    _followed = user.doc(_userId).collection('followed');
  }
  Future<void> addFollowed({
    required String podcastId,
    required String? podcastImg,
    required String? podcastName,
    required List? podcastCategory,
  }) async {
    await _followed
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
    await _followed.doc(podcastId).delete().then((value) {
      dev.log("Podcast delete successfully!");
      result = true;
    }).catchError((error) {
      dev.log(error);
      throw CloudDeleteException();
    });
    return result;
  }

  Future<void> updateFollowed() async {
    return;
  }

  Future<bool> isFollowed(String podcastId) async {
    return _followed
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

  Stream<Iterable<Followed>> homePageViewFollowed() {
    try {
      return _followed.limit(3).snapshots().map((event) {
        List<Followed> followedList = [];
        for (var doc in event.docs) {
          followedList.add(Followed.fromSnapshot(doc));
        }
        return followedList;
      });
    } catch (_) {
      throw CloudNotGetException();
    }
  }

  Stream<Iterable<Followed>> allFollowed() {
    try {
      return _followed.snapshots().map((event) {
        List<Followed> followedList = [];
        for (var doc in event.docs) {
          followedList.add(Followed.fromSnapshot(doc));
        }
        return followedList;
      });
    } catch (_) {
      throw CloudNotGetException();
    }
  }

  Future<void> deleteUser() async {
    await _followed.get().then((snapshot) {
      for (DocumentSnapshot follow in snapshot.docs) {
        follow.reference.delete();
      }
    });
  }
}
