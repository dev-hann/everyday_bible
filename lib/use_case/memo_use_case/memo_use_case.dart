import 'package:everydaybible/model/failure.dart';
import 'package:everydaybible/model/memo/memo.dart';
import 'package:everydaybible/repo/memo_repo/memo_repo.dart';
import 'package:everydaybible/use_case/use_case.dart';
import 'package:fpdart/fpdart.dart';

/// Use case reading and writing memos through [MemoRepo].
class MemoUseCase extends UseCase<MemoRepo> {
  /// Creates a memo use case backed by [repo].
  MemoUseCase(super.repo);

  /// Live stream of all memos, re-emitted on every table change.
  Stream<List<Memo>> memoListStream() {
    return repo.memoListStream().map(
          (event) => event
              .map((e) => Memo.fromMap(e as Map<String, dynamic>))
              .toList(),
        );
  }

  /// Loads the cached memo list; [Left] carries the [Failure] on a parse
  /// error.
  Either<Failure, List<Memo>> loadMemoList() {
    try {
      final list = repo
          .loadMemoList()
          .map((e) => Memo.fromMap(e as Map<String, dynamic>))
          .toList();
      return Right(list);
    } on Object catch (e) {
      return Left(Failure.fromException(e));
    }
  }

  /// Upserts [memo]; returns [None] on success or [Some] with a [Failure].
  Future<Option<Failure>> updateMemo(Memo memo) async {
    try {
      await repo.updateMemo(
        index: memo.index,
        data: memo.toMap(),
      );
      return const None();
    } on Object catch (e) {
      return Some(Failure.fromException(e));
    }
  }

  /// Deletes [memo]; returns [None] on success or [Some] with a [Failure].
  Future<Option<Failure>> removeMemo(Memo memo) async {
    try {
      await repo.removeMemo(memo.index);
      return const None();
    } on Object catch (e) {
      return Some(Failure.fromException(e));
    }
  }
}
