import 'package:authentication_repository/authentication_repository.dart';
import 'package:firestore_service_repository/src/services/firestore_service_provider.dart';

import 'package:get/get.dart';
import 'dart:developer' as dev show log;
import '../error_exception/cloud_storage_exception.dart';

Future<void> initializationMyFirestoreService(AuthService authService) async {
  try {
  Get.put(FirestoreServiceProvider(authService));
} on Exception catch (_) {
  dev.log('firestore init fail');
  throw CloudInitException();
}
}
