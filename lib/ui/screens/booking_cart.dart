import 'package:flutter/material.dart';
import 'package:yinyoga_customer/dto/cartDTO.dart';
import 'package:yinyoga_customer/services/cart_service.dart';
import 'package:yinyoga_customer/ui/widgets/dialog_confirmation.dart';
import 'package:yinyoga_customer/ui/widgets/payment_popup.dart';

class BookingCartScreen extends StatefulWidget {
  @override
  _BookingCartScreenState createState() => _BookingCartScreenState();
}

class _BookingCartScreenState extends State<BookingCartScreen> {
  final CartService _cartService = CartService();
  Future<List<CartDTO>>? _cartItemsFuture;
  List<CartDTO> _cartItems = [];

  @override
  void initState() {
    super.initState();
    _fetchCarts();
  }

  void _fetchCarts() {
    _cartService.getUserBookings("trannq2003@gmail.com").then((cartItems) {
      setState(() {
        _cartItems = cartItems;
      });
    });
  }

  // Total amount
  double get totalAmount {
    double total = 0;
    for (var item in _cartItems) {
      if (item.isSelected) total += item.price;
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
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 232, 232, 232),
        elevation: 4,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Column(
        children: [
          // Edit button
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      for (var item in _cartItems) {
                        item.isEditing = !item.isEditing;
                      }
                    });
                  },
                  child: _buttonEditorDelete(),
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
          // Total and Payment
          PaymentPopup(totalPayment: totalAmount),
        ],
      ),
    );
  }

  Widget _buildCartItem(CartDTO item, int index) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 5,
      shadowColor: Colors.grey.withOpacity(0.2),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Show delete icon when in editing mode, otherwise show a checkbox
            item.isEditing
                ? IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () {
                      _removeItem(index);
                    },
                  )
                : Positioned(
                    top: 10, // Adjust position on the image
                    right: 10, // Place checkbox on the right side
                    child: Checkbox(
                      value: item.isSelected,
                      onChanged: (value) {
                        setState(() {
                          item.isSelected = value!;
                        });
                      },
                      activeColor: const Color(0xFF6D674B),
                    ),
                  ),
            // Course details
            Expanded(
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Image.asset(
                      'assets/images/instances/${item.imageUrl ?? "default_image.png"}', // Default image if null
                      height: 150,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        // Course name and price
                        Text(
                          item.instanceId ??
                              'Unknown Course', // Default text if null
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Poppins',
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Time: ${item.date ?? 'N/A'}',
                          style: const TextStyle(
                            fontSize: 12,
                            fontFamily: 'Poppins',
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          'Duration: ${item.time ?? 'N/A'} minutes',
                          style: const TextStyle(
                            fontSize: 12,
                            fontFamily: 'Poppins',
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          'Teacher: ${item.teacher ?? 'N/A'}', // Teacher for the class instance
                          style: const TextStyle(
                            fontSize: 12,
                            fontFamily: 'Poppins',
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    bottom: 16,
                    right: 16,
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(30, 30),
                        backgroundColor: Colors.white.withOpacity(0.8),
                        foregroundColor: const Color(0xFF6D674B),
                        shape: RoundedRectangleBorder(
                          side: const BorderSide(color: Colors.white),
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text("\$${item.price ?? 0}"),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _removeItem(int index) {
    setState(() {
      //load state
      print("Remove item at index $index - ${_cartItems[index].instanceId}");
      
      showDialog(
        context: context,
        builder: (BuildContext context) => ConfirmationDialog(
          title: 'Are you sure you want to remove class ${_cartItems[index].instanceId}?',
          content: "You won't be able to revert this!",
          onConfirm: () {
            _cartService
                .removeCartByInstanceId(
                    _cartItems[index].instanceId, "trannq2003@gmail.com")
                .then(
              (value) {
                // Remove the item from the list
                _cartItems.removeAt(index);
              },
            );
            Navigator.of(context).pop();
          },
        ),
      );
    });
  }

  _buttonEditorDelete() {
    return Text(
      _cartItems.any((item) => item.isEditing) ? 'Done' : 'Edit',
    );
  }
}