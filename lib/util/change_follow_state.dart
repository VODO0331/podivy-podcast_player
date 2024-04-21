import 'package:firestore_service_repository/firestore_service_repository.dart';
import 'package:get/get.dart';
import 'package:my_audio_player/my_audio_player.dart' show Podcaster;

Future<void> changeFollowState(
  // FollowedManagement followedController,
  // InterestsManagement? interestsManagement,
  Podcaster podcasterData,
  bool value,
) async {
  final InterestsManagement interestsManagement =
      Get.find<InterestsManagement>();
       final followedController = Get.find<FollowedManagement>();
  if (value) {
    await followedController.deleteFollowed(podcastId: podcasterData.id);
    await interestsManagement.updateInterests(podcasterData.categories, !value);
  } else {
    await followedController.addFollowed(
      podcastId: podcasterData.id,
      podcastImg: podcasterData.imageUrl,
      podcastName: podcasterData.title,
      podcastCategory:podcasterData.categories,
    );
    await interestsManagement.updateInterests(podcasterData.categories, !value);
  }
}
