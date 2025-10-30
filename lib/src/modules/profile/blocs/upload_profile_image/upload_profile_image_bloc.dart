import 'dart:typed_data';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:user_repository/user_repository.dart';

part 'upload_profile_image_event.dart';
part 'upload_profile_image_state.dart';

class UploadProfileImageBloc
    extends Bloc<UploadProfileImageEvent, UploadProfileImageState> {
  final UserRepository userRepository;
  UploadProfileImageBloc(this.userRepository)
    : super(UploadProfileImageInitial()) {
    on<UploadProfileImage>((event, emit) async {
      try {
        emit(UploadProfileImageLoading());
        final file = await userRepository.changeImageProfile(
          event.imageSrc,
          event.userId,
        );
        emit(UploadProfileImageSuccess(file: file));
      } catch (e) {
        emit(UploadProfileImageFailure());
      }
    });

    on<GetProfileImage>((event, emit) async {
      try {
        emit(UploadProfileImageLoading());
        final file = await userRepository.getImageProfile(event.userId);
        emit(UploadProfileImageSuccess(file: file));
      } catch (e) {
        emit(UploadProfileImageFailure());
      }
    });
  }
}
