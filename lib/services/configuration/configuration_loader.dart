import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:shuffle_components_kit/shuffle_components_kit.dart';

import 'data/configuration_model.dart';

class GlobalConfiguration {
  static GlobalConfiguration _singleton = GlobalConfiguration._internal();

  factory GlobalConfiguration() {
    return _singleton;
  }

  final Completer _compliter = Completer();

  bool get isLoaded => _compliter.isCompleted;

  GlobalConfiguration._internal();

  ConfigurationModel appConfig = ConfigurationModel(
      updated: DateTime.now(), content: {}, theme: 'default');

  Future<GlobalConfiguration> load() async {
    try {
      File? cache = kIsWeb ? null : await _loadFromDocument();
      late final String cacheAsString;
      late ConfigurationModel model;
      if (cache != null && cache.existsSync()) {
        cacheAsString = await cache.readAsString();
        if (cacheAsString.isNotEmpty) {
          model = ConfigurationModel.fromJson(jsonDecode(cacheAsString));
          if (model.updated.difference(DateTime.now()).inDays > 1) {
            model = await _loadAndSaveConfig();
          }
        } else {
          model = await _loadAndSaveConfig();
        }
      } else {
        model = await _loadAndSaveConfig();
      }
      appConfig = model;
      _compliter.complete();
    } catch (e, t) {
      generalErrorCatch(e, t);
    }

    return _singleton;
  }

  Future<ConfigurationModel> _loadAndSaveConfig() async {
    Map<String, dynamic> configAsMap = await _getFromUrl(
        ConfigConstants.configUrl,
        headers: ConfigConstants.configHeaders);
    final model = ConfigurationModel(
        updated: DateTime.now(),
        content: configAsMap,
        theme: configAsMap['theme_name']);
    _saveToDocument();
    return model;
  }

  Future<void> _saveToDocument() async {
    if (kIsWeb) {
      return;
    }
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
    Map<String, String>? usableHeader = Map.from(headers);
    usableHeader.putIfAbsent("Accept", () => "application/json");

    var encodedUri = Uri.encodeFull(finalUrl);
    var response = await http.get(Uri.parse(encodedUri), headers: usableHeader);
    if (response.statusCode != 200) {
      throw Exception(
          'HTTP request failed, statusCode: ${response.statusCode}, $finalUrl');
    }
    return json.decode(response.body);
  }
}
