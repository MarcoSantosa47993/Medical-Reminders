part of 'upload_profile_image_bloc.dart';

sealed class UploadProfileImageEvent extends Equatable {
  const UploadProfileImageEvent();

  @override
  List<Object> get props => [];
}

class UploadProfileImage extends UploadProfileImageEvent {
  final List<int> imageSrc;
  final String userId;

  const UploadProfileImage({required this.imageSrc, required this.userId});

  @override
  List<Object> get props => [imageSrc, userId];
}

class GetProfileImage extends UploadProfileImageEvent {
  final String userId;

  const GetProfileImage({required this.userId});

  @override
  List<Object> get props => [userId];
}
