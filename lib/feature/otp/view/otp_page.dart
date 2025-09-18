import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import '../../home/bottom_tab/bottom_tab_page.dart';

class OtpPage extends StatefulWidget {
  final String phoneNumber;
  final String otp;
  final String token;

  const OtpPage({
    super.key,
    required this.phoneNumber,
    required this.otp,
    required this.token,
  });

  @override
  State<OtpPage> createState() => _OtpPageState();
}

class _OtpPageState extends State<OtpPage> with SingleTickerProviderStateMixin {
  int _seconds = 30;
  Timer? _timer;

  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  final List<TextEditingController> _otpControllers =
  List.generate(4, (index) => TextEditingController());

  String? _otpFromApi;
  String? _token;

  @override
  void initState() {
    super.initState();
    _otpFromApi = widget.otp;
    _token = widget.token;

    // ✅ Pre-fill OTP boxes with API OTP
    if (_otpFromApi != null && _otpFromApi!.length == 4) {
      for (int i = 0; i < 4; i++) {
        _otpControllers[i].text = _otpFromApi![i];
      }
    }

    _startTimer();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    )..repeat(reverse: true);

    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.3).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    debugPrint("✅ OTP received: $_otpFromApi");
    debugPrint("✅ Token received: $_token");
  }

  void _startTimer() {
    _seconds = 30;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_seconds > 0) {
        setState(() => _seconds--);
      } else {
        timer.cancel();
        _animationController.stop();
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _animationController.dispose();
    for (var controller in _otpControllers) controller.dispose();
    super.dispose();
  }

  Future<void> _verifyOtp() async {
    String enteredOtp = _otpControllers.map((e) => e.text).join();

    if (enteredOtp.length < 4) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter complete OTP")),
      );
      return;
    }

    if (enteredOtp == _otpFromApi) {
      debugPrint("✅ OTP Verified!");

      // Save token in SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      if (_token != null) await prefs.setString("auth_token", _token!);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("OTP Verified Successfully!")),
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const BottomTabPage()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Incorrect OTP! Please try again.")),
      );
    }
  }

  Widget _buildOtpBox(int index, double boxSize, double fontSize) {
    return SizedBox(
      width: boxSize,
      height: boxSize,
      child: TextField(
        controller: _otpControllers[index],
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        maxLength: 1,
        style: TextStyle(fontSize: fontSize, fontWeight: FontWeight.bold),
        decoration: InputDecoration(
          counterText: "",
          filled: true,
          fillColor: Colors.grey.shade100,
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: const BorderSide(color: Color(0xFF5E5BE2), width: 2),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide(color: Colors.grey.shade400),
          ),
        ),
        onChanged: (value) {
          if (value.isNotEmpty && index < 3) FocusScope.of(context).nextFocus();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final boxSize = screenWidth * 0.14;
    final titleFontSize = screenWidth * 0.07;
    final subtitleFontSize = screenWidth * 0.045;
    final otpFontSize = screenWidth * 0.06;
    final timerFontSize = screenWidth * 0.06;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(centerTitle: true),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20),
            Text(
              "OTP Verification",
              style: TextStyle(fontSize: titleFontSize, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              "Enter the OTP sent to ${widget.phoneNumber}",
              style: TextStyle(fontSize: subtitleFontSize, color: Colors.black54),
            ),
            const SizedBox(height: 10),
            // ✅ Display OTP raw value from API for testing
            Text(
              "OTP is: $_otpFromApi",
              style: TextStyle(
                  fontSize: subtitleFontSize,
                  fontWeight: FontWeight.bold,
                  color: Colors.green),
            ),
            SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(4, (index) => _buildOtpBox(index, boxSize, otpFontSize)),
            ),
            SizedBox(height: 25),
            Center(
              child: ScaleTransition(
                scale: _scaleAnimation,
                child: Text(
                  "00:$_seconds",
                  style: TextStyle(
                      fontSize: timerFontSize,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF5E5BE2)),
                ),
              ),
            ),
            SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF5E5BE2),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: _verifyOtp,
                child: const Text("Verify OTP", style: TextStyle(fontSize: 16, color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
