import 'package:flutter/material.dart';
import 'package:shuffle_components_kit/domain/config_models/about_user/component_about_user_model.dart';
import 'package:shuffle_components_kit/presentation/components/about_user/ui_about_user_model.dart';
import 'package:shuffle_components_kit/presentation/widgets/global_component.dart';
import 'package:shuffle_components_kit/services/configuration/global_configuration.dart';
import 'package:shuffle_uikit/shuffle_uikit.dart';

class AboutUserComponent extends StatelessWidget {
  final UiAboutUserModel aboutUserModel;
  final VoidCallback? onSubmitUserData;
  final ValueChanged<String>? onReligionChanged;
  final ValueChanged<String?>? onPersonTypeChanged;

  final TextEditingController nameController = TextEditingController();
  final TextEditingController nickNameController = TextEditingController();

  AboutUserComponent({
    Key? key,
    required this.aboutUserModel,
    this.onReligionChanged,
    this.onPersonTypeChanged,
    this.onSubmitUserData,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final config = GlobalComponent.of(context)?.globalConfiguration.appConfig.content ?? GlobalConfiguration().appConfig.content;
    final ComponentAboutUserModel model = ComponentAboutUserModel.fromJson(config['about_user']);

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        UiKitCardWrapper(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              UiKitInputFieldNoIcon(
                controller: nameController,
                hintText: 'NAME',
              ),
              SpacingFoundation.verticalSpace16,
              UiKitInputFieldNoIcon(
                controller: nickNameController,
                hintText: 'NICKNAME',
              ),
            ],
          ).paddingAll(EdgeInsetsFoundation.all4),
        ),
        if (aboutUserModel.personTypes != null) ...[
          SpacingFoundation.verticalSpace16,
          UiKitMenu<String>(
            title: 'Describe yourself',
            items: aboutUserModel.personTypes!
                .map<UiKitMenuItem<String>>(
                  (e) => UiKitMenuItem<String>(
                    title: e,
                    value: e,
                  ),
                )
                .toList(),
            onSelected: (personType) => onPersonTypeChanged?.call(personType.value),
          ),
        ],
        if (aboutUserModel.religions != null) ...[
          SpacingFoundation.verticalSpace16,
          UiKitTitledSection(
            title: 'Select your religions',
            child: ListView.separated(
              itemBuilder: (context, index) {
                final data = aboutUserModel.religions![index];

                return UiKitBorderedChipWithIcon(
                  icon: data.icon,
                  title: data.title,
                  isSelected: data.isSelected,
                  onPressed: () => onReligionChanged?.call(data.title),
                );
              },
              separatorBuilder: (context, index) => SpacingFoundation.horizontalSpace8,
              itemCount: aboutUserModel.religions!.length,
            ),
          ),
        ],
        SpacingFoundation.verticalSpace16,
        UiKitHorizontalWheelNumberSelector(
          values: List<int>.generate(70, (index) => index + 10),
          title: 'Your age',
        ),
        if (aboutUserModel.genders != null) ...[
          SpacingFoundation.verticalSpace16,
          UiKitTitledSection(
            title: 'Gender',
            child: Row(
              mainAxisSize: MainAxisSize.max,
              children: aboutUserModel.genders!
                  .map(
                    (e) => UiKitSignWithCaption(
                      caption: e.caption,
                      sign: e.sign,
                    ),
                  )
                  .toList(),
            ),
          ),
        ],
        SpacingFoundation.verticalSpace16,
        context.button(
          text: 'CONFIRM',
          onPressed: () => onSubmitUserData?.call(),
        ),
      ],
    );
  }
}
