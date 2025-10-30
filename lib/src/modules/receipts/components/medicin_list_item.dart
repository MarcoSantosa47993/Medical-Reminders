import 'package:flutter/material.dart';
import 'package:medicins_schedules/src/modules/receipts/models/medicin.dart';

class MedicineListItem extends StatelessWidget {
  final Medicine medicine;
  final VoidCallback? onView;
  final VoidCallback? onDelete;
  final VoidCallback? onAdministrate;

  const MedicineListItem({
    super.key,
    required this.medicine,
    required this.onView,
    required this.onDelete,
    required this.onAdministrate,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        height: 63,
        alignment: Alignment.center,
        child: Row(
          children: [
            Expanded(
              child: RichText(
                text: TextSpan(
                  style: DefaultTextStyle.of(context).style,
                  children: [
                    TextSpan(
                      text:
                          '${medicine.quantity} Units | ${medicine.observations}\n',
                      style: Theme.of(context).textTheme.labelMedium,
                    ),
                    TextSpan(
                      text: medicine.name,
                      style: const TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.remove_red_eye),
              onPressed: onView,
              color: Theme.of(context).colorScheme.secondary,
            ),
            const SizedBox(width: 8),
            IconButton(
              icon: const Icon(Icons.close),
              onPressed: onDelete,
              color: Theme.of(context).colorScheme.error,
            ),
            const SizedBox(width: 8),
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.secondaryContainer,
                shape: BoxShape.circle,
              ),
              child: IconButton(
                icon: const Icon(Icons.archive_outlined),
                onPressed: onAdministrate,
                color: Theme.of(context).colorScheme.onSecondaryContainer,
                iconSize: 20,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
