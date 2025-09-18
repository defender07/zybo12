import 'package:equatable/equatable.dart';

class BottomTabState extends Equatable {
  final int selectedIndex;

  BottomTabState({required this.selectedIndex});

  @override
  List<Object?> get props => [selectedIndex];
}
