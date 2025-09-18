import 'package:flutter_bloc/flutter_bloc.dart';

// -------- EVENTS --------
abstract class SplashEvent {}
class StartSplashEvent extends SplashEvent {}

// -------- STATES --------
abstract class SplashState {}
class SplashInitial extends SplashState {}
class SplashFinished extends SplashState {}

// -------- BLOC --------
class SplashBloc extends Bloc<SplashEvent, SplashState> {
  SplashBloc() : super(SplashInitial()) {
    on<StartSplashEvent>((event, emit) async {
      await Future.delayed(const Duration(seconds: 3)); // Splash delay
      emit(SplashFinished());
    });
  }
}
