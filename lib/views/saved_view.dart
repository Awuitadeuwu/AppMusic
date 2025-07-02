import 'package:flutter/material.dart';

class SavedView extends StatelessWidget {
  const SavedView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        'Saved Content',
        style: TextStyle(
          fontSize: 24,
          color: Color(0xFFE0E0E0),
        ),
      ),
    );
  }
}