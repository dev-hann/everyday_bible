import 'package:everydaybible/models/bible.dart';
import 'package:everydaybible/use_case/use_case.dart';
import 'package:everydaybible/repo/bible_repo/bible_repo.dart';

class BibleUseCase extends UseCase<BibleRepo> {
  BibleUseCase(super.repo);

  dynamic loadBible() {
  }
}
