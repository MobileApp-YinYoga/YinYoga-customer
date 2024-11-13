import 'package:yinyoga_customer/dto/cartDTO.dart';
import 'package:yinyoga_customer/repositories/cart_repository.dart';

class CartService {
  final CartRepository _bookingRepository = CartRepository();

  Future<List<CartDTO>> getUserBookings(String userEmail) async {
    return await _bookingRepository.fetchUserBookings(userEmail);
  }

  Future<String> addToCart(String instanceId, String email) async {
    return _bookingRepository.addToCart(instanceId, email);
  }

  Future<void> modifyBooking(String cartId, Map<String, dynamic> updatedData) async {
    await _bookingRepository.updateBooking(cartId, updatedData);
  }

  Future<void> removeCartByInstanceId(String instanceId, String email) async {
    await _bookingRepository.deleteCartByInstanceId(instanceId, email);
  }
}
