import 'package:flutter/material.dart';

class MyButton extends StatelessWidget {
  final Function()? onTap;
  final String text;

  const MyButton({super.key, required this.onTap, required this.text});

  @override
  Widget build(BuildContext context) {
    // Access the TextTheme from the current context
    final textTheme = Theme.of(context).textTheme;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(25),
        margin: const EdgeInsets.symmetric(horizontal: 25),
        decoration: BoxDecoration(
            color: Colors.black, borderRadius: BorderRadius.circular(8)),
        child: Center(
          child: Text(
            text,
            style: textTheme.bodyMedium?.copyWith(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.grey[300]),
          ),
        ),
      ),
    );
  }
}
