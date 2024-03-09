import 'package:cloud_firestore/cloud_firestore.dart';

import '../service/constant.dart';

class Interests {
  final String category;
  final int value;

  Interests({required this.category, required this.value});

  Interests.fromSnapshot(QueryDocumentSnapshot<Map<String, dynamic>> snapshot)
      : category = snapshot.data()[categoryName],
        value = snapshot.data()[interestsValue];
}
