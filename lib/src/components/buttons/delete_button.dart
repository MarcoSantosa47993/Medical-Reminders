import 'package:flutter/material.dart';

class DeleteButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;

  const DeleteButton({super.key, required this.onPressed, required this.text});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ButtonStyle(
        backgroundColor: WidgetStatePropertyAll(Colors.transparent),
        foregroundColor: WidgetStatePropertyAll(Colors.red),
        overlayColor: WidgetStateProperty.resolveWith<Color?>((
          Set<WidgetState> states,
        ) {
          if (states.contains(WidgetState.hovered)) {
            return Colors.red.withValues(alpha: 0.1);
          }
          return Colors.transparent;
        }),
        elevation: WidgetStateProperty.all(0),
        minimumSize: WidgetStateProperty.all(const Size(double.infinity, 50)),
        padding: WidgetStateProperty.all(
          const EdgeInsets.symmetric(vertical: 12),
        ),
        shape: WidgetStateProperty.all(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
      onPressed: onPressed,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.delete_outline, color: Colors.red.shade700),
          const SizedBox(width: 8),
          Text(
            text,
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
              color: Theme.of(context).colorScheme.error,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
