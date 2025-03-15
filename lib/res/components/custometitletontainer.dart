import 'package:flutter/material.dart';

class CustomTitleContainer extends StatelessWidget {
  final String titleText;

  const CustomTitleContainer({super.key, required this.titleText});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.amber[700],
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(7.0),
          border: Border.all(
            color: const Color(0x4d9e9e9e),
            width: 0,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(15, 3, 15, 3),
          child: Text(
            titleText,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
