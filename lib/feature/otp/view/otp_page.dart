import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../home/bottom_tab/bottom_tab_page.dart';

class OtpPage extends StatefulWidget {
  final String phoneNumber, otp, token;
  const OtpPage({super.key, required this.phoneNumber, required this.otp, required this.token});

  @override
  State<OtpPage> createState() => _OtpPageState();
}

class _OtpPageState extends State<OtpPage> with SingleTickerProviderStateMixin {
  static const int otpLength = 4;
  static const int timerDuration = 30;
  static const Color primaryColor = Color(0xFF5E5BE2);

  final _otpControllers = List.generate(otpLength, (_) => TextEditingController());
  late AnimationController _animCtrl;
  late Animation<double> _scaleAnim;
  Timer? _timer;
  int _seconds = timerDuration;

  @override
  void initState() {
    super.initState();

    // Prefill OTP from API
    for (int i = 0; i < widget.otp.length && i < otpLength; i++) {
      _otpControllers[i].text = widget.otp[i];
    }

    _startTimer();
    _animCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 600))..repeat(reverse: true);
    _scaleAnim = Tween(begin: 1.0, end: 1.3).animate(CurvedAnimation(parent: _animCtrl, curve: Curves.easeInOut));
  }

  void _startTimer() {
    _timer?.cancel();
    _seconds = timerDuration;
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (_seconds > 0) setState(() => _seconds--);
      else { t.cancel(); _animCtrl.stop(); }
    });
  }

  Future<void> _verifyOtp() async {
    final enteredOtp = _otpControllers.map((e) => e.text).join();

    if (enteredOtp.length < otpLength) return _msg("Please enter complete OTP");

    if (enteredOtp == widget.otp) {
      await _saveToken(widget.token);
      _msg("OTP Verified Successfully!");
      if (mounted) {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const BottomTabPage()));
      }
    } else {
      _msg("Incorrect OTP! Please try again.");
    }
  }

  Future<void> _saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString("auth_token", token);
  }

  void _msg(String m) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(m)));

  @override
  void dispose() {
    _timer?.cancel();
    _animCtrl.dispose();
    for (var c in _otpControllers) c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(centerTitle: true),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const SizedBox(height: 20),
          Text("OTP Verification", style: TextStyle(fontSize: w * 0.07, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          Text("Enter the OTP sent to ${widget.phoneNumber}",
              style: TextStyle(fontSize: w * 0.045, color: Colors.black54)),
          if (!bool.fromEnvironment("dart.vm.product"))
            Text("OTP is: ${widget.otp}",
                style: TextStyle(fontSize: w * 0.045, fontWeight: FontWeight.bold, color: Colors.green)),
          const SizedBox(height: 40),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: List.generate(otpLength, (i) => OtpBox(controller: _otpControllers[i], isLast: i == otpLength - 1, boxSize: w * 0.14, fontSize: w * 0.06)),
          ),
          const SizedBox(height: 25),
          Center(
            child: ScaleTransition(
              scale: _scaleAnim,
              child: Text("00:$_seconds",
                  style: TextStyle(fontSize: w * 0.06, fontWeight: FontWeight.bold, color: primaryColor)),
            ),
          ),
          const SizedBox(height: 30),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: _verifyOtp,
              child: const Text("Verify OTP", style: TextStyle(fontSize: 16, color: Colors.white)),
            ),
          ),
        ]),
      ),
    );
  }
}

/// Reusable OTP Input Widget
class OtpBox extends StatelessWidget {
  final TextEditingController controller;
  final bool isLast;
  final double boxSize, fontSize;
  const OtpBox({super.key, required this.controller, required this.isLast, required this.boxSize, required this.fontSize});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: boxSize,
      height: boxSize,
      child: TextField(
        controller: controller,
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
            borderSide: const BorderSide(color: _OtpPageState.primaryColor, width: 2),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide(color: Colors.grey.shade400),
          ),
        ),
        onChanged: (v) {
          if (v.isNotEmpty && !isLast) FocusScope.of(context).nextFocus();
        },
      ),
    );
  }
}
