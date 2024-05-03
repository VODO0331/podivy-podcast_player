import 'package:flutter/material.dart';
import 'package:modify_widget_repository/modify_widget_repository.dart';
import 'package:my_audio_player/my_audio_player.dart';

import '../../../../util/dialogs/delete_dialog.dart';

typedef FollowCallback = void Function(Podcaster following);

class FollowList extends StatelessWidget {
  final Iterable<Podcaster> allFollow;
  final FollowCallback onDelete;
  final FollowCallback onTap;
  const FollowList(
      {super.key,
      required this.allFollow,
      required this.onDelete,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      
      itemCount: allFollow.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          childAspectRatio: 1,
          crossAxisSpacing: 15,
          mainAxisSpacing: 17),
      padding: const EdgeInsets.all(8).r,
      itemBuilder: (context, index) {
        final following = allFollow.elementAt(index);

        return GestureFlipCard(
          key: UniqueKey(),
          animationDuration: const Duration(milliseconds: 400),
          frontWidget: GestureDetector(
            onTap: () =>onTap(following),
            child: Card(
            
              color: Colors.transparent,
              elevation: 10,
              shadowColor: Colors.black,
              clipBehavior: Clip.antiAlias,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              child: FadeInImage.assetNetwork(
                placeholderCacheWidth: 200.r.toInt(),
                placeholderCacheHeight: 200.r.toInt(),
                imageCacheHeight: 200.r.toInt(),
                imageCacheWidth: 200.r.toInt(),
                fit: BoxFit.cover,
                placeholderFit: BoxFit.cover,
                placeholder: "assets/images/generic/loading.gif",
                image: following.imageUrl!,
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
                  shouldDelete ? onDelete(following) : null;
                },
              ),
            ),
          ),
        );
      },
    );
  }
}
