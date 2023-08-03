import 'package:flutter/material.dart';
import 'package:shuffle_components_kit/shuffle_components_kit.dart';
import 'package:shuffle_uikit/shuffle_uikit.dart';

class AboutCompanyComponent extends StatelessWidget {
  final VoidCallback? onFinished;
  final UiAboutCompanyModel uiModel;
  final ValueChanged<String>? onAgeRangesChanged;
  final ValueChanged<String>? onAudiencesChanged;
  final ValueChanged<UiKitMenuItem<String>?>? onNicheChanged;

  const AboutCompanyComponent({
    super.key,
    required this.uiModel,
    this.onNicheChanged,
    this.onFinished,
    this.onAgeRangesChanged,
    this.onAudiencesChanged,
  });

  @override
  Widget build(BuildContext context) {
    final boldTextTheme = context.uiKitTheme?.boldTextTheme;

    final config = GlobalComponent.of(context)?.globalConfiguration.appConfig.content ?? GlobalConfiguration().appConfig.content;
    final ComponentModel model = ComponentModel.fromJson(config['about_company']);
    final horizontalMargin = (model.positionModel?.horizontalMargin ?? 0).toDouble();
    final verticalMargin = (model.positionModel?.verticalMargin ?? 0).toDouble();
    String ageGroupsTitle = '';
    if (model.content.body?[ContentItemType.additionalMultiSelect]?.title?[ContentItemType.text]?.properties?.isNotEmpty ?? false) {
      ageGroupsTitle =
          model.content.body?[ContentItemType.additionalMultiSelect]?.title?[ContentItemType.text]?.properties?.keys.first ?? '';
    }
    final ageGroups =
        model.content.body?[ContentItemType.additionalMultiSelect]?.body?[ContentItemType.multiSelect]?.properties?.keys.toList() ??
            [];
    ageGroups.sort((a, b) => int.parse(a.characters.first).compareTo(int.parse(b.characters.first)));
    String audiencesTitle = '';
    if (model.content.body?[ContentItemType.multiSelect]?.title?[ContentItemType.text]?.properties?.isNotEmpty ?? false) {
      audiencesTitle = model.content.body?[ContentItemType.multiSelect]?.title?[ContentItemType.text]?.properties?.keys.first ?? '';
    }
    final audiences =
        model.content.body?[ContentItemType.multiSelect]?.body?[ContentItemType.multiSelect]?.properties?.keys.toList() ?? [];
    final nicheTitle = model.content.body?[ContentItemType.singleDropdown]?.title?[ContentItemType.text]?.properties?.keys.first ?? '';
    final niches = model.content.body?[ContentItemType.singleDropdown]?.body?[ContentItemType.singleDropdown]?.properties;
    final pageTitle = model.content.title?[ContentItemType.text]?.properties?.keys.first ?? '';
    // final gradientableText = model.content.title?[ContentItemType.textGradientable]?.properties?.keys.toList().reversed ?? [];
    // print(gradientableText);

    return Column(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(
          height: MediaQuery.of(context).viewPadding.top,
        ),
        Text(
          pageTitle,
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
                    text: 'The more info we get, the better ',
                    style: boldTextTheme?.subHeadline.copyWith(color: Colors.white.withOpacity(1)),
                  ),
                  TextSpan(text: 'your traffic', style: boldTextTheme?.subHeadline.copyWith(color: Colors.white.withOpacity(0))),
                  TextSpan(
                    text: ' will be.',
                    style: boldTextTheme?.subHeadline.copyWith(color: Colors.white.withOpacity(1)),
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
                      text: 'The more info we get, the better ',
                      style: boldTextTheme?.subHeadline.copyWith(color: Colors.white.withOpacity(0)),
                    ),
                    TextSpan(text: 'your traffic', style: boldTextTheme?.subHeadline.copyWith(color: Colors.white.withOpacity(1))),
                    TextSpan(
                      text: ' will be.',
                      style: boldTextTheme?.subHeadline.copyWith(color: Colors.white.withOpacity(0)),
                    ),
                  ],
                ),
                textAlign: TextAlign.left,
              ),
            ),
          ],
        ),
        const Spacer(),
        UiKitTitledSection(
          errorText: uiModel.errorSelectedMenuItem,
          hasError: uiModel.errorSelectedMenuItem != null,
          title: nicheTitle,
          child: UiKitMenu<String>(
            onSelected: (item) => onNicheChanged?.call(item),
            title: nicheTitle,
            selectedItem: uiModel.selectedMenuItem,
            items: niches?.keys.map<UiKitMenuItem<String>>((e) {
                  final item = niches[e];

                  return UiKitMenuItem<String>(
                    title: e.toUpperCase(),
                    value: item?.value,
                    icon: ImageWidget(link: item?.imageLink ?? ''),
                    type: item?.type,
                  );
                }).toList() ??
                [],
          ).paddingAll(EdgeInsetsFoundation.all4),
        ),
        SpacingFoundation.verticalSpace16,
        UiKitTitledSection(
          errorText: uiModel.errorSelectedAudiences,
          hasError: uiModel.errorSelectedAudiences != null,
          title: audiencesTitle,
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
          title: ageGroupsTitle,
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
            text: 'confirm'.toUpperCase(),
            onPressed: onFinished,
          ),
        ),
        SpacingFoundation.verticalSpace24,
      ],
    ).paddingSymmetric(
      horizontal: horizontalMargin,
      vertical: verticalMargin,
    );
  }
}
