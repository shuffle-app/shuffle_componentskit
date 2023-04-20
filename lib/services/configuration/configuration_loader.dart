import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:shuffle_components_kit/services/configuration/data/config_constants.dart';

import 'data/configuration_model.dart';

class GlobalConfiguration {
  static GlobalConfiguration _singleton = GlobalConfiguration._internal();

  factory GlobalConfiguration() {
    return _singleton;
  }

  GlobalConfiguration._internal();

  ConfigurationModel appConfig = ConfigurationModel(
      updated: DateTime.now(), content: {}, theme: 'default');

  Future<GlobalConfiguration> load() async {
    File cache = await _loadFromDocument();
    final String cacheAsString = await cache.readAsString();
    late final ConfigurationModel model;
    if (cacheAsString.isNotEmpty) {
      model = ConfigurationModel.fromJson(jsonDecode(cacheAsString));
    }
    if (cacheAsString.isEmpty ||
        model.updated.difference(DateTime.now()).inDays > 1) {
      Map<String, dynamic> configAsMap = await _getFromUrl(
          ConfigConstants.configUrl,
          headers: ConfigConstants.configHeaders);
      appConfig = ConfigurationModel(
          updated: DateTime.now(),
          content: configAsMap,
          theme: configAsMap['theme_name']);
      _saveToDocument();
    }
    return _singleton;
  }

  Future<void> _saveToDocument() async {
    var provider = await getApplicationDocumentsDirectory();
    final File file =
        File(p.join(provider.path, 'appConfig/generalConfigCache'));
    file.writeAsString(jsonEncode(appConfig.toJson()));
  }

  Future<File> _loadFromDocument() async {
    var provider = await getApplicationDocumentsDirectory();
    return File(p.join(provider.path, 'appConfig/generalConfigCache'));
  }

  Future<Map<String, dynamic>> _getFromUrl(String url,
      {Map<String, String>? queryParameters,
      Map<String, String>? headers}) async {
    String finalUrl = url;
    if (queryParameters != null) {
      queryParameters.forEach((k, v) {
        finalUrl += !finalUrl.endsWith("?") ? "?$k=$v" : "&$k=$v";
      });
    }
    headers ??= <String, String>{};
    headers.putIfAbsent("Accept", () => "application/json");
    var encodedUri = Uri.encodeFull(finalUrl);
    var response = await http.get(Uri.parse(encodedUri), headers: headers);
    if (response.statusCode != 200) {
      throw Exception(
          'HTTP request failed, statusCode: ${response.statusCode}, $finalUrl');
    }
    return json.decode(response.body);
  }
}
