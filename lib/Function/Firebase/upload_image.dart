import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

// Future uploadImageToFirebaseStorage(
//   XFile imageFile,
//   String userPhoneNumber,
//   BuildContext context,
//   String name,
// ) async {
//   try {
//     final storageRef = FirebaseStorage.instance.ref();
//     final fileRef = storageRef.child(
//         'Storage/$userPhoneNumber/$name/${DateTime.now().millisecondsSinceEpoch}.jpg');
//     await fileRef.putFile(File(imageFile.path));
//     String downloadUrl = await fileRef.getDownloadURL();
//     if (context.mounted) {
//       ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text('Image uploaded successfully')));
//     }
//     return downloadUrl;
//   } catch (e) {
//     if (e is FileSystemException &&
//         e.osError?.errorCode == 2 &&
//         context.mounted) {
//       ScaffoldMessenger.of(context)
//           .showSnackBar(const SnackBar(content: Text("File does not exist")));
//     } else {
//       (mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//             const SnackBar(content: Text("Error uploading image")));
//       };
//     }
//   }
// }
Future uploadImageToFirebaseStorage(
    XFile imageFile,
    String userPhoneNumber,
    BuildContext context,
    String name,
    ) async {
  try {
    final storageRef = FirebaseStorage.instance.ref();
    final fileRef = storageRef.child(
        'Storage/$userPhoneNumber/$name/${DateTime.now().millisecondsSinceEpoch}.jpg');
    await fileRef.putFile(File(imageFile.path));
    String downloadUrl = await fileRef.getDownloadURL();
    print('upload image');
    // if (context.mounted) {
    //   ScaffoldMessenger.of(context).showSnackBar(
    //       const SnackBar(content: Text('Image uploaded successfully')));
    // }
    return downloadUrl;
  } catch (e) {
    if (context.mounted) {
      if (e is FirebaseException && e.code == 'canceled') {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Upload canceled")));
      } else if (e is FileSystemException &&
          e.osError?.errorCode == 2) {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text("File does not exist")));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Error uploading image")));
      }
    }
    return null;
  }
}
