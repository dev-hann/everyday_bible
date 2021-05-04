import 'package:everydaybible/models/quite_time.dart';
import 'package:everydaybible/utils/qt_utils/qt_hive_database.dart';
import 'package:everydaybible/utils/qt_utils/qt_web_parser.dart';
import 'package:get/get.dart';

class QTController extends GetxController {
  QuiteTime? _selectedQT;

  QuiteTime? get selectedQT => _selectedQT;

  QTHiveDatabase _hiveDatabase = QTHiveDatabase();
  QTWebParser _qtWebParser = QTWebParser();

  Rx<bool> loading =true.obs;

  void init() async {
    if(_selectedQT!=null)return;
    await _hiveDatabase.openBox("QT");
    await loadData(DateTime.now());
  }

  ///[todo] add loading state Flag!
  Future<void> loadData(DateTime dateTime) async {
    loading.value=true;
    QuiteTime? _tmpData = _hiveDatabase.readData(dateTime);
    if (_tmpData == null) {
      _tmpData = await _qtWebParser.readData(dateTime);
      _hiveDatabase.addData(_tmpData);
    }
    _selectedQT = _tmpData;
    loading.value=false;
    update();
  }
}
