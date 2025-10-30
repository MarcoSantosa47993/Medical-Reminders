import 'package:flutter/material.dart';
import 'package:medicins_schedules/src/components/dashboard/dashboard.dart';
import 'package:medicins_schedules/src/modules/profile/forms/change_password_form.dart';
import 'package:medicins_schedules/src/modules/profile/forms/user_data_form.dart';

class ProfileFormsCard extends StatelessWidget {
  const ProfileFormsCard({super.key});

  @override
  Widget build(BuildContext context) {
    return DashboardCard(
      flex: 8,
      children: [
        DashboardCardTitle(title: "User data"),
        SizedBox(height: 20),
        UserDataForm(),
        SizedBox(height: 100),
        DashboardCardTitle(title: "Change password"),
        SizedBox(height: 20),
        ChangePasswordForm(),
      ],
    );
  }
}
