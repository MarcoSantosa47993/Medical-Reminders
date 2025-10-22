import 'package:flutter/material.dart';
import 'package:medicins_schedules/src/components/dashboard/dashboard.dart';
import 'package:responsiveness/responsiveness.dart';

class DashboardViewBase extends StatelessWidget {
  final String screenTitle;
  final String? screenSubtitle;
  final List<Widget> children;
  final bool? showBackbutton;

  const DashboardViewBase({
    super.key,
    required this.screenTitle,
    required this.children,
    this.screenSubtitle,
    this.showBackbutton,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: 20,
      children: [
        DashboardAppBar(
          title: screenTitle,
          subtitle: screenSubtitle,
          showBackbutton: showBackbutton,
        ),

        Expanded(
          child: ResponsiveParent<List<Widget>>(
            xs:
                (child) => SingleChildScrollView(
                  child: Column(
                    spacing: 20,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: child,
                  ),
                ),
            lg:
                (child) => Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  spacing: 20,
                  children: child,
                ),
            child: children,
          ),
        ),
      ],
    );
  }
}
