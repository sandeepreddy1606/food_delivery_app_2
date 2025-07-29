import 'package:equatable/equatable.dart';
import '../../../data/models/user_model.dart';

abstract class ProfileEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadProfile extends ProfileEvent {}

class UpdateProfile extends ProfileEvent {
  final UserModel user;
  UpdateProfile(this.user);
  @override List<Object?> get props => [user];
}
