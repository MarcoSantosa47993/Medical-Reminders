import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:medicins_schedules/src/blocs/authentication/authentication_bloc.dart';
import 'package:medicins_schedules/src/components/dashboard/dashboard.dart';
import 'package:medicins_schedules/src/modules/profile/blocs/upload_profile_image/upload_profile_image_bloc.dart';
import 'package:medicins_schedules/src/modules/profile/views/delete_account_dialog.dart';
import 'package:medicins_schedules/src/modules/profile/views/share_profile_dialog.dart';
import 'package:responsiveness/responsiveness.dart';

class ProfileActionsCard extends StatefulWidget {
  const ProfileActionsCard({super.key});

  @override
  State<ProfileActionsCard> createState() => _ProfileActionsCardState();
}

class _ProfileActionsCardState extends State<ProfileActionsCard> {
  bool isImageLoading = false;
  Uint8List? image;

  void _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
    );
    if (pickedFile != null) {
      context.read<UploadProfileImageBloc>().add(
        UploadProfileImage(
          imageSrc: await pickedFile.readAsBytes(),
          userId: context.read<AuthenticationBloc>().state.user!.id,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final buttonWidth = ResponsiveValue<double>(
      xs: MediaQuery.of(context).size.width,
      md: MediaQuery.of(context).size.width,
    );

    openDeleteAccountDialog() {
      showDialog(context: context, builder: (context) => DeleteAccountDialog());
    }

    openShareProfileDialog() {
      showDialog(context: context, builder: (context) => ShareProfileDialog());
    }

    return BlocListener<UploadProfileImageBloc, UploadProfileImageState>(
      listener: (context, state) {
        if (state is UploadProfileImageLoading) {
          setState(() {
            isImageLoading = true;
          });
        } else if (state is UploadProfileImageFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: const Text("Error on get profile image!")),
          );
          setState(() {
            isImageLoading = false;
            image = null;
          });
        } else if (state is UploadProfileImageSuccess) {
          setState(() {
            image = state.file;
            isImageLoading = false;
          });
        }
      },
      child: DashboardCard(
        flex: 4,
        children: [
          InkWell(
            onTap: () {
              _pickImage();
            },
            child: SizedBox(
              width: 150,
              height: 150,
              child: CircleAvatar(
                radius: 56,
                child: ClipOval(
                  child:
                      image != null
                          ? Image.memory(image!, fit: BoxFit.cover)
                          : Image.network(
                            "https://fastly.picsum.photos/id/889/200/200.jpg?hmac=mzo0mKfXHC9qb2dLw47jTrXZmlF9g6c6EuUFOWz0T5U",
                          ),
                ),
              ),
            ),
          ),
          SizedBox(height: 10),
          Text(
            context.read<AuthenticationBloc>().state.user!.name,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.outline,
            ),
          ),
          SizedBox(height: 80),

          Column(
            spacing: 10,
            children: [
              SizedBox(
                width: buttonWidth.of(context),
                child: TextButton.icon(
                  onPressed: openShareProfileDialog,
                  style: TextButton.styleFrom(
                    foregroundColor: Theme.of(context).colorScheme.secondary,
                  ),
                  label: Text("Share Profile"),
                  icon: Icon(Icons.qr_code),
                ),
              ),
              SizedBox(
                width: buttonWidth.of(context),
                child: TextButton.icon(
                  onPressed: () {
                    context.read<AuthenticationBloc>().userRepository.logOut();
                  },
                  label: Text("Logout"),
                  icon: Icon(Icons.logout),
                  style: TextButton.styleFrom(
                    foregroundColor: Theme.of(context).colorScheme.error,
                  ),
                ),
              ),
              SizedBox(
                width: buttonWidth.of(context),
                child: FilledButton.icon(
                  onPressed: openDeleteAccountDialog,
                  label: Text("Delete Account"),
                  icon: Icon(Icons.delete),
                  style: FilledButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.error,
                  ),
                ),
              ),
            ],
          ),

          SizedBox(height: 10),
        ],
      ),
    );
  }
}
