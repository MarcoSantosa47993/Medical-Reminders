import 'dart:typed_data';

abstract class AppwriterRepository {
  Future<String> uploadImage(List<int> imageSrc, String fileId);

  Future<Uint8List> getImage(String fileId);
}
