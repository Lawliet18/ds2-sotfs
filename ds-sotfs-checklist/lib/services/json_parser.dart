import 'dart:convert';
import 'dart:io';

import 'package:flutter/services.dart';

class JsonParser {
  JsonParser._();

  static final instance = JsonParser._();

  Future<List<dynamic>> parsePlaythrough() async {
    final json = await rootBundle.loadString('assets/json/playthrough.json');
    final parsed = jsonDecode(json) as List<dynamic>;
    return parsed;
  }

  Future<List<dynamic>> parseAchievement() async {
    final json = await rootBundle.loadString('assets/json/achievements.json');
    final parsed = jsonDecode(json) as List<dynamic>;
    return parsed;
  }
}
