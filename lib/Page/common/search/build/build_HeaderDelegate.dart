import 'package:flutter/material.dart';
import 'package:modify_widget_repository/modify_widget_repository.dart';

class HeaderDelegate extends SliverPersistentHeaderDelegate {
  const HeaderDelegate(this.title);

  final String title;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF708D78),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Column(
        children: [
          Text(
            title,
            style: TextStyle(fontSize: ScreenUtil().setSp(20)),
          ),
        ],
      ),
    );
  }

  @override
  double get maxExtent => minExtent;

  @override
  double get minExtent => 40.h;

  @override
  bool shouldRebuild(covariant HeaderDelegate oldDelegate) =>
      title != oldDelegate.title;
}
