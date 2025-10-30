import 'package:flutter/material.dart';

class MySearchInput extends StatelessWidget {
  final Function(String)? onChanged;
  final TextEditingController controller;

  const MySearchInput({super.key, this.onChanged, required this.controller});

  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
        hintText: "Search...",
        filled: true,
        suffixIcon: Icon(Icons.search),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(100.0),
          borderSide: BorderSide(width: 0, style: BorderStyle.none),
        ),

        contentPadding: EdgeInsets.symmetric(horizontal: 20.0),
      ),
      onChanged: onChanged,
      controller: controller,
    );
  }
}
