import 'package:flutter/material.dart';

class EmailInputScreen extends StatefulWidget {
  @override
  _EmailInputScreenState createState() => _EmailInputScreenState();
}

class _EmailInputScreenState extends State<EmailInputScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _fullNameController = TextEditingController();

  String _nameErrorMessage = ''; // Lưu trữ thông báo lỗi cho tên
  String _emailErrorMessage = ''; // Lưu trữ thông báo lỗi cho email

  bool _isLoading = false; // Kiểm tra trạng thái loading

  bool _isValidName(String name) {
    final regex = RegExp(r'^[a-zA-Z\s]+$');
    return regex.hasMatch(name);
  }

  bool _isValidEmail(String email) {
    final regex = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
    return regex.hasMatch(email);
  }

  void _validateInputs() {
    setState(() {
      _nameErrorMessage = _fullNameController.text.isEmpty
          ? 'Full Name cannot be empty'
          : (!_isValidName(_fullNameController.text)
              ? 'Full Name must only contain alphabets'
              : '');

      _emailErrorMessage = _emailController.text.isEmpty
          ? 'Email cannot be empty'
          : (!_isValidEmail(_emailController.text)
              ? 'Invalid email address'
              : '');
    });
  }

  Future<void> _sendOtp() async {
    setState(() {
      _isLoading = true;
    });
    await Future.delayed(const Duration(seconds: 2)); // Fake delay
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Image
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image:
                    AssetImage('assets/images/background/welcome_image_2.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Content
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 80), // khoảng trống dưới nút back
                const Text(
                  'WELCOME TO UNIVERSAL YOGA',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 23,
                    fontFamily: 'Poppins',
                    color: Color(0xFF6D674B),
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  'Join us to improve your mental and physical well-being through yoga. Start by entering your details below to begin your journey with us!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 13,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF6D674B),
                  ),
                ),
                const SizedBox(height: 30),
                // Trường Full Name
                _buildTextInputField(
                  controller: _fullNameController,
                  label: 'Full name',
                  hint: 'Enter your full name',
                  isRequired: true,
                  errorText: _nameErrorMessage,
                  onChanged: (value) {
                    if (!_isValidName(value)) {
                      setState(() {
                        _nameErrorMessage = 'Name must only contain alphabets';
                      });
                    } else {
                      setState(() {
                        _nameErrorMessage = '';
                      });
                    }
                  },
                ),
                const SizedBox(height: 20),
                // Trường Email
                _buildTextInputField(
                  controller: _emailController,
                  label: 'Email',
                  hint: 'Enter your email',
                  isRequired: true,
                  isEmail: true,
                  errorText: _emailErrorMessage,
                  onChanged: (value) {
                    if (!_isValidEmail(value)) {
                      setState(() {
                        _emailErrorMessage = 'Invalid email address';
                      });
                    } else {
                      setState(() {
                        _emailErrorMessage = '';
                      });
                    }
                  },
                ),
                const SizedBox(height: 30),
                // Nút Get Started
                SizedBox(
                  height: 45,
                  width: 160,
                  child: ElevatedButton(
                    onPressed: () {
                      _validateInputs();
                      if (_nameErrorMessage.isEmpty &&
                          _emailErrorMessage.isEmpty) {
                        _sendOtp();
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF6D674B),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: _isLoading
                        ? const CircularProgressIndicator(
                            color: Colors.white,
                          )
                        : const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Get Started',
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14,
                                ),
                              ),
                              SizedBox(width: 4),
                              Icon(Icons.arrow_forward, size: 20),
                            ],
                          ),
                  ),
                ),
              ],
            ),
          ),
          // Back Button
          Positioned(
            top: 40,
            left: 24,
            child: InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0xFF6D674B),
                ),
                child: const Icon(Icons.arrow_back, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextInputField({
    required TextEditingController controller,
    required String label,
    required String hint,
    String? errorText, // Nhận thông báo lỗi
    bool isRequired = false,
    bool isEmail = false,
    required void Function(String)? onChanged, // Lắng nghe thay đổi input
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label với dấu bắt buộc (*)
        RichText(
          text: TextSpan(
            text: label,
            style: const TextStyle(
              fontSize: 14,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w600,
              color: Color(0xFF6D674B),
            ),
            children: isRequired
                ? const [
                    TextSpan(
                      text: '*',
                      style: TextStyle(color: Colors.red),
                    ),
                  ]
                : [],
          ),
        ),
        const SizedBox(height: 8),
        // Thêm hiệu ứng shadow
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(30),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.25), // Màu sắc shadow
                offset: const Offset(0, 4), // Độ dịch chuyển X và Y
                blurRadius: 4, // Độ mờ
              ),
            ],
          ),
          child: TextField(
            controller: controller,
            keyboardType:
                isEmail ? TextInputType.emailAddress : TextInputType.text,
            onChanged: onChanged,
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: const TextStyle(
                fontFamily: 'Poppins',
                fontSize: 13,
                color: Colors.grey,
              ),
              filled: true,
              fillColor: Colors.transparent, // Background từ Container
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: BorderSide.none, // Không có viền
              ),
            ),
          ),
        ),
        if (errorText != null && errorText.isNotEmpty) ...[
          const SizedBox(height: 4),
          Padding(
            padding: const EdgeInsets.only(left: 10),
            child: Text(
              errorText,
              style: const TextStyle(
                fontSize: 12,
                fontFamily: 'Poppins',
                color: Colors.red,
              ),
            ),
          ),
        ],
      ],
    );
  }
}
