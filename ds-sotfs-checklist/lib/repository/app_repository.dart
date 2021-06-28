import 'package:ds_soft_checklist/services/data_provider.dart';

class AppRepository {
  final dataProvider = DataProvider.instance;

  Future<void> loadDataFromDataBase() async =>
      await dataProvider.loadDataOnFirstStart();

  Future<bool> get isDatabaseExist async => await dataProvider.isDatabaseExists;

  Future<void> saveDatabaseLoadKey() async =>
      await dataProvider.saveBool('isDatabaseLoad', value: true);

  Future<void> initSharedPrefs() async => await dataProvider.initSharedPrefs();

  bool get isDatabaseLoad => dataProvider.loadBoolValue('isDatabaseLoad');
}
