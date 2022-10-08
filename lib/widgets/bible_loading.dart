import 'package:flutter/material.dart';

class BibleLoading extends StatelessWidget {
  const BibleLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }
}
