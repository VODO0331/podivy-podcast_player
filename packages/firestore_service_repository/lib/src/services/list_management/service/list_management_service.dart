import 'package:authentication_repository/authentication_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_audio_player/my_audio_player.dart';

import 'dart:developer' as dev show log;
import '../../../../error_exception/cloud_storage_exception.dart';
import '../model/list.dart';
import 'constants.dart';

class ListManagement {
  late final String _userId;
  final CollectionReference<Map<String, dynamic>> _user =
      FirebaseFirestore.instance.collection("user");
  late final CollectionReference<Map<String, dynamic>> _lists;
  ListManagement(AuthService authService) {
    _userId =  authService.currentUser!.id;
    _lists = _user.doc(_userId).collection("lists");
    initialization();
  }

  Future<void> initialization() async {
    if (await _lists.doc("TagList").get().then((value) => !value.exists)) {
      await _user.doc(_userId).collection("lists").doc('TagList').set({
        documentId: "TagList",
        listName: 'TagList',
        "createAt": Timestamp.now(),
      });
    }
    if (await _lists.doc("History").get().then((value) => !value.exists)) {
      await _user.doc(_userId).collection("lists").doc('History').set({
        documentId: "History",
        listName: 'History',
        "createAt": Timestamp.now(),
      });
    }
  }

  Future<void> addToHistory(Episode episode) async {
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
    await addEpisodeToList(
        UserList(docId: "History", listTitle: "History"), episode);
  }

  //**注意** firestore 再刪除doc時 不會刪除子集合
  //所以List被刪除時其內容還會存在
  Future<bool> deleteList(UserList list) async {
    bool result = false;
    await _lists
        .doc(list.docId)
        .collection('content')
        .where(documentId, isEqualTo: list.docId)
        .get()
        .then((value) async {
      //刪除List content
      for (var doc in value.docs) {
        await _lists
            .doc(list.docId)
            .collection('content')
            .doc(doc.data()[episodeId])
            .delete();
      }

      await _lists.doc(list.docId).delete(); //刪除List
      result = true;
    });
    return result;
  }

  Future<bool> addEpisodeToList(UserList list, Episode episode) async {
    bool result = false;
    if (await _lists
        .doc(list.docId)
        .collection('content')
        .doc(episode.id)
        .get()
        .then((value) => !value.exists)) {
      final DocumentReference<Map<String, dynamic>> targetDoc =
          _lists.doc(list.docId).collection('content').doc(episode.id);
      // await _lists.doc(list.listTitle).set({listName: list.listTitle});
      //新增Episode
      await targetDoc.set({
        listName: list.listTitle,
        episodeId: episode.id,
        podcasterId: episode.podcast.id,
        podcasterName: episode.podcast.title,
        episodeImg: episode.imageUrl,
        episodeName: episode.title,
        episodeAudio: episode.audioUrl,
        episodeDescription: episode.description,
        episodeDate: episode.airDate,
        "createAt": Timestamp.now(),
      }).then((value) {
        dev.log("Episode added successfully!");
        result = true;
      }).catchError((e) {
        dev.log(e);
        throw CloudNotCreateException();
      });
    }
    return result;
  }

  Future<bool> addList(String listTitle, Episode episode) async {
    bool result = false;
    final newList = _lists.doc();
    await newList.set({
      documentId: newList.id,
      listName: listTitle,
      "createAt": Timestamp.now(),
    }).then((_) async {
      await _lists.doc(newList.id).collection('content').doc(episode.id).set({
        documentId: newList.id,
        listName: listTitle,
        episodeId: episode.id,
        podcasterId: episode.podcast.id,
        podcasterName: episode.podcast.title,
        episodeImg: episode.imageUrl,
        episodeName: episode.title,
        episodeAudio: episode.audioUrl,
        episodeDescription: episode.description,
        episodeDate: episode.airDate,
        "createAt": Timestamp.now(),
      }).then((value) {
        dev.log("Episode added successfully!");
        result = true;
      }).catchError((e) {
        dev.log(e);
        throw CloudNotCreateException();
      });
    });
    return result;
  }

  Future<bool> deleteEpisodeFromList(UserList list, Episode episode) async {
    bool result = false;

    final DocumentReference<Map<String, dynamic>> targetDoc =
        _lists.doc(list.docId).collection('content').doc(episode.id);
    dev.log(episode.id);
    await targetDoc.delete().then((value) {
      dev.log("Episode delete successfully!");
      result = true;
    }).catchError((e) {
      dev.log(e);
      throw CloudDeleteException();
    });
    return result;
  }

  Future<bool> updateList(UserList oldList, String newListTitle) async {
    bool result = false;
    final Map<Object, Object?> updates = <Object, Object?>{
      listName: newListTitle
    };
    await _lists
        .doc(oldList.docId)
        .update(updates)
        .then((value) => result = true);
    return result;
  }

  Stream<Iterable<UserList>> readAllList() {
    try {
      return _lists
          .where(
            listName,
            whereNotIn: ['TagList', 'History'],
          )
          .snapshots()
          .map((event) {
            List<UserList> userList = [];
            for (var doc in event.docs) {
              userList.add(UserList.fromSnapshot(doc));
            }
            return userList;
          });
    } catch (_) {
      dev.log(_.toString());
      throw CloudNotGetException();
    }
  }

  Stream<Iterable<Episode>> readListContent(UserList list) {
    try {
      return _lists
          .doc(list.docId)
          .collection('content')
          .orderBy('createAt', descending: true)
          .snapshots()
          .map((event) {
        final episodes = <Episode>[];
        for (final e in event.docs) {
          episodes.add(Episode(
            id: e.data()[episodeId] as String,
            podcast: Podcaster(
              id: e.data()[podcasterId] as String,
              title: e.data()[podcasterName] as String,
              imageUrl: e.data()[episodeImg] as String,
            ),
            title: e.data()[episodeName] as String,
            audioUrl: e.data()[episodeAudio] as String,
            imageUrl: e.data()[episodeImg] as String,
            description: e.data()[episodeDescription] as String,
            airDate: (e.data()[episodeDate].toDate()) as DateTime,
          ));
        }
        return episodes;
      });
    } catch (_) {
      throw CloudNotGetException();
    }
  }

  Future<void> deleteUser() async {
    await _lists.get().then((snapshot) {
      for (DocumentSnapshot list in snapshot.docs) {
        final Map<String, dynamic> targetList =
            list.data() as Map<String, dynamic>;
        //搜尋list內由沒有episode，如果有就刪除
        //如果沒刪除list內的內容，firestore並不會刪除子集合(list content)
        final CollectionReference<Map<String, dynamic>> contents =
            _lists.doc(targetList[documentId]).collection('content');
        contents.get().then((value) {
          for (DocumentSnapshot content in value.docs) {
            content.reference.delete();
          }
        });
        //刪除清單
        list.reference.delete();
      }
    });
  }

 
}
