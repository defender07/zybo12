import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/login_bloc.dart';
import '../bloc/login_event.dart';
import '../bloc/login_state.dart';
import '../repository/login_repository.dart';
import '../../otp/view/otp_page.dart';

/// Strings for easy localization and maintenance
class AppStrings {
  static const loginTitle = "Login";
  static const loginSubtitle = "Let's connect with Lorem Ipsum...!";
  static const phoneHint = "+91 Enter phone";
  static const continueBtn = "Continue";
  static const termsText = "By continuing you accept the ";
  static const termsLink = "Terms of Use & Privacy Policy";
  static const phoneError = "Please enter a valid 10-digit phone number";
}

class LoginPage extends StatelessWidget {
  LoginPage({super.key});

  final TextEditingController phoneController = TextEditingController();

  bool _isValidPhone(String phone) {
    return RegExp(r'^[0-9]{10}$').hasMatch(phone);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => LoginBloc(LoginRepository()),
      child: BlocConsumer<LoginBloc, LoginState>(
        listener: (context, state) {
          if (state is LoginFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          } else if (state is LoginSuccess) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (_) => OtpPage(
                  phoneNumber: phoneController.text.trim(),
                  otp: state.response.otp ?? '',
                  token: state.response.token ?? '',
                ),
              ),
            );
          }
        },
        builder: (context, state) {
          final bloc = context.read<LoginBloc>();
          final isLoading = state is LoginLoading;

          return Scaffold(
            backgroundColor: Colors.white,
            body: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      AppStrings.loginTitle,
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(AppStrings.loginSubtitle),
                    const SizedBox(height: 20),

                    /// Phone Input
                    _PhoneField(controller: phoneController),

                    const SizedBox(height: 24),

                    /// Continue Button
                    _LoginButton(
                      isLoading: isLoading,
                      onPressed: () {
                        final phone = phoneController.text.trim();
                        if (!_isValidPhone(phone)) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text(AppStrings.phoneError)),
                          );
                        } else {
                          bloc.add(VerifyUserEvent(phone));
                        }
                      },
                    ),

                    const Spacer(),

                    /// Terms & Privacy
                    const _TermsAndPrivacyText(),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

/// Phone input field widget
class _PhoneField extends StatelessWidget {
  final TextEditingController controller;
  const _PhoneField({required this.controller});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: TextInputType.phone,
      decoration: const InputDecoration(
        labelText: AppStrings.phoneHint,
        border: OutlineInputBorder(),
      ),
    );
  }
}

/// Login button widget
class _LoginButton extends StatelessWidget {
  final bool isLoading;
  final VoidCallback onPressed;

  const _LoginButton({
    required this.isLoading,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF5E5BE2),
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        onPressed: isLoading ? null : onPressed,
        child: isLoading
            ? const CircularProgressIndicator(color: Colors.white)
            : const Text(
          AppStrings.continueBtn,
          style: TextStyle(fontSize: 16, color: Colors.white),
        ),
      ),
    );
  }
}

/// Terms & Privacy widget
class _TermsAndPrivacyText extends StatelessWidget {
  const _TermsAndPrivacyText();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
          style: const TextStyle(color: Colors.black),
          children: [
            const TextSpan(text: AppStrings.termsText),
            TextSpan(
              text: AppStrings.termsLink,
              style: const TextStyle(
                color: Colors.blue,
                decoration: TextDecoration.underline,
              ),
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  // TODO: Navigate to Terms & Privacy page
                },
            ),
          ],
        ),
      ),
    );
  }
}
