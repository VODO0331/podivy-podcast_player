import 'package:authentication_repository/authentication_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:interests_management/src/service/constans.dart';

class InterestsManagement {
  get _userId => AuthService.firebase().currentUser!.id;
  final db = FirebaseFirestore.instance;
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
          interestsValue: 1,
        });
      }
    }
  }
}
