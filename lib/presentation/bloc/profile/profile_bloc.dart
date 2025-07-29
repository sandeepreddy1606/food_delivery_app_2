import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/datasources/user_remote_data_source.dart';
import '../../../data/models/user_model.dart';
import 'profile_event.dart';
import 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final UserRemoteDataSource remote;
  ProfileBloc({required this.remote}) : super(ProfileLoading()) {
    on<LoadProfile>(_onLoad);
    on<UpdateProfile>(_onUpdate);
  }

  Future<void> _onLoad(LoadProfile event, Emitter<ProfileState> emit) async {
    emit(ProfileLoading());
    try {
      final profile = await remote.fetchUserProfile();
      emit(ProfileLoaded(profile));
    } catch (e) {
      emit(ProfileError(e.toString()));
    }
  }

  Future<void> _onUpdate(UpdateProfile event, Emitter<ProfileState> emit) async {
    emit(ProfileSaving());
    try {
      await remote.updateUserProfile(event.user);
      final updated = await remote.fetchUserProfile();
      emit(ProfileLoaded(updated));
    } catch (e) {
      emit(ProfileError(e.toString()));
    }
  }
}
