import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Base class for all repositories.
abstract class Repo {
  /// Returns the repository of type [T] registered for [context].
  static T of<T extends Repo>(BuildContext context) {
    return RepositoryProvider.of<T>(context);
  }
}
