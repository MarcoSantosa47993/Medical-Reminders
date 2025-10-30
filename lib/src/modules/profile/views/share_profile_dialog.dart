import 'package:flutter/material.dart';
import 'package:medicins_schedules/src/modules/profile/forms/share_profile_form.dart';

class ShareProfileDialog extends StatelessWidget {
  const ShareProfileDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      children: [ShareProfileForm()],
    );
  }
}
