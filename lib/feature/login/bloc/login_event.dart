import 'package:equatable/equatable.dart';

abstract class LoginEvent extends Equatable {
  const LoginEvent();

  @override
  List<Object?> get props => [];
}

class VerifyUserEvent extends LoginEvent {
  final String phoneNumber;

  const VerifyUserEvent(this.phoneNumber);

  @override
  List<Object?> get props => [phoneNumber];
}