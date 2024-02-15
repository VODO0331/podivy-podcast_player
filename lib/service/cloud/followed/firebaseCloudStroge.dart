import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:podivy/service/cloud/cloudStorageException.dart';
import 'package:podivy/service/cloud/followed/constants.dart';
import 'package:podivy/service/cloud/followed/followed.dart';
import 'dart:developer' as dev show log;

import '../../auth/authService.dart';

class PodcastFollowedStorage extends GetxController {
  String get userId => AuthService.firebase().currentUser!.id;
  final CollectionReference<Map<String, dynamic>> userIF =
      FirebaseFirestore.instance.collection("user");
  late CollectionReference<Map<String, dynamic>> followed;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    followed = userIF.doc(userId).collection('followed');
  }

  static final PodcastFollowedStorage _shard =
      PodcastFollowedStorage._shardInstance();
  PodcastFollowedStorage._shardInstance();
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
