import 'package:shuffle_components_kit/shuffle_components_kit.dart';

Map<String, PropertiesBaseModel> notificationMatcher(String screenName) =>
    {}..addEntries(ComponentModel.fromJson(
                GlobalConfiguration().appConfig.content['in_app_notification'])
            .content
            .properties
            ?.entries
            .where((element) => element.value.value?.toLowerCase() == screenName.toLowerCase()) ??
        {});
