import 'package:cloud_firestore/cloud_firestore.dart';

Future<bool> _checkEmailExists(String email) async {
  try {
    // Truy vấn Firestore để kiểm tra xem email có tồn tại trong collection 'users' không
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('users') // Thay 'users' bằng tên collection của bạn
        .where('email', isEqualTo: email)
        .get();

    // Kiểm tra nếu có kết quả
    if (querySnapshot.docs.isNotEmpty) {
      print('Email already exists: $email');
      return true; // Email tồn tại
    } else {
      print('Email does not exist: $email');
      return false; // Email không tồn tại
    }
  } catch (e) {
    print('Error checking email existence: $e');
    return false; // Xử lý lỗi (có thể tuỳ chỉnh nếu cần)
  }
}
