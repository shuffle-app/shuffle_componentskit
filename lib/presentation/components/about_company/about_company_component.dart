import 'package:flutter/material.dart';
import 'package:shuffle_components_kit/shuffle_components_kit.dart';
import 'package:shuffle_uikit/shuffle_uikit.dart';

class AboutCompanyComponent extends StatelessWidget {
  final VoidCallback? onFinished;
  final UiAboutCompanyModel uiModel;
  final TextEditingController nameController;
  final TextEditingController positionController;
  final GlobalKey<FormState> formKey;
  final String? Function(String?)? nameValidator;
  final String? Function(String?)? positionValidator;
  final ValueChanged<String>? onAgeRangesChanged;
  final ValueChanged<String>? onAudiencesChanged;
  final ValueChanged<UiKitMenuItem<String>?>? onNicheChanged;

  const AboutCompanyComponent({
    super.key,
    required this.uiModel,
    required this.nameController,
    required this.positionController,
    required this.formKey,
    this.onNicheChanged,
    this.onFinished,
    this.onAgeRangesChanged,
    this.onAudiencesChanged,
    this.nameValidator,
    this.positionValidator,
  });

  @override
  Widget build(BuildContext context) {
    final boldTextTheme = context.uiKitTheme?.boldTextTheme;
    final colorScheme = context.uiKitTheme?.colorScheme;

    final config = GlobalComponent.of(context)?.globalConfiguration.appConfig.content ?? GlobalConfiguration().appConfig.content;
    final ComponentModel model = ComponentModel.fromJson(config['about_company']);
    final horizontalMargin = (model.positionModel?.horizontalMargin ?? 0).toDouble();
    final verticalMargin = (model.positionModel?.verticalMargin ?? 0).toDouble();

    final ageGroupsData = model
            .content.body?[ContentItemType.additionalMultiSelect]?.body?[ContentItemType.multiSelect]?.properties?.entries
            .toList() ??
        [];
    if (ageGroupsData.isNotEmpty) ageGroupsData.sort((a, b) => a.value.sortNumber?.compareTo(b.value.sortNumber ?? 0) ?? 0);
    List<String> ageGroups = ageGroupsData.map((e) => e.key).toList();
    if (ageGroups.isEmpty) ageGroups.addAll(['13-17', '18-24', '25-34', '35-44', '45-54', '54+']);
    List<String> audiences =
        model.content.body?[ContentItemType.multiSelect]?.body?[ContentItemType.multiSelect]?.properties?.keys.toList() ?? [];
    if (audiences.isEmpty) audiences = ['Luxury', 'Tourists', 'Middle class', 'Family friendly'];

    final niches = model.content.body?[ContentItemType.singleDropdown]?.body?[ContentItemType.singleDropdown]?.properties;

    return SingleChildScrollView(
      child: Form(
        key: formKey,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(
              height: MediaQuery.viewPaddingOf(context).top,
            ),
            Text(
              S.current.DescribeYourBusiness,
              style: boldTextTheme?.title1,
            ),
            SpacingFoundation.verticalSpace16,
            Stack(
              fit: StackFit.passthrough,
              children: [
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: '${S.of(context).TheMoreInfoWeGetTheBetter} ',
                        style: boldTextTheme?.subHeadline,
                      ),
                      TextSpan(
                        text: S.of(context).YourTraffic.toLowerCase(),
                        style: boldTextTheme?.subHeadline.copyWith(color: Colors.transparent),
                      ),
                      if (Localizations.localeOf(context).languageCode != 'ru')
                        TextSpan(
                          text: S.of(context).WillBe.toLowerCase(),
                          style: boldTextTheme?.subHeadline,
                        ),
                    ],
                  ),
                  textAlign: TextAlign.left,
                ),
                GradientableWidget(
                  gradient: GradientFoundation.attentionCard,
                  child: RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: '${S.of(context).TheMoreInfoWeGetTheBetter} ',
                          style: boldTextTheme?.subHeadline.copyWith(color: Colors.transparent),
                        ),
                        TextSpan(
                          text: S.of(context).YourTraffic.toLowerCase(),
                          style: boldTextTheme?.subHeadline.copyWith(color: Colors.white),
                        ),
                        if (Localizations.localeOf(context).languageCode != 'ru')
                          TextSpan(
                            text: S.of(context).WillBe.toLowerCase(),
                            style: boldTextTheme?.subHeadline.copyWith(color: Colors.transparent),
                          ),
                      ],
                    ),
                    textAlign: TextAlign.left,
                  ),
                ),
              ],
            ),
            SpacingFoundation.verticalSpace16,
            UiKitCardWrapper(
              borderRadius: BorderRadiusFoundation.max,
              child: UiKitInputFieldNoIcon(
                controller: nameController,
                hintText: S.of(context).YourName.toUpperCase(),
                fillColor: colorScheme?.surface3,
                validator: nameValidator,
              ).paddingAll(EdgeInsetsFoundation.all4),
            ),
            SpacingFoundation.verticalSpace16,
            UiKitCardWrapper(
              borderRadius: BorderRadiusFoundation.max,
              child: UiKitInputFieldNoIcon(
                controller: positionController,
                hintText: S.of(context).YourPosition.toUpperCase(),
                fillColor: colorScheme?.surface3,
                validator: positionValidator,
              ).paddingAll(EdgeInsetsFoundation.all4),
            ),
            SpacingFoundation.verticalSpace16,
            UiKitTitledSection(
              color: colorScheme?.surface,
              errorText: uiModel.errorSelectedMenuItem,
              hasError: uiModel.errorSelectedMenuItem != null,
              title: S.current.YourNiche,
              child: UiKitMenu<String>(
                tilesColor: Colors.transparent,
                useCustomTiles: false,
                onSelected: (item) => onNicheChanged?.call(item),
                title: S.current.YourNiche,
                selectedItem: uiModel.selectedMenuItem,
                items: niches?.keys.map<UiKitMenuItem<String>>(
                      (e) {
                        final item = niches[e];

                        return UiKitMenuItem<String>(
                          title: e.toUpperCase(),
                          value: item?.value,
                          iconLink: item?.imageLink ?? '',
                          type: item?.type == 'business' ? S.current.Business : S.current.Leisure,
                        );
                      },
                    ).toList() ??
                    [],
              ),
            ),
            SpacingFoundation.verticalSpace16,
            UiKitTitledSection(
              errorText: uiModel.errorSelectedAudiences,
              hasError: uiModel.errorSelectedAudiences != null,
              title: S.current.YourAudience,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Wrap(
                  spacing: SpacingFoundation.horizontalSpacing8,
                  children: audiences
                      .map(
                        (e) => UiKitOrdinaryChip(
                          title: e,
                          selected: uiModel.selectedAudiences?.contains(e) ?? false,
                          onPressed: () => onAudiencesChanged?.call(e),
                        ),
                      )
                      .toList(),
                ),
              ).paddingAll(EdgeInsetsFoundation.all4),
            ),
            SpacingFoundation.verticalSpace12,
            UiKitTitledSection(
              errorText: uiModel.errorSelectedAgeRanges,
              hasError: uiModel.errorSelectedAgeRanges != null,
              title: S.current.YourAudienceAge,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Wrap(
                  spacing: SpacingFoundation.horizontalSpacing8,
                  children: ageGroups
                      .map<Widget>(
                        (e) => UiKitOrdinaryChip(
                          title: e,
                          selected: uiModel.selectedAgeRanges?.contains(e) ?? false,
                          onPressed: () => onAgeRangesChanged?.call(e),
                        ),
                      )
                      .toList(),
                ),
              ).paddingAll(EdgeInsetsFoundation.all4),
            ),
            SpacingFoundation.verticalSpace16,
            context.button(
              data: BaseUiKitButtonData(
                text: S.of(context).Confirm.toUpperCase(),
                onPressed: onFinished,
              ),
            ),
            SpacingFoundation.verticalSpace24,
          ],
        ).paddingSymmetric(
          horizontal: horizontalMargin,
          vertical: verticalMargin,
        ),
      ),
    );
  }
}
