import 'package:cloud_firestore/cloud_firestore.dart';
import '../service/constants.dart';

class UserList {
  final String listTitle;
  final String docId;

  UserList(  {
    required this.docId,
    required this.listTitle,
  });

  UserList.fromSnapshot(QueryDocumentSnapshot<Map<String, dynamic>> snapshot)
      : listTitle = snapshot.data()[listName] as String,
      docId = snapshot.data()[documentId] as String;
}
