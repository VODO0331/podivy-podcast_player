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
    initialization();
  }

  Future<void> initialization() async {
    if (await _lists.doc("TagList").get().then((value) => !value.exists)) {
      await _user
          .doc(_userId)
          .collection("lists")
          .doc('TagList')
          .set({listName: 'TagList'});
    }
    if (await _lists.doc("History").get().then((value) => !value.exists)) {
      await _user
          .doc(_userId)
          .collection("lists")
          .doc('History')
          .set({listName: 'History'});
    }
  }

  Future<void> addListToHistory(Episode episode) async {
    final historyList = _user
        .doc(_userId)
        .collection("lists")
        .doc('History')
        .collection('content');
    final number = await historyList.count().get().then((value) => value.count);
    //限制數量
    if (number != null && number >= 10) {
      final data = await historyList
          .orderBy('createAt', descending: false)
          .limit(1)
          .get();
      final oldestDoc = data.docs.first;
      await historyList.doc(oldestDoc.id).delete();
    }
    await addEpisodeToList(UserList(listTitle: 'History'), episode);
  }

  //**注意** firestore 再刪除doc時 不會刪除子集合
  //所以List被刪除時其內容還會存在
  Future<void> deleteList(UserList list) async {
    await _lists
        .doc(list.listTitle)
        .collection('content')
        .where(listName, isEqualTo: list.listTitle)
        .get()
        .then((value) async {
      //刪除List content
      for (var doc in value.docs) {
        await _lists
            .doc(list.listTitle)
            .collection('content')
            .doc(doc.id)
            .delete();
      }

      await _lists.doc(list.listTitle).delete(); //刪除List
    });
  }

  Future<void> addEpisodeToList(UserList list, Episode episode) async {
    final DocumentReference<Map<String, dynamic>> targetDoc =
        _lists.doc(list.listTitle).collection('content').doc(episode.id);
    await _lists.doc(list.listTitle).set({listName: list.listTitle});
    //新增Episode
    await targetDoc
        .set({
          listName: list.listTitle,
          episodeId: episode.id,
          podcasterId: episode.podcast!.id,
          podcasterName: episode.podcast!.title,
          episodeImg: episode.imageUrl,
          episodeName: episode.title,
          episodeAudio: episode.audioUrl,
          episodeDescription: episode.description,
          episodeDate: episode.airDate,
          "createAt": Timestamp.now(),
        })
        .then((value) => dev.log("Episode added successfully!"))
        .catchError((e) {
          dev.log(e);
          throw CloudNotCreateException();
        });
  }

  Future<void> deleteEpisodeFromList(UserList list, Episode episode) async {
    final DocumentReference<Map<String, dynamic>> targetDoc =
        _lists.doc(list.listTitle).collection('content').doc(episode.id);
    dev.log(episode.id);
    await targetDoc
        .delete()
        .then((value) => dev.log("Episode delete successfully!"))
        .catchError((e) {
      dev.log(e);
      throw CloudDeleteException();
    });
  }

  Future<void> updateList(UserList oldList, String newListTitle) async {
    final Map<Object, Object?> updates = <Object, Object?>{
      listName: newListTitle
    };
    await _lists.doc(oldList.listTitle).update(updates);
  }

  Stream<Iterable<UserList>> readAllList() {
    try {
      return _lists
          .where(
            listName,
            whereNotIn: ['TagList', 'History'],
          )
          // .where(listName, isNotEqualTo: 'History')
          .snapshots()
          .map((event) => event.docs.map((doc) => UserList.fromSnapshot(doc)));
    } catch (_) {
      throw CloudNotGetException();
    }
  }

  Stream<Iterable<Episode>> readListContent(UserList list) {
    try {
      return _lists
          .doc(list.listTitle)
          .collection('content')
          .orderBy('createAt', descending: true)
          .snapshots()
          .map((event) => event.docs.map((e) => Episode(
                id: e.data()[episodeId] as String,
                podcast: Podcaster(
                    id: e.data()[podcasterId] as String,
                    title: e.data()[podcasterName] as String),
                title: e.data()[episodeName] as String,
                audioUrl: e.data()[episodeAudio] as String,
                imageUrl: e.data()[episodeImg] as String,
                description: e.data()[episodeDescription] as String,
                airDate: (e.data()[episodeDate].toDate()) as DateTime,
              )));
    } catch (_) {
      throw CloudNotGetException();
    }
  }
}
