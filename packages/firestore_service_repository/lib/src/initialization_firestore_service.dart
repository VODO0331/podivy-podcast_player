import 'package:authentication_repository/authentication_repository.dart';
import 'package:firestore_service_repository/src/services/firestore_service_provider.dart';

import 'package:get/get.dart';
import 'dart:developer' as dev show log;
import '../error_exception/cloud_storage_exception.dart';

Future<void> initializationMyFirestoreService(String loginMethod) async {
  try {
  late final AuthService authService;
  switch (loginMethod) {
    case 'Firebase':
      authService = Get.put(AuthService.firebase());
    case 'Google':
      authService = Get.put(AuthService.google());
    default:
    throw CloudInitException();
  }
  
  Get.put(FirestoreServiceProvider(authService));
} on Exception catch (_) {
  dev.log('firestore init fail');
  throw CloudInitException();
}
}
