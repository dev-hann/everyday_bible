import 'package:everydaybible/repo/repo.dart';

/// Base class for use cases, holding the repository they orchestrate.
abstract class UseCase<T extends Repo> {
  /// Creates a use case operating on [repo].
  UseCase(this.repo);

  /// The repository this use case delegates to.
  final T repo;
}
