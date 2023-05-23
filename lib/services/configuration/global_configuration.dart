import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:shuffle_components_kit/shuffle_components_kit.dart';

class GlobalConfiguration {
  static final GlobalConfiguration _singleton = GlobalConfiguration._internal();
  static String _configUrl = ConfigConstants.configUrl;
  final Completer _completer = Completer();
  ConfigurationModel appConfig = ConfigurationModel(
      updated: DateTime.now(), content: {}, theme: 'default');

  bool get isLoaded => _completer.isCompleted;

  factory GlobalConfiguration([String? configUrl]) {
    if (configUrl != null) {
      _configUrl = configUrl;
    }

    return _singleton;
  }

  GlobalConfiguration._internal();

  Future<GlobalConfiguration> load(
      {String version = '1.0.0', String? userId}) async {
    try {
      File? cache = kIsWeb ? null : await _loadFromDocument();
      late final String cacheAsString;
      late ConfigurationModel model;
      if (cache != null && cache.existsSync()) {
        cacheAsString = await cache.readAsString();
        if (cacheAsString.isNotEmpty) {
          model = ConfigurationModel.fromJson(jsonDecode(cacheAsString));
          //TODO change to days
          // print('here is load from GlobalConfiguration model.updated.difference(DateTime.now()) ${model.updated.difference(DateTime.now())} ${model.updated.difference(DateTime.now()).inMinutes}');
          if (model.updated.difference(DateTime.now()).inMinutes.abs() > 1) {
            model = await _loadAndSaveConfig(version, userId);
          }
        } else {
          model = await _loadAndSaveConfig(version, userId);
        }
      } else {
        model = await _loadAndSaveConfig(version, userId);
      }
      appConfig = model;
      if (!_completer.isCompleted) _completer.complete();
    } catch (e, t) {
      generalErrorCatch(e, t);
      if (kDebugMode) {
        rethrow;
      }
    }

    return _singleton;
  }

  Future<ConfigurationModel> _loadAndSaveConfig(String version,
      [String? userId]) async {
    if (userId != null) {
      ConfigConstants.configHeaders.putIfAbsent('userId', () => userId);
    }
    Map<String, dynamic> configAsMap = await _getFromUrl(
        '${_configUrl}settings/config/v$version',
        headers: ConfigConstants.configHeaders);
    final model = ConfigurationModel(
        updated: DateTime.now(),
        content: configAsMap,
        theme: configAsMap['theme_name']);
    unawaited(_saveToDocument());

    return model;
  }

  Future<void> _saveToDocument() async {
    if (kIsWeb) {
      return;
    }
    var provider = await getApplicationDocumentsDirectory();
    final File file = File(p.join(provider.path, ConfigConstants.configPath));
    await file.create(recursive: true);
    await file.writeAsString(jsonEncode(appConfig.toJson()));
  }

  Future<File> _loadFromDocument() async {
    var provider = await getApplicationDocumentsDirectory();

    return File(p.join(provider.path, ConfigConstants.configPath));
  }

  Future<Map<String, dynamic>> _getFromUrl(String url,
      {Map<String, String>? queryParameters,
      Map<String, String>? headers}) async {
    String finalUrl = url;
    if (queryParameters != null) {
      queryParameters.forEach((k, v) {
        finalUrl += !finalUrl.endsWith('?') ? '?$k=$v' : '&$k=$v';
      });
    }
    headers ??= <String, String>{};
    Map<String, String>? usableHeader = Map.from(headers);
    usableHeader.putIfAbsent('Accept', () => 'application/json');

    var encodedUri = Uri.encodeFull(finalUrl);
    var response = await http.get(Uri.parse(encodedUri), headers: usableHeader);
    if (response.statusCode != 200) {
      throw Exception(
          'HTTP request failed, statusCode: ${response.statusCode}, $finalUrl');
    }

    return json.decode(response.body);
  }
}
