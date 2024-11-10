class OtpService {
  String generateOtp() {
    return List.generate(6, (index) => (index + 1 + (DateTime.now().millisecondsSinceEpoch % 9)).toString()).join();
  }
}
