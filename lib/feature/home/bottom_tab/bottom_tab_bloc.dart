import 'package:flutter_bloc/flutter_bloc.dart';
import 'bottom_tab_event.dart';
import 'bottom_tab_state.dart';

class BottomTabBloc extends Bloc<BottomTabEvent, BottomTabState> {
  BottomTabBloc() : super(BottomTabState(selectedIndex: 0)) {
    on<TabChanged>((event, emit) {
      emit(BottomTabState(selectedIndex: event.index));
    });
  }
}
