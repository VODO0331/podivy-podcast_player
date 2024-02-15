import 'package:flutter/material.dart';
import 'package:flutter_flip_card/flutter_flip_card.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:podivy/service/cloud/followed/firebaseCloudStroge.dart';

import '../../../../service/cloud/followed/followed.dart';
import '../../../../util/dialogs/delete_dialog.dart';

typedef FollowedCallback = void Function(Followed followed);

class FollowedList extends StatelessWidget {
  final Iterable<Followed> allFollowed;
  final FollowedCallback onDelete;
  final FollowedCallback onTap;
  const FollowedList(
      {super.key,
      required this.allFollowed,
      required this.onDelete,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    final followedStorageService = Get.put(PodcastFollowedStorage());
    return GridView.builder(
      itemCount: allFollowed.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          childAspectRatio: 1,
          crossAxisSpacing: 15,
          mainAxisSpacing: 17),
      padding: const EdgeInsets.all(8).r,
      itemBuilder: (context, index) {
        final followed = allFollowed.elementAt(index);

        return GestureFlipCard(
          animationDuration: const Duration(milliseconds: 400),
          frontWidget: GestureDetector(
            onTap: () {
              Get.toNamed("/podcaster", arguments: followed.podcastId);
            },
            child: Card(
              color: Colors.transparent,
              elevation: 10,
              shadowColor: Colors.black,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              child: ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(8)),
                child: Image.network(
                  followed.podcastImg,
                  fit: BoxFit.cover,
                  cacheHeight: 200,
                  cacheWidth: 200,
                  color: const Color(0x77433101),
                  colorBlendMode: BlendMode.color,
                  frameBuilder:
                      (context, child, frame, wasSynchronouslyLoaded) {
                    if (wasSynchronouslyLoaded) {
                      return child;
                    }
                    return AnimatedOpacity(
                      opacity: frame == null ? 0 : 1,
                      duration: const Duration(milliseconds: 400),
                      curve: Curves.easeOut,
                      child: child,
                    );
                  },
                ),
              ),
            ),
          ),
          backWidget: Container(
            decoration: const BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.black54,
                  offset: Offset(3, 6),
                  blurRadius: 0.3,
                  spreadRadius: 0.5,
                )
              ],
              borderRadius: BorderRadius.all(
                Radius.circular(8),
              ),
              color: Color.fromARGB(255, 76, 40, 24),
            ),
            child: Center(
              child: IconButton(
                icon: const Icon(
                  Icons.delete,
                  color: Color.fromARGB(255, 247, 193, 190),
                ),
                onPressed: () async {
                  final shouldDelete = await showDeleteDialog(context);
                  shouldDelete
                      ? await followedStorageService.deleteFollowed(
                          podcastId: followed.podcastId)
                      : null;
                },
              ),
            ),
          ),
        );
      },
    );
  }
}
