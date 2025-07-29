import 'package:equatable/equatable.dart';
import '../../../data/models/user_model.dart';

abstract class ProfileState extends Equatable {
  @override List<Object?> get props => [];
}
class ProfileLoading extends ProfileState {}
class ProfileLoaded extends ProfileState {
  final UserModel user;
  ProfileLoaded(this.user);
  @override List<Object?> get props => [user];
}
class ProfileSaving extends ProfileState {}
class ProfileError extends ProfileState {
  final String message;
  ProfileError(this.message);
  @override List<Object?> get props => [message];
}
