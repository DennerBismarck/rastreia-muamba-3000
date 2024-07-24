import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

Future<void> addTrackingCode(String code) async {
  User? user = FirebaseAuth.instance.currentUser;

  if (user != null) {
    CollectionReference trackingCodes = FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('tracking_codes');

    await trackingCodes.add({
      'code': code,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }
}

Stream<QuerySnapshot> getTrackingCodes() {
  User? user = FirebaseAuth.instance.currentUser;

  if (user != null) {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('tracking_codes')
        .orderBy('timestamp', descending: true)
        .snapshots();
  }

  return Stream.empty();
}
