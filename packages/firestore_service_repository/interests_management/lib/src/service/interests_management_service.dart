import 'package:authentication_repository/authentication_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:interests_management/src/model/interests.dart';
import './constant.dart';
import 'dart:developer' as dev show log;

import '../error_exception/cloud_storage_exception.dart';

class InterestsManagement {
  get _userId => AuthService.firebase().currentUser!.id;
  final CollectionReference<Map<String, dynamic>> _user =
      FirebaseFirestore.instance.collection("user");
  late final CollectionReference<Map<String, dynamic>> _interests;

  InterestsManagement() {
    _interests = _user.doc(_userId).collection("interests");
  }

  Future<void> addInterests() async {
    if (await _interests.doc("News").get().then((value) => !value.exists)) {
      List<String> defaultCategory = [
        "News",
        "Comedy",
        "Society",
        "Culture",
        "Film"
      ];
      for (int i = 0; i < defaultCategory.length; i++) {
        await _interests.doc(defaultCategory[i]).set({
          categoryName: defaultCategory[i],
          interestsValue: 1,
        });
      }
    }
  }

  Future<void> updateInterests(Interests interests) async {
    final docRef = _interests.doc(interests.category);

    docRef.set({
      interestsValue: interests.value + 1,
    }, SetOptions(merge: true)).onError(
        (error, _) => dev.log(error.toString()));
  }

  Stream<Iterable<Interests>> interestsCategory() {
    try {
      final interests = _interests
          .orderBy(interestsValue)
          .limit(5)
          .snapshots()
          .map((event) => event.docs.map((doc) => Interests.fromSnapshot(doc)));
      return interests;
    } catch (_) {
      throw CloudNotGetException();
    }
  }
}
