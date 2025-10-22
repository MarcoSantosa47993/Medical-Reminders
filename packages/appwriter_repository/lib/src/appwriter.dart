import 'dart:developer';
import 'dart:typed_data';

import 'package:appwrite/appwrite.dart';
import 'package:appwriter_repository/src/appwriter_repo.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class Appwriter implements AppwriterRepository {
  final Client client;

  Appwriter(this.client);

  static Future<Appwriter> init() async {
    final endpoint = dotenv.env["APP_WRITER_URL"] ?? "";
    final project = dotenv.env["APP_WRITER_PROJECT"] ?? "";

    final client = Client()
        .setEndpoint(endpoint)
        .setProject(project)
        .setSelfSigned(status: true);

    return Appwriter(client);
  }

  @override
  Future<String> uploadImage(List<int>? bytes, String? fileId) async {
    try {
      final bucketId = dotenv.env["APP_WRITER_BUCKET_ID"] ?? "";

      final storage = Storage(client);

      if (fileId != null || (fileId != null && bytes == null)) {
        await storage.deleteFile(bucketId: bucketId, fileId: fileId);
      }

      final id = ID.unique();

      if (bytes != null) {
        final file = InputFile.fromBytes(bytes: bytes, filename: "$id.png");
        await storage.createFile(bucketId: bucketId, fileId: id, file: file);
      }

      return id;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<Uint8List> getImage(String fileId) async {
    try {
      final bucketId = dotenv.env["APP_WRITER_BUCKET_ID"] ?? "";
      final storage = Storage(client);

      final file = await storage.getFileView(
        bucketId: bucketId,
        fileId: fileId,
      );
      return file;
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }
}
