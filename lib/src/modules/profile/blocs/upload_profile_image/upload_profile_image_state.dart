part of 'upload_profile_image_bloc.dart';

sealed class UploadProfileImageState extends Equatable {
  const UploadProfileImageState();

  @override
  List<Object> get props => [];
}

final class UploadProfileImageInitial extends UploadProfileImageState {}

final class UploadProfileImageFailure extends UploadProfileImageState {}

final class UploadProfileImageLoading extends UploadProfileImageState {}

final class UploadProfileImageSuccess extends UploadProfileImageState {
  final Uint8List? file;

  const UploadProfileImageSuccess({required this.file});
}
