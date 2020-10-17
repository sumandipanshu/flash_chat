import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class Storage {
  Future<String> uploadProfilePic(File imageFile, User user) async {
    final FirebaseStorage _storage =
        FirebaseStorage(storageBucket: 'gs://flash-chat-177ef.appspot.com');
    StorageUploadTask _uploadTask;
    String filePath = 'profilePic/${user.uid}.png';
    String fileURL;
    try {
      _uploadTask = _storage.ref().child(filePath).putFile(imageFile);
      await _uploadTask.onComplete;
      print('File Uploaded');
      fileURL = await _storage.ref().child(filePath).getDownloadURL();
    } catch (e) {
      print(e);
    }
    return fileURL;
  }

  Future<String> uploadPhoto(File imageFile, String chatId) async {
    final FirebaseStorage _storage =
        FirebaseStorage(storageBucket: 'gs://flash-chat-177ef.appspot.com');
    StorageUploadTask _uploadTask;
    String filePath = 'chatUploads/$chatId/${DateTime.now()}.png';
    String fileURL;
    try {
      _uploadTask = _storage.ref().child(filePath).putFile(imageFile);
      await _uploadTask.onComplete;
      print('File Uploaded');
      fileURL = await _storage.ref().child(filePath).getDownloadURL();
    } catch (e) {
      print(e);
    }
    return fileURL;
  }
}
