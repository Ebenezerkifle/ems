import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

class FileServices {
  File? file;
  late final fileName;

  static void attachFile(File? file) async {
    FilePickerResult? result =
        await FilePicker.platform.pickFiles(allowMultiple: false);
    if (result == null) return;
    final path = result.files.single.path!;
    file = File(path);
  }

  static UploadTask? uploadFile(File? file, fileName) {
    if (file != null) {
      fileName = file.path.split('/').last;
      final destination = 'files/$fileName';
      try {
        final reference = FirebaseStorage.instance.ref(destination);
        print('successfully stored');
        return reference.putFile(file);
      } on FirebaseException catch (e) {
        return null;
      }
    }
  }
}
