import 'package:flutter/material.dart';

class DeleteConfirmationDialog extends StatelessWidget {
  final String title;
  final String content;
  final IconData icon;
  final Color color;
  final VoidCallback onConfirm;

  const DeleteConfirmationDialog({
    super.key,
    required this.title,
    required this.content,
    required this.icon,
    required this.color,
    required this.onConfirm,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      content: Container(
        width: 312,
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 40, color: color),
            const SizedBox(height: 16),
            Text(
              title,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: color,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Text(content, textAlign: TextAlign.left),
          ],
        ),
      ),
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'Back',
                style: TextStyle(color: Theme.of(context).colorScheme.tertiary),
              ),
            ),
            const SizedBox(width: 16),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: color,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(100),
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                onConfirm();
              },
              child: const Text('Delete'),
            ),
          ],
        ),
      ],
    );
  }
}
