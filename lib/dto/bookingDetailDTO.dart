import 'package:yinyoga_customer/models/class_instance_model.dart';

class BookingDetailDTO {
  final String id; // BookingDetail ID
  final ClassInstance instance;
  final double price;

  BookingDetailDTO({
    required this.id,
    required this.instance,
    required this.price,
  });
}