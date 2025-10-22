import 'package:flutter/material.dart';
import 'package:responsiveness/responsiveness.dart';

class DashboardCard extends StatelessWidget {
  final int flex;
  final List<Widget> children;
  final Widget? floatingActionButton;

  const DashboardCard({
    super.key,
    this.flex = 1,
    required this.children,
    this.floatingActionButton,
  });

  @override
  Widget build(BuildContext context) {
    return ResponsiveParent<Widget>(
      xs: (child) => child,
      lg: (child) => Expanded(flex: flex, child: child),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(18)),
          color: Theme.of(context).scaffoldBackgroundColor,
        ),
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: children,
              ),
            ),
            if (floatingActionButton != null)
              Positioned(bottom: 0, right: 0, child: floatingActionButton!),
          ],
        ),
      ),
    );
  }
}
