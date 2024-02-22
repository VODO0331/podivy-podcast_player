import 'package:authentication_repository/authentication_repository.dart'
    show AuthService;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:search_service/search_service_repository.dart'
    show Episode, Podcaster;
import 'dart:developer' as dev show log;
import '../error_exception/cloud_storage_exception.dart';
import '../models/list.dart';
import 'constants.dart';

class ListManagement {
  get _userId => AuthService.firebase().currentUser!.id;
  final CollectionReference<Map<String, dynamic>> _user =
      FirebaseFirestore.instance.collection("user");
  late final CollectionReference<Map<String, dynamic>> _lists;
  ListManagement() {
    _lists = _user.doc(_userId).collection("lists");
  }

  // //建立List 時 至少要有一個Episode
  // static Future<void> addList(Episode episode, String listTitle) async {
  //   final list = user.doc(_userId).collection("$listTitle(list)");
  // }

  //**注意** firestore 再刪除doc時 不會刪除子集合
  //所以List被刪除時其內容還會存在
  Future<void> deleteList() async {}
  Future<void> test() async {
    await _lists.doc('test').set({listName: "testName"});
  }

  Future<void> addEpisodeToList(String listTitle, Episode episode) async {
    final DocumentReference<Map<String, dynamic>> targetDoc =
        _lists.doc(listTitle).collection('content').doc(episode.id);
    await _lists.doc(listTitle).set({listName: listTitle});
    //新增Episode
    await targetDoc
        .set({
          listName: listTitle,
          episodeId: episode.id,
          podcasterId: episode.podcast!.id,
          episodeImg: episode.imageUrl,
          episodeName: episode.title,
          episodeAudio: episode.audioUrl,
          episodeDescription: episode.description,
          episodeDate: episode.airDate,
        })
        .then((value) => dev.log("Episode added successfully!"))
        .catchError((e) {
          dev.log(e);
          throw CloudNotCreateException();
        });
  }

  Future<void> deleteEpisodeFromList(String listTitle, Episode episode) async {
    final DocumentReference<Map<String, dynamic>> targetDoc =
        _lists.doc(listTitle).collection('content').doc(episode.id);
    dev.log(episode.id);
    await targetDoc
        .delete()
        .then((value) => dev.log("Episode delete successfully!"))
        .catchError((e) {
      dev.log(e);
      throw CloudDeleteException();
    });
  }

  Future<void> updateList(String oldListTitle, String newListTitle) async {
    final Map<Object, Object?> updates = <Object, Object?>{
      listName: newListTitle
    };
    await _lists.doc(oldListTitle).update(updates);
  }

  Stream<Iterable<UserList>> readList() {
    try {
      return _lists
          .snapshots()
          .map((event) => event.docs.map((doc) => UserList.fromSnapshot(doc)));
    } catch (_) {
      throw CloudNotGetException();
    }
  }

  Stream<Iterable<Episode>> readListContent(String listTitle) {
    try {
      return _lists.doc(listTitle).collection('content').snapshots().map(
          (event) => event.docs.map((e) => Episode(
              id: e.data()[episodeId] as String,
              podcast: Podcaster(id: e.data()[podcasterId] as String),
              title: e.data()[episodeName] as String,
              audioUrl: e.data()[episodeAudio] as String,
              imageUrl: e.data()[episodeImg] as String,
              description: e.data()[episodeDescription] as String,
              airDate: e.data()[episodeDate] as DateTime)));
    } catch (_) {
      throw CloudNotGetException();
    }
  }
}
