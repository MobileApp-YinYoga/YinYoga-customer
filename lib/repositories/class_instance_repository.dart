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

  // Fetch all class instances
  Future<List<ClassInstance>> getAllInstances() async {
    try {
      QuerySnapshot querySnapshot =
          await _firestore.collection('classInstances').get();
      return querySnapshot.docs
          .map((doc) =>
              ClassInstance.fromMap(doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      print('Error fetching all class instances: $e');
      return [];
    }
  }

  // Fetch class instances by course ID
  Future<List<ClassInstance>> getInstancesByCourseId(String courseId) async {
  try {
    QuerySnapshot querySnapshot = await _firestore
        .collection('classInstances')
        .where('courseId', isEqualTo: courseId)
        .get(); 

    return querySnapshot.docs.map((doc) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      // Thêm id từ DocumentSnapshot vào dữ liệu
      data['id'] = doc.id;
      return ClassInstance.fromMap(data);
    }).toList();
  } catch (e) {
    print('Error fetching class instances by course ID: $e');
    return [];
  }
}

}
