import 'package:authentication_repository/authentication_repository.dart';
import 'package:get/get.dart';

import 'follow_management/follow_management.dart';
import 'information_management/controller/information_controller.dart';
import 'interests_management/interests.management.dart';
import 'list_management/list_management.dart';

class FirestoreServiceProvider {
  FirestoreServiceProvider(AuthService authService) {
    Get.put(ListManagement(authService));
    Get.put(FollowManagement(authService));
    Get.put(InterestsManagement(authService));
    Get.put(InformationController(authService));
  }
  ListManagement get list => Get.find<ListManagement>();
  FollowManagement get follow => Get.find<FollowManagement>();
  InterestsManagement get interests => Get.find<InterestsManagement>();
  InformationController get info => Get.find<InformationController>();
}
