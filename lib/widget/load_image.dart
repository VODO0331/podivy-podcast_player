// import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;




class LoadImageWidget extends StatefulWidget {
  final String? imageUrl;
  final String? replaceImageToAssetImage;

  const LoadImageWidget({
    required this.imageUrl,
    this.replaceImageToAssetImage,
    super.key,
  });

  @override
  State<LoadImageWidget> createState() => _LoadImageWidgetState();
}

class _LoadImageWidgetState extends State<LoadImageWidget> {
  late String? imageUrl;
  late String replaceImageToAssetImage;

  @override
  void initState() {
    super.initState();
    imageUrl = widget.imageUrl;
    replaceImageToAssetImage = widget.replaceImageToAssetImage ??
        "assets/images/podcaster/defaultPodcaster.jpg";
  }

  @override
  void didUpdateWidget(covariant LoadImageWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.imageUrl != oldWidget.imageUrl) {
      imageUrl = widget.imageUrl;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (imageUrl == null) {
      return Image.asset(
        replaceImageToAssetImage,
        fit: BoxFit.fill,
      );
    } else {
      return FutureBuilder(
        future: loadImage(imageUrl!),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasError) {
              // dev.log('Error loading image: ${snapshot.error}');
              return Image.asset(
                replaceImageToAssetImage,
                fit: BoxFit.cover,
              );
            } else {
              return Image.network(
                
                imageUrl!,
                fit: BoxFit.cover,
                cacheHeight: 170,
                cacheWidth: 170,
              );
            }
          } else {
            return const CircularProgressIndicator();
          }
        },
      );
    }
  }
}

Future<Image> loadImage(String imageUrl) async {
  final response = await http.get(Uri.parse(imageUrl));

  if (response.statusCode == 200) {
    return Image.memory(response.bodyBytes);
  } else {
    throw Exception('Failed to load image');
  }
}
