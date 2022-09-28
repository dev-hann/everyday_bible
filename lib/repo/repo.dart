import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class Repo {

  Future init();
  
  static T of<T>(BuildContext context) {
    return RepositoryProvider.of<T>(context, listen: false);
  }
}
