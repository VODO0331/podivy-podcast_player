import 'package:firestore_service_repository/firestore_service_repository.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:modify_widget_repository/modify_widget_repository.dart';

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
              clipBehavior: Clip.antiAlias,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              child: FadeInImage.assetNetwork(
                placeholderCacheWidth: 200,
                placeholderCacheHeight: 200,
                imageCacheHeight: 200,
                imageCacheWidth: 200,
                fit: BoxFit.cover,
                placeholderFit: BoxFit.cover,
                placeholder: "assets/images/generic/loading.gif",
                image: followed.podcastImg,
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
                  shouldDelete ? onDelete(followed) : null;
                },
              ),
            ),
          ),
        );
      },
    );
  }
}
