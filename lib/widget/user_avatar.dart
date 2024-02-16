import 'package:flutter/material.dart';
import 'package:modify_widget_repository/modify_widget_repository.dart';

class UserAvatar extends StatelessWidget {
  final String? imgPath;
  final double radius;
  final double? borderThickness;
  final Color? color;
  final bool isNetwork;

  const UserAvatar({
    Key? key,
    required this.imgPath,
    required this.radius,
    this.color,
    this.borderThickness,
    required this.isNetwork,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      backgroundColor: color ?? Colors.white,
      radius: borderThickness ?? radius + 1.h,
      child: CircleAvatar(
        radius: radius,
        backgroundImage: imageProvider(imgPath, isNetwork),
        
      ),
    );
  }
}
ImageProvider<Object> imageProvider(String? imagePath, bool isNetwork){
  if(imagePath == null) return const AssetImage('images/userPic/default_user.png');
  if(isNetwork){
      return NetworkImage(imagePath);
  }else{
     return AssetImage(imagePath);
  }
}

