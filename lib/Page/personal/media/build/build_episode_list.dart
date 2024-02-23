import 'package:flutter/material.dart';
import 'package:modify_widget_repository/modify_widget_repository.dart';
import 'package:search_service/search_service_repository.dart' show Episode;

typedef EpisodeCallBack = void Function(Episode episode,int? index);

class ListBuilder extends StatelessWidget {
  final Iterable<Episode> episodes;
  final EpisodeCallBack onDelete;
  final EpisodeCallBack onTap;
  const ListBuilder(
      {super.key,
      required this.episodes,
      required this.onDelete,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.zero,
      prototypeItem: prototypeItem(),
      itemCount: episodes.length,
      itemBuilder: (BuildContext context, int index) {
        final episode = episodes.elementAt(index);
        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10).h,
              child: ListTile(
                title: Text(
                  episode.title,
                  overflow: TextOverflow.ellipsis,
                ),
                leading: SizedBox(
                    height: 50.r,
                    width: 50.r,
                    child: FadeInImage.assetNetwork(
                      fit: BoxFit.cover,
                      placeholder:
                          'assets/images/podcaster/defaultPodcaster.jpg',
                      image: episode.imageUrl,
                      imageErrorBuilder: (context, _, __) {
                        return Image.asset(
                          'assets/images/podcaster/defaultPodcaster.jpg',
                          fit: BoxFit.cover,
                        );
                      },
                    )),
                trailing: PopupMenuButton(
                  position: PopupMenuPosition.under,
                  itemBuilder: (context) {
                    return [
                      PopupMenuItem(
                        onTap: () {
                          onDelete(episode,null);
                        },
                        child: const Text("刪除"),
                      )
                    ];
                  },
                ),
                onTap: () {
                  onTap(episode,index);
                },
              ),
            )
          ],
        );
      },
    );
  }
}

Widget prototypeItem() {
  return Column(
    children: [
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 10).h,
        child: ListTile(
            title: const Text(
              'testTitle',
              overflow: TextOverflow.ellipsis,
            ),
            leading: SizedBox(
                height: 50.r,
                width: 50.r,
                child: FadeInImage.assetNetwork(
                  placeholder: 'assets/images/podcaster/defaultPodcaster.jpg',
                  image: 'image',
                  imageErrorBuilder: (context, _, __) {
                    return Image.asset(
                      'assets/images/podcaster/defaultPodcaster.jpg',
                      fit: BoxFit.cover,
                    );
                  },
                )),
            trailing: PopupMenuButton(
              position: PopupMenuPosition.under,
              itemBuilder: (context) {
                return [
                  PopupMenuItem(
                    onTap: () {
                      //  onDelete(list);
                    },
                    child: const Text("刪除"),
                  )
                ];
              },
            )),
      )
    ],
  );
}
