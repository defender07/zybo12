import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../view/login_page.dart' show LoginPage;
import '../bloc/splash_bloc.dart';
// Navigate to Login

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SplashBloc()..add(StartSplashEvent()),
      child: BlocListener<SplashBloc, SplashState>(
        listener: (context, state) {
          if (state is SplashFinished) {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (_) => LoginPage()),
            );
          }
        },
        child: Scaffold(
          backgroundColor: Colors.white,
          body: Center(
            child: SizedBox(
              height: 100,
              width: 230,
              child: Image.asset("assets/images/Logo (1).png"),
            ),
          ),
        ),
      ),
    );
  }
}
