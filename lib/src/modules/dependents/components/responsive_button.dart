import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:responsiveness/responsiveness.dart';

class ResponsiveButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final String shortLabel;
  final String mediumLabel;
  final String route;
  final String extra;

  const ResponsiveButton({
    required this.icon,
    required this.label,
    required this.shortLabel,
    required this.mediumLabel,
    required this.route,
    required this.extra,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: ResponsiveChild(
        xs: OutlinedButton(
          style: ButtonStyle(
            foregroundColor: WidgetStatePropertyAll(
              Theme.of(context).colorScheme.tertiary,
            ),
            padding: WidgetStatePropertyAll(
              EdgeInsets.symmetric(horizontal: 8),
            ),
          ),
          onPressed: () => context.go(route, extra: extra),
          child: Icon(icon, size: 18),
        ),
        sm: OutlinedButton(
          style: ButtonStyle(
            foregroundColor: WidgetStatePropertyAll(
              Theme.of(context).colorScheme.tertiary,
            ),
            padding: WidgetStatePropertyAll(
              EdgeInsets.symmetric(horizontal: 10),
            ),
          ),
          onPressed: () => context.go(route, extra: extra),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 18),
              SizedBox(width: 6),
              Text(
                shortLabel,
                style: Theme.of(context).textTheme.labelSmall!.copyWith(
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).colorScheme.tertiary,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
        md: OutlinedButton(
          style: ButtonStyle(
            foregroundColor: WidgetStatePropertyAll(
              Theme.of(context).colorScheme.tertiary,
            ),
            padding: WidgetStatePropertyAll(
              EdgeInsets.symmetric(horizontal: 11),
            ),
          ),
          onPressed: () => context.go(route, extra: extra),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 18),
              SizedBox(width: 8),
              Text(
                mediumLabel,
                style: Theme.of(context).textTheme.labelSmall!.copyWith(
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).colorScheme.tertiary,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
        lg: OutlinedButton(
          style: ButtonStyle(
            foregroundColor: WidgetStatePropertyAll(
              Theme.of(context).colorScheme.tertiary,
            ),
            padding: WidgetStatePropertyAll(
              EdgeInsets.symmetric(horizontal: 11),
            ),
          ),
          onPressed: () => context.go(route, extra: extra),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 18),
              SizedBox(width: 8),
              Text(
                mediumLabel,
                style: Theme.of(context).textTheme.labelSmall!.copyWith(
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).colorScheme.tertiary,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
        additionalWidgets: {
          1100: OutlinedButton(
            style: ButtonStyle(
              foregroundColor: WidgetStatePropertyAll(
                Theme.of(context).colorScheme.tertiary,
              ),
              padding: WidgetStatePropertyAll(
                EdgeInsets.symmetric(horizontal: 12),
              ),
            ),
            onPressed: () => context.go(route, extra: extra),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, size: 20),
                SizedBox(width: 8),
                Text(
                  label,
                  style: Theme.of(context).textTheme.labelSmall!.copyWith(
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).colorScheme.tertiary,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        },
      ),
    );
  }
}
