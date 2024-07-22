import 'package:cloud_firestore/cloud_firestore.dart';
Future<void> uploadDataToFirebase({
  required String collectionName,
  required String number,
  required String name,
  required String sName,
  required Map<String, dynamic> data,
}) async {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  try {
    await firestore
        .collection(collectionName)
        .doc(number)
        .collection(name)
        .doc(sName)
        .set(data
        // ,SetOptions(merge:true)
    );
    print('Data uploaded successfully');
  } catch (e) {
    print('Error uploading data: $e');
  }
}