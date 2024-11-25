import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String title;
  final bool isSelected;
  final VoidCallback onPressed;

  const CustomButton({super.key, required this.title, this.isSelected = false, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: isSelected ? Colors.blue : Colors.grey,
      ),
      onPressed: onPressed,
      child: Text(title),
    );
  }
}
