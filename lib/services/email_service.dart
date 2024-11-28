import 'package:cloud_firestore/cloud_firestore.dart';

Future<bool> _checkEmailExists(String email) async {
  try {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('users') 
        .where('email', isEqualTo: email)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      print('Email already exists: $email');
      return true; 
    } else {
      print('Email does not exist: $email');
      return false;
    }
  } catch (e) {
    print('Error checking email existence: $e');
    return false;
  }
}
