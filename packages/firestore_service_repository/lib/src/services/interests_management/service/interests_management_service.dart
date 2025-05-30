import 'package:authentication_repository/authentication_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'constant.dart';
import '../model/interests.dart';
import '../../../../error_exception/cloud_storage_exception.dart';
// import 'dart:developer' as dev show log;

class InterestsManagement {
  late final CollectionReference<Map<String, dynamic>> _interests;

  InterestsManagement(AuthService authService) {
    String userId = authService.currentUser!.id;
    _interests = FirebaseFirestore.instance
        .collection("user")
        .doc(userId)
        .collection("interests");
    _initialization();
  }

  Future<void> _initialization() async {
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

  Future<void> updateInterests(List? categories, bool isAdd) async {
    if (categories == null) return;

    final int incrementValue = isAdd ? 1 : -1;

    for (var category in categories) {
      final docRef = _interests.doc(category);

      await docRef.get().then((doc) {
        if (doc.exists) {
          docRef.update({interestsValue: FieldValue.increment(incrementValue)});
        } else {
          docRef.set({categoryName: category, interestsValue: incrementValue});
        }
      }).catchError((error, stackTrace) {
        throw CloudNotUpdateException();
      });
    }
  }

  Stream<Iterable<Interests>> readInterests() {
    try {
      return _interests
          .orderBy(interestsValue, descending: true)
          .limit(5)
          .snapshots()
          .map((event) {
        List<Interests> interestsList = [];
        for (var doc in event.docs) {
          interestsList.add(Interests.fromSnapshot(doc));
        }
        return interestsList;
      });
    } catch (_) {
      throw CloudNotGetException();
    }
  }

  Future<void> deleteUser() async {
    await _interests.get().then((snapshot) {
      for (DocumentSnapshot interest in snapshot.docs) {
        interest.reference.delete();
      }
    });
  }
}
