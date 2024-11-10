import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Xóa tất cả các document trong một collection.
  Future<void> deleteCollection(String collectionName) async {
    try {
      QuerySnapshot snapshot = await _firestore.collection(collectionName).get();
      for (QueryDocumentSnapshot doc in snapshot.docs) {
        await doc.reference.delete();
      }
      print('Deleted all documents in $collectionName successfully');
    } catch (e) {
      print('Error deleting collection $collectionName: $e');
    }
  }

  // Create a document and return the document reference
  Future<DocumentReference> createDocument(
      String collectionName, Map<String, dynamic> data) async {
    try {
      var docRef = await _firestore.collection(collectionName).add(data);
      return docRef; // Return the document reference
    } catch (e) {
      print('Error creating document: $e');
      throw Exception('Failed to create document');
    }
  }

  /// Cập nhật hoặc tạo lại một bảng (collection) với dữ liệu mới.
  Future<void> updateOrCreateCollection(
    String collectionName,
    List<Map<String, dynamic>> newDocuments,
  ) async {
    try {
      // Xóa collection trước
      await deleteCollection(collectionName);

      // Thêm dữ liệu mới
      for (var document in newDocuments) {
        await _firestore.collection(collectionName).add(document);
      }
      print('Updated or created collection $collectionName successfully');
    } catch (e) {
      print('Error updating or creating collection $collectionName: $e');
    }
  }
}
