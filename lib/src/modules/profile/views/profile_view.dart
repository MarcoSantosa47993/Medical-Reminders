import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medicins_schedules/src/blocs/authentication/authentication_bloc.dart';
import 'package:medicins_schedules/src/components/dashboard/dashboard.dart';
import 'package:medicins_schedules/src/modules/profile/blocs/upload_profile_image/upload_profile_image_bloc.dart';
import 'package:medicins_schedules/src/modules/profile/blocs/user_data/user_data_bloc.dart';
import 'package:medicins_schedules/src/modules/profile/views/actions_card.dart';
import 'package:medicins_schedules/src/modules/profile/views/forms_card.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<UserDataBloc>(
      create:
          (context) =>
              UserDataBloc(context.read<AuthenticationBloc>().userRepository),
      child: DashboardViewBase(
        screenTitle: "Profile",
        screenSubtitle: context.read<AuthenticationBloc>().state.user!.name,
        children: [
          BlocProvider(
            create:
                (context) => UploadProfileImageBloc(
                  context.read<AuthenticationBloc>().userRepository,
                )..add(
                  GetProfileImage(
                    userId: context.read<AuthenticationBloc>().state.user!.id,
                  ),
                ),
            child: ProfileActionsCard(),
          ),
          ProfileFormsCard(),
        ],
      ),
    );
  }
}
