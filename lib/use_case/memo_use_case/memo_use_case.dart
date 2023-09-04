import 'package:dartz/dartz.dart';
import 'package:everydaybible/model/failure.dart';
import 'package:everydaybible/model/memo/memo.dart';
import 'package:everydaybible/repo/memo_repo/memo_repo.dart';
import 'package:everydaybible/use_case/use_case.dart';

class MemoUseCase extends UseCase<MemoRepo> {
  MemoUseCase(super.repo);

  Stream<List<Memo>> memoListStream() {
    return repo.memoListStream().map(
          (event) => event.map((e) => Memo.fromMap(e)).toList(),
        );
  }

  Either<Failure, List<Memo>> loadMemoList() {
    try {
      final list = repo.loadMemoList().map((e) => Memo.fromMap(e)).toList();
      return Right(list);
    } catch (e) {
      return Left(Failure.fromException(e));
    }
  }

  Future<Option<Failure>> updateMemo(Memo memo) async {
    try {
      await repo.updateMemo(
        index: memo.index,
        data: memo.toMap(),
      );
      return const None();
    } catch (e) {
      return Some(Failure.fromException(e));
    }
  }

  Future<Option<Failure>> removeMemo(Memo memo) async {
    try {
      await repo.removeMemo(memo.index);
      return const None();
    } catch (e) {
      return Some(Failure.fromException(e));
    }
  }
}
