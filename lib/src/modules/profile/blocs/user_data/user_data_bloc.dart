import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:user_repository/user_repository.dart';

part 'user_data_event.dart';
part 'user_data_state.dart';

class UserDataBloc extends Bloc<UserDataEvent, UserDataState> {
  final UserRepository _userRepository;

  UserDataBloc(this._userRepository) : super(UserDataInitial()) {
    on<UserDataChange>((event, emit) async {
      emit(UserDataLoading());
      try {
        await _userRepository.setUserData(event.user);
        emit(UserDataSuccess());
      } catch (e) {
        log(e.toString());
        emit(UserDataFailure());
      }
    });
  }
}
