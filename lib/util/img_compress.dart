import 'dart:typed_data';

import 'package:flutter_image_compress/flutter_image_compress.dart';


enum ImageFormat { png, jpeg, webp }

class ImageCompressor {
  Future<Uint8List?> compressImage(
    String assetName, {
    required int minh,
    required int minw,
    required int quality,
    required ImageFormat format,
  }) async {
    final CompressFormat compressFormat = _getCompressFormat(format);

    final Uint8List? image = await FlutterImageCompress.compressAssetImage(
      assetName,
      minHeight: minh,
      minWidth: minw,
      quality: quality,
      format: compressFormat,
    );
    return image;
  }

  CompressFormat _getCompressFormat(ImageFormat format) {
    switch (format) {
      case ImageFormat.png:
        return CompressFormat.png;
      case ImageFormat.jpeg:
        return CompressFormat.jpeg;
      case ImageFormat.webp:
        return CompressFormat.webp;
    }
  }
}
