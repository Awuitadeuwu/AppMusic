import 'package:flutter/material.dart';

class CommuteView extends StatelessWidget {
  const CommuteView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        'Commute Content',
        style: TextStyle(
          fontSize: 24,
          color: Color(0xFFE0E0E0),
        ),
      ),
    );
  }
}