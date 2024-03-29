
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:developer' as dev show log;


import '../../../error_exception/cloud_storage_exception.dart';
import '../../user_id.dart';
import '../models/followed.dart';
import 'constants.dart';

class FollowedManagement {
  final _userId = userId;
  final CollectionReference<Map<String, dynamic>> user =
      FirebaseFirestore.instance.collection("user");
  late final CollectionReference<Map<String, dynamic>> followed;

  static final FollowedManagement _shard = FollowedManagement._shardInstance();
  FollowedManagement._shardInstance() {
    followed = user.doc(_userId).collection('followed');
  }
  factory FollowedManagement() => _shard;

  Future<void> addFollowed({
    required String podcastId,
    required String? podcastImg,
    required String? podcastName,
  }) async {
    await followed
        .doc(podcastId)
        .set({
          followingPodcastId: podcastId,
          followingPodcastName: podcastName,
          followingPodcastImg: podcastImg,
        })
        .then((value) => dev.log("Podcast added successfully!"))
        .catchError((error) {
          dev.log(error);
  throw CloudNotCreateException();
        });
  }

  Future<bool> deleteFollowed({required String podcastId}) async {
     bool result = false;
    await followed
        .doc(podcastId)
        .delete()
        .then((value) {
          dev.log("Podcast delete successfully!");
          result =  true;
        })
        .catchError((error) {
      dev.log(error);
      throw CloudDeleteException();
    });
    return result;
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
  Stream<Iterable<Followed>> homePageViewFollowed() {
    try {
      return followed.limit(3).snapshots().map((event) {
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
      return followed.snapshots().map((event) {
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
}
