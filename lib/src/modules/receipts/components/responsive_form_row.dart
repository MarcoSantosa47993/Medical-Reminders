import 'package:flutter/material.dart';
import 'package:responsiveness/responsiveness.dart';

class ResponsiveFormRow extends StatelessWidget {
  final List<Widget> children;

  const ResponsiveFormRow({super.key, required this.children});

  @override
  Widget build(BuildContext context) {
    return ResponsiveParent<List<Widget>>(
      xs:
          (c) => Column(
            children: [
              Container(width: 402, child: c[0]),
              const SizedBox(height: 20),
              Container(width: 402, child: c[1]),
            ],
          ),
      md:
          (c) => Row(
            children: [
              Expanded(child: Container(width: 402, child: c[0])),
              const SizedBox(width: 20),
              Expanded(child: Container(width: 402, child: c[1])),
            ],
          ),
      child: children,
    );
  }
}
