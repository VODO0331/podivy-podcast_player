import 'package:authentication_repository/authentication_repository.dart';
import 'package:firestore_service_repository/firestore_service_repository.dart';
import 'package:get/get.dart';

// get  userId =>  AuthService.firebase().currentUser!.id;
Future<void> initializationMyFirestoreService() async{
  String userId = AuthService.firebase().currentUser!.id;
  Get.put(ListManagement(userId));
  Get.put(FollowedManagement(userId));
  Get.put(InterestsManagement(userId));
  Get.put(InformationController(userId));
}
