import 'package:ds_soft_checklist/models/playthrough.dart';
import 'package:ds_soft_checklist/models/task.dart';
import 'package:ds_soft_checklist/services/data_provider.dart';

class PlaythroughRepository {
  final _dataProvider = DataProvider();

  Future<List<Playthrough>> getData() async =>
      await _dataProvider.getNameFromPlaythrough();
}
