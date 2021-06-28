import '../services/data_provider.dart';

class AppRepository {
  final dataProvider = DataProvider.instance;

  Future<void> loadDataFromDataBase() => dataProvider.loadDataOnFirstStart();

  Future<bool> get isDatabaseExist => dataProvider.isDatabaseExists;

  Future<void> saveDatabaseLoadKey() =>
      dataProvider.saveBool('isDatabaseLoad', value: true);

  Future<void> initSharedPrefs() => dataProvider.initSharedPrefs();

  bool get isDatabaseLoad => dataProvider.loadBoolValue('isDatabaseLoad');
}
