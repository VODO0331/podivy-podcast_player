import 'package:firestore_service_repository/firestore_service_repository.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:modify_widget_repository/modify_widget_repository.dart';

typedef ListCallback = void Function(UserList list);

class MyListView extends StatelessWidget {
  final Iterable<UserList> lists;
  final ListCallback onDelete;
  final ListCallback onTap;
  const MyListView(
      {super.key,
      required this.lists,
      required this.onDelete,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: lists.length,
      itemBuilder: (BuildContext context, int index) {
        final list = lists.elementAt(index);
        return ListTile(
          title: Text(
            list.listTitle,
            overflow: TextOverflow.ellipsis,
          ),
          trailing: PopupMenuButton(
            position: PopupMenuPosition.under,
            itemBuilder: (context) {
              return [
                PopupMenuItem(
                  onTap: () {
                    onDelete(list);
                  },
                  child: Text("delete".tr),
                )
              ];
            },
          ),
          onTap: () {
            onTap(list);
          },
          titleTextStyle:TextStyle(fontSize: 20.sp)
        );
      },
    );
  }
}
