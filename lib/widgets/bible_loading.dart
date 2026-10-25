import 'package:flutter/material.dart';

/// Loading indicator shown while Bible or QT data is being fetched.
class BibleLoading extends StatelessWidget {
  /// Creates the loading indicator.
  const BibleLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }
}
