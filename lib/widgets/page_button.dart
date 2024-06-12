import 'package:flutter/material.dart';

class PageButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final Color color;
  final Color textColor;


  const PageButton({super.key, 
    required this.label,
    required this.onPressed,
    required this.color,
    required this.textColor, 
     
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12), // Adjust the radius as needed
        ),
      ),
      child: Text(
        label,
        style: TextStyle(color: textColor),
      ),
    );
  }
}
