import 'package:everydaybible/repo/repo.dart';

abstract class UseCase<T extends Repo> {
  UseCase(this.repo);
  final T repo;
}
