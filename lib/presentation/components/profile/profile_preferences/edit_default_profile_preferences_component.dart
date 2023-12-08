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

    return Scaffold(
      body: BlurredAppBarPage(
        title: S.of(context).Preferences,
        centerTitle: true,
        autoImplyLeading: true,
        children: [
          SpacingFoundation.verticalSpace16,
          // UiKitTagSelector(
          /// здесь стоит подумать что если нет тэгов на выбор
          // tags: preferencesModel.preferences ?? [],
          // onTagsSelected: (tags) => onSelectedPreferencesChanged?.call(tags),
          // ),
        ],
      ),
    );
  }
}
