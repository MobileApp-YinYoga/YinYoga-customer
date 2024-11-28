import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:yinyoga_customer/dto/cartDTO.dart';
import 'package:yinyoga_customer/services/cart_service.dart';
import 'package:yinyoga_customer/ui/widgets/dialog_confirmation.dart';
import 'package:yinyoga_customer/ui/widgets/payment_popup.dart';
import 'package:yinyoga_customer/utils/sharedPreferences.dart';

class BookingCartScreen extends StatefulWidget {
  @override
  _BookingCartScreenState createState() => _BookingCartScreenState();
}

class _BookingCartScreenState extends State<BookingCartScreen> {
  final CartService _cartService = CartService();
  Future<List<CartDTO>>? _cartItemsFuture;
  List<CartDTO> _cartItems = [];
  List<CartDTO> _bookingItems = [];
  String userEmail = '';

  @override
  void initState() {
    super.initState();
    _fetchCarts();
    _loadReferenceData();
  }

  Future<void> _loadReferenceData() async {
    // Load data from SharedPreferences
    userEmail = (await SharedPreferencesHelper.getData('email'))!;
  }

  Uint8List _base64Decode(String source) {
    String cleanBase64 = source.contains(',') ? source.split(',').last : source;
    cleanBase64 = cleanBase64.replaceAll(RegExp(r'\s+'), '');
    Uint8List imageBytes = base64Decode(cleanBase64);
    return imageBytes;
  }

  Future<void> _fetchCarts() async {
    String? email = await SharedPreferencesHelper.getData('email');
    _cartService.getUserBookings(email!).then((cartItems) {
      setState(() {
        _cartItems = cartItems;
      });
    });
  }

  // Total amount
  double get totalAmount {
    double total = 0;
    _bookingItems.clear(); // Clear before recalculating
    for (var item in _cartItems) {
      if (item.isSelected) {
        total += item.price;
        _bookingItems.add(item); // Add selected items
      }
    }
    return total;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Booking Cart',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w600,
            fontFamily: 'Poppins',
            color: Color(0xFF6D674B),
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 1, // Remove default shadow to create a clean line appearance
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0), // Height of the line
          child: Container(
            color: const Color(0xFF6D674B), // Line color
            width: 50,
            height: 1.0, // Line thickness
          ),
        ),
      ),
      body: _cartItems.isEmpty
          ? const Center(
              child: Text(
                'Your cart is empty',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Poppins',
                  color: Color(0xFF6D674B),
                ),
              ),
            )
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    children: [
                      const Spacer(),
                      SizedBox(
                        width: 100,
                        height: 30,
                        child: ElevatedButton(
                          onPressed: () {
                            setState(() {
                              for (var item in _cartItems) {
                                item.isEditing = !item.isEditing;
                              }
                            });
                          },
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets
                                .zero, // Remove padding to match the size constraints
                            side: const BorderSide(
                                color: Color(0xFF6D674B), width: 1),
                            shape: const CircleBorder(),
                          ),
                          child: _buttonEditorDelete(),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: _cartItems.length,
                    itemBuilder: (context, index) {
                      final item = _cartItems[index];
                      return _buildCartItem(item, index);
                    },
                  ),
                ),
                PaymentPopup(
                  totalPayment: totalAmount,
                  bookingItems: _bookingItems,
                  onSuccess: () {
                    setState(() {
                      _cartItems
                          .removeWhere((item) => _bookingItems.contains(item));
                      _bookingItems.clear(); // Clear booking items
                    });
                  },
                ),
              ],
            ),
    );
  }

  Widget _buildCartItem(CartDTO item, int index) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      elevation: 4,
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: item.imageUrl.isNotEmpty
                ? Image.memory(
                    _base64Decode(item.imageUrl),
                    height: 150,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  )
                : Image.asset(
                    'assets/images/courses/default_image.png',
                    height: 150,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
          ),
          Container(
            height: 150,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20), // Corner radius 20
              color: const Color(0xFF6D674B)
                  .withOpacity(0.3), // Fill 6D674B with opacity 40%
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Positioned(
                    top: 0,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment
                              .spaceBetween, // Căn chỉnh khoảng cách
                          children: [
                            // Text nằm bên trái
                            Text(
                              item.instanceId,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            // Checkbox hoặc IconButton nằm bên phải
                            item.isEditing
                                ? SizedBox(
                                    height: 35, // Đặt chiều cao mong muốn
                                    child: ElevatedButton(
                                      onPressed: () {
                                        _removeItem(index);
                                      },
                                      style: ElevatedButton.styleFrom(
                                        padding: const EdgeInsets.all(8),
                                        backgroundColor: Colors
                                            .transparent, // Đặt màu nền là trong suốt
                                        shape:
                                            const CircleBorder(), // Giữ cho nút có hình tròn
                                        side: BorderSide
                                            .none, // Không có đường viền
                                      ),
                                      child: Image.asset(
                                        'assets/icons/utils/delete.png', // Đảm bảo sử dụng Image.asset thay vì Image.network để truy cập file nội bộ
                                      ),
                                    ))
                                : Checkbox(
                                    value: item.isSelected,
                                    onChanged: (value) {
                                      setState(() {
                                        item.isSelected = value!;
                                      });
                                    },
                                    checkColor:
                                        const Color(0xFF6D674B), // Màu tick
                                    activeColor: const Color(
                                        0xFF6D674B), // Màu nền khi được check
                                    fillColor:
                                        MaterialStateProperty.resolveWith(
                                      (states) => Colors
                                          .white, // Màu viền khi không check
                                    ),
                                  ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Time: ${item.date ?? 'N/A'}',
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          'Duration: ${item.time ?? 'N/A'} minutes',
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          'Teacher: ${item.teacher ?? 'N/A'}',
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    )),
              ],
            ),
          ),
          Positioned(
            bottom: 16,
            right: 16,
            child: SizedBox(
              height: 26, // Đặt chiều cao mong muốn
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white.withOpacity(0.4),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    side: const BorderSide(color: Colors.white),
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: Text(
                  "${item.price ?? 0} Dollars", // Hoặc "Dolar" tùy ý bạn
                  style: const TextStyle(
                    color: Colors.white, // Correct text color
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _removeItem(int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) => ConfirmationDialog(
        title:
            'Are you sure to remove class ${_cartItems[index].instanceId}?',
        content: "You won't be able to revert this!",
        onConfirm: () {
          _cartService
              .removeCartByInstanceId(
                  _cartItems[index].instanceId, userEmail)
              .then(
            (value) {
              setState(() {
                _cartItems.removeAt(index); // Remove and refresh UI
              });
            },
          );
          Navigator.of(context).pop();
        },
      ),
    );
  }

  _buttonEditorDelete() {
    final isEditing = _cartItems.any((item) => item.isEditing);
    return Icon(
      isEditing ? Icons.edit : Icons.delete,
      color: const Color(0xFF6D674B),
    );
  }
}
