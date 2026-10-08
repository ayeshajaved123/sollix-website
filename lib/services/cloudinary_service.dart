import 'dart:typed_data';
import 'package:cloudinary_public/cloudinary_public.dart';
import '../config/cloudinary_config.dart';

/// Uploads an image (as bytes, so it works on Flutter Web) to Cloudinary
/// and returns the public URL to store in Firestore.
class CloudinaryService {
  final _cloudinary = CloudinaryPublic(
    CloudinaryConfig.cloudName,
    CloudinaryConfig.uploadPreset,
    cache: false,
  );

  Future<String> uploadImage(Uint8List bytes, String fileName) async {
    final response = await _cloudinary.uploadFile(
      CloudinaryFile.fromBytesData(
        bytes,
        identifier: fileName,
        folder: 'sollix',
      ),
    );
    return response.secureUrl;
  }
}
