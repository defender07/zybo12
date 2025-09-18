import 'package:bloc/bloc.dart';
import '../service/profile_service.dart';
import '../bloc/profile_event.dart';
import '../bloc/profile_state.dart';
import '../../../../core/storeage/shared_prefs.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final ProfileService service;

  ProfileBloc({required this.service}) : super(ProfileInitial()) {
    on<FetchProfile>((event, emit) async {
      emit(ProfileLoading());

      try {
        // Automatically get token from SharedPreferences
        final token = await SharedPrefs.getToken();

        // Fetch profile using saved token
        final profile = await service.fetchProfile(token: token);

        emit(ProfileLoaded(
          name: profile.name,
          phoneNumber: profile.phoneNumber,
        ));
      } catch (e) {
        emit(ProfileError('Failed to load profile'));
      }
    });
  }
}
