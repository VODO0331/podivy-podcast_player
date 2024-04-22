import 'package:firestore_service_repository/firestore_service_repository.dart';
import 'package:get/get.dart';
import 'package:my_audio_player/my_audio_player.dart' show Podcaster;

Future<void> changeFollowState(
  // FollowManagement followedController,
  // InterestsManagement? interestsManagement,
  Podcaster podcasterData,
  bool value,
) async {
  final  fsp =
      Get.find<FirestoreServiceProvider>();
  if (value) {
    await fsp.follow.unfollow(podcastId: podcasterData.id);
    await fsp.interests.updateInterests(podcasterData.categories, !value);
  } else {
    await fsp.follow.addFollowed(
      podcastId: podcasterData.id,
      podcastImg: podcasterData.imageUrl,
      podcastName: podcasterData.title,
      podcastCategory:podcasterData.categories,
    );
    await fsp.interests.updateInterests(podcasterData.categories, !value);
  }
}
