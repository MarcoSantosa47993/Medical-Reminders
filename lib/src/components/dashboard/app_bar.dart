import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class DashboardAppBar extends StatelessWidget {
  final String title;
  final String? subtitle;
  final bool? showBackbutton;

  const DashboardAppBar({
    super.key,
    required this.title,
    this.subtitle,
    this.showBackbutton,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          if (showBackbutton == true)
            IconButton.filledTonal(
              onPressed: () {
                context.pop();
              },
              icon: Icon(Icons.arrow_back_rounded),
            ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment:
                showBackbutton == true
                    ? CrossAxisAlignment.center
                    : CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (subtitle != null)
                Text(
                  subtitle!,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurface,
                    fontWeight: FontWeight.bold,
                  ),
                ),
            ],
          ),

          SizedBox(
            width: 40,
            height: 40,
            child: Image.asset("assets/images/logo.png"),
          ),
        ],
      ),
    );
  }
}
