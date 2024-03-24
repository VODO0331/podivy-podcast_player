import 'package:firestore_service_repository/firestore_service_repository.dart';
import 'package:get/get.dart';
import 'package:search_service/search_service_repository.dart';

Future<void> changeFollowState(
  // FollowedManagement followedController,
  // InterestsManagement? interestsManagement,
  Podcaster podcasterData,
  bool value,
) async {
  final InterestsManagement interestsManagement =
      Get.put(InterestsManagement());
       final followedController = Get.find<FollowedManagement>();
  if (value) {
    await followedController.deleteFollowed(podcastId: podcasterData.id);
    await interestsManagement.updateInterests(podcasterData.categories, !value);
  } else {
    await followedController.addFollowed(
      podcastId: podcasterData.id,
      podcastImg: podcasterData.imageUrl,
      podcastName: podcasterData.title,
    );
    await interestsManagement.updateInterests(podcasterData.categories, !value);
  }
}
