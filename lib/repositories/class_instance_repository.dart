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

  Future<List<ClassInstance>> getInstancesByCourseId(String courseId) async {
    try {
      print("Fetching class instances by course ID: $courseId");

      // Convert courseId string to integer
      int courseIdInt = int.tryParse(courseId) ?? -1;
      if (courseIdInt == -1) {
        print('Invalid course ID format');
        return [];
      }

      QuerySnapshot querySnapshot = await _firestore
          .collection('classInstances')
          .where('courseId', isEqualTo: courseIdInt)
          .get();

      // Print number of class instances found
      print('Class Instances in querySnapshot: ${querySnapshot.docs.length}');

      return querySnapshot.docs
          .map((doc) {
            Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

            // Check if 'courseId' exists and is the expected type
            if (data['courseId'] == null || data['courseId'] is! int) {
              print("Skipping document with invalid 'courseId': ${doc.id}");
              return null;
            }
            return ClassInstance.fromMap(data);
          })
          .where((instance) => instance != null)
          .cast<ClassInstance>()
          .toList(); // Filter out nulls
    } catch (e) {
      print('Error fetching class instances by course ID: $e');
      return [];
    }
  }
}
