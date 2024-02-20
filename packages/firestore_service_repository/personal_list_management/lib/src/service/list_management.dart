import 'package:authentication_repository/authentication_repository.dart'
    show AuthService;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:list_management_service/src/error_exception/cloud_storage_exception.dart';
import 'package:list_management_service/src/models/list.dart';
import 'package:search_service/search_service_repository.dart' show Episode;

class ListManagement {
  final String listTile;

  get _userId => AuthService.firebase().currentUser!.id;
  final CollectionReference<Map<String, dynamic>> user =
      FirebaseFirestore.instance.collection("user");
  late final CollectionReference<Map<String, dynamic>> list;
  ListManagement({required this.listTile}) {
    list = user.doc(_userId).collection("$listTile(list)");
  }
  //建立List 時 必要有Episode
  Future<void> addEpisodeToList(Episode episode) async {}

  //**注意** firestore 再刪除doc時 不會刪除子集合
  Future<void> deleteEpisodeFromList() async {}
  Future<void> deleteList() async {}

  Future<void> updateList() async {}
  Stream<Iterable<UserList>> readList() {
    try {
      return list
          .snapshots()
          .map((event) => event.docs.map((doc) => UserList.fromSnapshot(doc)));
    } catch (_) {
      throw CloudNotGetException();
    }
  }
}
