/*******************************************************************************
 *Created By Aman Mishra
 ******************************************************************************/

import 'package:datashare/utils/all_imports.dart';
import 'package:get/get.dart';

class UploadDataController extends GetxController {
  String imageUrl = "";
  String qrImage = "";
  Uint8List? fileBytes;
  late TargetPlatform? platform;
  double? progress;
  late DropzoneViewController controller1;
  bool isHighlighted = false;

  Future<Uint8List?> pickFile() async {
    imageUrl = "";
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.any,
    );
    if (result != null) {
      if (kIsWeb) {
        uploadImageOnWeb(result.files.single.bytes, result.files.first.name);
      } else {
        File file = File(result.files.single.path.toString());
        debugPrint("Extension:::: ${result.files.first.name.toString()}");
        uploadImage(file, result.files.first.name);
      }

      return result.files.single.bytes;
    } else {
      return null;
    }
  }

  uploadImageOnWeb(var imageFile, var productName) async {
    String path = 'Files/$productName';
    Reference reference = FirebaseStorage.instance.ref().child(path);

    UploadTask uploadTask = reference.putData(imageFile);
    uploadTask.snapshotEvents.listen((event) {
      progress =
          event.bytesTransferred.toDouble() / event.totalBytes.toDouble();
      if (event.state == TaskState.success) {
        progress = null;
        debugPrint('File added to the library');
      }

      update();
    }).onError((error) {
      // debugPrint("Error :: ${error.toString()}");
    });
    uploadTask.whenComplete(() async {
      try {
        imageUrl = await reference.getDownloadURL();
        imageUrl = imageUrl.toString();
        update();
      } catch (onError) {
        debugPrint("Error :: ${onError.toString()}");
      }
    });
  }

  uploadImage(var imageFile, var productName) async {
    Reference reference =
        FirebaseStorage.instance.ref('APK Files/$productName'); //$timeStamp

    UploadTask uploadTask = reference.putFile(imageFile);

    uploadTask.whenComplete(() async {
      try {
        String downloadURL = await reference.getDownloadURL();
        imageUrl = downloadURL.toString();
        // _downloadFile(imageUrl);
        debugPrint("File Data::: ${imageUrl.toString().split('?')[0]}");
        update();
      } catch (onError) {
        debugPrint("Error:::: ${onError.toString()}");
      }
    });
  }

  Future<void> createRecord() async {
    DatabaseReference databaseReference =
        FirebaseDatabase.instance.ref().child('users');

    databaseReference.push().set({
      'name': 'John Doe',
      'email': 'johndoe@example.com',
      'age': 30,
    });
  }

  void readData() {
    DatabaseReference databaseReference =
        FirebaseDatabase.instance.ref().child('users');

    databaseReference.onValue.listen((event) {
      DataSnapshot dataSnapshot = event.snapshot;
      debugPrint("Data*************${dataSnapshot.value}");
      /*Map<dynamic, dynamic> values = dataSnapshot.value;
      values.forEach((key, values) {
        print('Key: $key');
        print('Name: ${values['name']}');
        print('Email: ${values['email']}');
        print('Age: ${values['age']}');
      });*/
    });
  }
}
