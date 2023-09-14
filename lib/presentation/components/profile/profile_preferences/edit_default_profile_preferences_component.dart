import 'package:flutter/material.dart';
import 'package:shuffle_components_kit/shuffle_components_kit.dart';
import 'package:shuffle_uikit/shuffle_uikit.dart';

class EditDefaultProfilePreferencesComponent extends StatelessWidget {
  final UiEditDefaultProfilePreferencesModel preferencesModel;
  final ValueChanged<List<String>>? onSelectedPreferencesChanged;

  const EditDefaultProfilePreferencesComponent({
    Key? key,
    required this.preferencesModel,
    this.onSelectedPreferencesChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final config = GlobalComponent.of(context)?.globalConfiguration.appConfig.content ?? GlobalConfiguration().appConfig.content;
    final ComponentEditProfilePreferencesModel model = ComponentEditProfilePreferencesModel.fromJson(config['profile_preferences']);
    final horizontalMargin = (model.positionModel?.horizontalMargin ?? 0).toDouble();
    final verticalMargin = (model.positionModel?.verticalMargin ?? 0).toDouble();

    return Scaffold(
      body: BlurredAppBarPage(
        title: 'Preferences',
        centerTitle: true,
        autoImplyLeading: true,
        body: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SpacingFoundation.verticalSpace16,
            // UiKitTagSelector(
            /// здесь стоит подумать что если нет тэгов на выбор
              // tags: preferencesModel.preferences ?? [],
              // onTagsSelected: (tags) => onSelectedPreferencesChanged?.call(tags),
            // ),
          ],
        ).paddingSymmetric(
          horizontal: horizontalMargin,
          vertical: verticalMargin,
        ),
      ),
    );
  }
}
