import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class Repo {
  static T of<T extends Repo>(BuildContext context) {
    return RepositoryProvider.of<T>(context, listen: false);
  }
}
