import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medicins_schedules/src/blocs/authentication/authentication_bloc.dart';
import 'package:user_repository/user_repository.dart';

class BaseMenu {
  final String label;
  final IconData icon;
  final bool enabled;

  const BaseMenu({
    required this.label,
    required this.icon,
    this.enabled = true,
  });

  static List<BaseMenu> items(BuildContext context) => [
    BaseMenu(label: "Home", icon: Icons.home),
    BaseMenu(
      label: "Dependents",
      icon: Icons.groups,
      enabled:
          context.read<AuthenticationBloc>().state.user!.role ==
          MyUserRole.caregiver,
    ),
    BaseMenu(label: "Profile", icon: Icons.person),
  ];
}
