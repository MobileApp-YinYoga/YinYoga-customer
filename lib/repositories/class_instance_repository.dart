import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/class_instance_model.dart';

class ClassInstanceRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addClassInstance(ClassInstance instance) async {
    try {
      await _firestore.collection('classInstances').add(instance.toMap());
      print('ClassInstance added successfully');
    } catch (e) {
      print('Error adding class instance: $e');
    }
  }

  Future<List<ClassInstance>> fetchAllClassInstances() async {
    QuerySnapshot snapshot = await _firestore.collection('class_instances').get();

    return snapshot.docs
        .map((doc) => ClassInstance.fromMap(doc.data() as Map<String, dynamic>, doc.id))
        .toList();
  }

  Future<List<ClassInstance>> fetchClassInstancesByCourse(String courseId) async {
  QuerySnapshot snapshot = await _firestore
      .collection('classInstances')
      .where('courseId', isEqualTo: courseId)
      .get();

  return snapshot.docs
      .map((doc) => ClassInstance.fromMap(doc.data() as Map<String, dynamic>, doc.id))
      .toList();
}

}
