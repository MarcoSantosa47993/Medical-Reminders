import 'package:flutter/material.dart';

class DashboardListItem<T> extends StatelessWidget {
  final T value;
  final String label;
  final bool isSelected;
  final void Function(T value)? onSelect;

  const DashboardListItem({
    super.key,
    required this.value,
    required this.label,
    this.isSelected = false,
    this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (onSelect != null) {
          onSelect!(value);
        }
      },
      child: Card(
        elevation: isSelected ? 2 : 0,
        color:
            isSelected
                ? Theme.of(context).colorScheme.secondaryContainer
                : Theme.of(context).colorScheme.surface,

        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              contentPadding: EdgeInsets.symmetric(
                vertical: 10,
                horizontal: 10,
              ),
              trailing: Icon(
                Icons.arrow_right,
                color: Theme.of(context).colorScheme.primary,
              ),
              title: Text(
                label,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
