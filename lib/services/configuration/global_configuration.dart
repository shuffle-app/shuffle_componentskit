import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:shuffle_components_kit/shuffle_components_kit.dart';

class GlobalConfiguration {
  static final GlobalConfiguration _singleton = GlobalConfiguration._internal();
  static String _configUrl = ConfigConstants.configAlternativeUrl;
  static int _timeout = 1;
  static String? _languageCode;
  final Completer _completer = Completer();
  ConfigurationModel appConfig = ConfigurationModel(updated: DateTime.now(), content: {}, theme: 'default');

  bool get isLoaded => _completer.isCompleted;

  factory GlobalConfiguration([String? configUrl, String? languageCode, int? timeout]) {
    if (configUrl != null) {
      _configUrl = configUrl;
    }
    if (timeout != null) {
      _timeout = timeout;
    }
    if (languageCode != null) {
      _languageCode = languageCode;
    }

    return _singleton;
  }

  GlobalConfiguration._internal();

  Future<GlobalConfiguration> load({String version = '1.0.0', String? userId,bool forceUpdate = false}) async {
    File? cache = kIsWeb ? null : await _loadFromDocument();
    late final String cacheAsString;
    late ConfigurationModel model;
    if (cache != null && cache.existsSync()) {
      cacheAsString = await cache.readAsString();
      if (cacheAsString.isNotEmpty && !forceUpdate) {
        model = ConfigurationModel.fromJson(jsonDecode(cacheAsString));
        //TODO change to days
        // print('here is load from GlobalConfiguration model.updated.difference(DateTime.now()) ${model.updated.difference(DateTime.now())} ${model.updated.difference(DateTime.now()).inMinutes}');
        if (model.updated.difference(DateTime.now()).inMinutes.abs() > _timeout) {
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

    return _singleton;
  }

  Future<ConfigurationModel> _loadAndSaveConfig(String version, [String? userId]) async {
    if (userId != null) {
      ConfigConstants.configHeaders.putIfAbsent('userId', () => userId);
    }
    Map<String, dynamic> configAsMap = (await _getFromUrl('http://${_configUrl}/api/v1/settings/config/$version',
        queryParameters: _languageCode != null ? {'lang': _languageCode!} : null,
        headers: ConfigConstants.configHeaders))['config'];
    // print('got configAsMap $configAsMap');
    final model = ConfigurationModel(updated: DateTime.now(), content: configAsMap, theme: configAsMap['theme_name']);
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
      {Map<String, String>? queryParameters, Map<String, String>? headers}) async {
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
    log('finalUrl for fetching config: $encodedUri', name: 'GlobalConfiguration|loadFromUrl');
    var response = await http.get(Uri.parse(encodedUri), headers: usableHeader);
    if (response.statusCode != 200) {
      throw Exception('HTTP request failed, statusCode: ${response.statusCode}, $finalUrl');
    }

    return json.decode(response.body);
  }
}
