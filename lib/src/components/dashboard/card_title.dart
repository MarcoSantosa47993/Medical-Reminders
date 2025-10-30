import 'package:flutter/material.dart';

class DashboardCardTitle extends StatelessWidget {
  final String title;
  final Widget? action;

  const DashboardCardTitle({super.key, required this.title, this.action});

  @override
  Widget build(BuildContext context) {
    final TextStyle? titleStyle = Theme.of(context).textTheme.titleLarge
        ?.copyWith(color: Theme.of(context).colorScheme.outline);

    if (action != null) {
      return Row(
        children: [Expanded(child: Text(title, style: titleStyle)), action!],
      );
    }

    return Text(title, style: titleStyle);
  }
}
