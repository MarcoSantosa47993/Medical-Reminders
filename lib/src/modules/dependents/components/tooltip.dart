import 'package:flutter/material.dart';
import 'package:medicins_schedules/src/modules/dependents/components/responsive_button.dart';
import 'package:medicins_schedules/src/routes/routes.dart';
import 'package:responsiveness/responsiveness.dart';

class DependentToolbar extends StatelessWidget {
  final String dependentId;

  const DependentToolbar({super.key, required this.dependentId});

  @override
  Widget build(BuildContext context) {
    return ResponsiveChild(
      xs: Row(
        children: [
          ResponsiveButton(
            icon: Icons.monitor_heart_outlined,
            label: 'Health History',
            shortLabel: 'Health',
            mediumLabel: 'Health History',
            route: Paths.health.fullRoute,
            extra: dependentId,
          ),
          SizedBox(width: 10),
          ResponsiveButton(
            icon: Icons.file_copy_outlined,
            label: 'Medic Recipes',
            shortLabel: 'Recipes',
            mediumLabel: 'Medic Recipes',
            route: Paths.receips.fullRoute,
            extra: dependentId,
          ),
          SizedBox(width: 10),
          ResponsiveButton(
            icon: Icons.calendar_month_rounded,
            label: 'Planning Medicins',
            shortLabel: 'Planning',
            mediumLabel: 'Planning Medicins',
            route: Paths.planning.fullRoute,
            extra: dependentId,
          ),
          SizedBox(width: 10),
          ResponsiveButton(
            icon: Icons.medication,
            label: 'Medicins',
            shortLabel: 'Medicins',
            mediumLabel: 'Medicins',
            route: Paths.medicins.fullRoute,
            extra: dependentId,
          ),
        ],
      ),
      sm: Row(
        children: [
          ResponsiveButton(
            icon: Icons.monitor_heart_outlined,
            label: 'Health History',
            shortLabel: 'Health',
            mediumLabel: 'Health History',
            route: Paths.health.fullRoute,
            extra: dependentId,
          ),
          SizedBox(width: 12),
          ResponsiveButton(
            icon: Icons.file_copy_outlined,
            label: 'Medic Recipes',
            shortLabel: 'Recipes',
            mediumLabel: 'Medic Recipes',
            route: Paths.receips.fullRoute,
            extra: dependentId,
          ),
          SizedBox(width: 12),
          ResponsiveButton(
            icon: Icons.calendar_month_rounded,
            label: 'Planning Medicins',
            shortLabel: 'Planning',
            mediumLabel: 'Planning Medicins',
            route: Paths.planning.fullRoute,
            extra: dependentId,
          ),
          SizedBox(width: 12),
          ResponsiveButton(
            icon: Icons.medication,
            label: 'Medicins',
            shortLabel: 'Medicins',
            mediumLabel: 'Medicins',
            route: Paths.medicins.fullRoute,
            extra: dependentId,
          ),
        ],
      ),
      md: Row(
        children: [
          ResponsiveButton(
            icon: Icons.monitor_heart_outlined,
            label: 'Health History',
            shortLabel: 'Health',
            mediumLabel: 'Health History',
            route: Paths.health.fullRoute,
            extra: dependentId,
          ),
          SizedBox(width: 12),
          ResponsiveButton(
            icon: Icons.file_copy_outlined,
            label: 'Medic Recipes',
            shortLabel: 'Recipes',
            mediumLabel: 'Medic Recipes',
            route: Paths.receips.fullRoute,
            extra: dependentId,
          ),
          SizedBox(width: 12),
          ResponsiveButton(
            icon: Icons.calendar_month_rounded,
            label: 'Planning Medicins',
            shortLabel: 'Planning',
            mediumLabel: 'Planning Medicins',
            route: Paths.planning.fullRoute,
            extra: dependentId,
          ),
          SizedBox(width: 12),
          ResponsiveButton(
            icon: Icons.medication,
            label: 'Medicins',
            shortLabel: 'Medicins',
            mediumLabel: 'Medicins',
            route: Paths.medicins.fullRoute,
            extra: dependentId,
          ),
        ],
      ),
      lg: Row(
        children: [
          ResponsiveButton(
            icon: Icons.monitor_heart_outlined,
            label: 'Health History',
            shortLabel: 'Health',
            mediumLabel: 'Health History',
            route: Paths.health.fullRoute,
            extra: dependentId,
          ),
          SizedBox(width: 12),
          ResponsiveButton(
            icon: Icons.file_copy_outlined,
            label: 'Medic Recipes',
            shortLabel: 'Recipes',
            mediumLabel: 'Medic Recipes',
            route: Paths.receips.fullRoute,
            extra: dependentId,
          ),
          SizedBox(width: 12),
          ResponsiveButton(
            icon: Icons.calendar_month_rounded,
            label: 'Planning Medicins',
            shortLabel: 'Planning',
            mediumLabel: 'Planning Medicins',
            route: Paths.planning.fullRoute,
            extra: dependentId,
          ),
          SizedBox(width: 12),
          ResponsiveButton(
            icon: Icons.medication,
            label: 'Medicins',
            shortLabel: 'Medicins',
            mediumLabel: 'Medicins',
            route: Paths.medicins.fullRoute,
            extra: dependentId,
          ),
        ],
      ),
      additionalWidgets: {
        1100: Row(
          children: [
            ResponsiveButton(
              icon: Icons.monitor_heart_outlined,
              label: 'Health History',
              shortLabel: 'Health',
              mediumLabel: 'Health History',
              route: Paths.health.fullRoute,
              extra: dependentId,
            ),
            SizedBox(width: 20),
            ResponsiveButton(
              icon: Icons.file_copy_outlined,
              label: 'Medic Recipes',
              shortLabel: 'Recipes',
              mediumLabel: 'Medic Recipes',
              route: Paths.receips.fullRoute,
              extra: dependentId,
            ),
            SizedBox(width: 20),
            ResponsiveButton(
              icon: Icons.calendar_month_rounded,
              label: 'Planning Medicins',
              shortLabel: 'Planning',
              mediumLabel: 'Planning Medicins',
              route: Paths.planning.fullRoute,
              extra: dependentId,
            ),
            SizedBox(width: 20),
            ResponsiveButton(
              icon: Icons.medication,
              label: 'Medicins',
              shortLabel: 'Medicins',
              mediumLabel: 'Medicins',
              route: Paths.medicins.fullRoute,
              extra: dependentId,
            ),
          ],
        ),
      },
    );
  }
}
