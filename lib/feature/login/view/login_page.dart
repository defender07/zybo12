import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/login_bloc.dart';
import '../bloc/login_event.dart';
import '../bloc/login_state.dart';
import '../repository/login_repository.dart';
import '../../otp/view/otp_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController phoneController = TextEditingController();

  @override
  void dispose() {
    phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => LoginBloc(LoginRepository()),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: SingleChildScrollView(
            child: SizedBox(
              height: MediaQuery.of(context).size.height,
              child: BlocConsumer<LoginBloc, LoginState>(
                listener: (context, state) {
                  if (state is LoginFailure) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(state.message)),
                    );
                  } else if (state is LoginSuccess) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => OtpPage(
                          phoneNumber: phoneController.text.trim(),
                          otp: state.response.otp?.toString() ?? '',
                          token: state.response.token?.toString() ?? '',
                        ),
                      ),
                    );
                  }
                },
                builder: (context, state) {
                  final bloc = context.read<LoginBloc>();
                  final isLoading = state is LoginLoading;

                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Login",
                            style: TextStyle(
                                fontSize: 28, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 8),
                          const Text("Let's connect with Lorem Ipsum...!"),
                          const SizedBox(height: 20),
                          TextField(
                            controller: phoneController,
                            keyboardType: TextInputType.phone,
                            decoration: const InputDecoration(
                              labelText: "+91 Enter phone",
                              border: OutlineInputBorder(),
                            ),
                          ),
                          const SizedBox(height: 24),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF5E5BE2),
                                padding:
                                const EdgeInsets.symmetric(vertical: 16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              onPressed: isLoading
                                  ? null
                                  : () {
                                final phone =
                                phoneController.text.trim();
                                if (phone.isEmpty || phone.length != 10) {
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                          "Please enter a valid 10-digit phone number"),
                                    ),
                                  );
                                } else {
                                  bloc.add(VerifyUserEvent(phone));
                                }
                              },
                              child: isLoading
                                  ? const CircularProgressIndicator(
                                  color: Colors.white)
                                  : const Text(
                                "Continue",
                                style: TextStyle(
                                    fontSize: 16, color: Colors.white),
                              ),
                            ),
                          ),
                          const SizedBox(height: 40),
                          Center(
                            child: Padding(
                              padding: const EdgeInsets.only(top: 20),
                              child: RichText(
                                textAlign: TextAlign.center,
                                text: TextSpan(
                                  style: const TextStyle(color: Colors.black),
                                  children: [
                                    const TextSpan(
                                        text: "By continuing you accept the "),
                                    TextSpan(
                                      text: "Terms of Use & Privacy Policy",
                                      style: const TextStyle(
                                        color: Colors.blue,
                                        decoration: TextDecoration.underline,
                                      ),
                                      recognizer: TapGestureRecognizer()
                                        ..onTap = () {
                                          // Handle Terms & Privacy click
                                        },
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
