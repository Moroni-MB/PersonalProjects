import 'package:flutter/material.dart';

class CompletedPage extends StatelessWidget {
  const CompletedPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const SafeArea(
      child: Center(
        child: Text(
          'Completed Page',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}