import 'package:equatable/equatable.dart';

abstract class BottomTabEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class TabChanged extends BottomTabEvent {
  final int index;

  TabChanged(this.index);

  @override
  List<Object?> get props => [index];
}
