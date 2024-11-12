import 'package:yinyoga_customer/models/class_instance_model.dart';
import 'package:yinyoga_customer/repositories/class_instance_repository.dart';

class ClassInstanceService {
  final ClassInstanceRepository _classInstanceRepository = ClassInstanceRepository();

  Future<List<ClassInstance>> getInstancesByCourseId(String courseId) async {
    return await _classInstanceRepository.getInstancesByCourseId(courseId);
  }

  Future<void> addClassInstance(ClassInstance instance) async {
    await _classInstanceRepository.addClassInstance(instance);
  }

  Future<List<ClassInstance>> getAllInstances() async {
    return await _classInstanceRepository.getAllInstances();
  }
}
