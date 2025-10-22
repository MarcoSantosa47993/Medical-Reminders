part of 'user_data_bloc.dart';

sealed class UserDataEvent extends Equatable {
  const UserDataEvent();

  @override
  List<Object> get props => [];
}

class UserDataChange extends UserDataEvent {
  final MyUser user;

  const UserDataChange(this.user);

  @override
  List<Object> get props => [user];
}
