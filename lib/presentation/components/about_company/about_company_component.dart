import 'package:flutter/material.dart';
import 'package:shuffle_components_kit/shuffle_components_kit.dart';
import 'package:shuffle_uikit/shuffle_uikit.dart';
import 'package:auto_size_text/auto_size_text.dart';

class AboutCompanyComponent extends StatelessWidget {
  final VoidCallback? onFinished;
  final UiAboutCompanyModel uiModel;
  final List<UiKitMenuItem<int>> niches;
  final List<String> priceSegments;
  final List<String> targetAges;
  final TextEditingController nameController;
  final TextEditingController positionController;
  final GlobalKey<FormState> formKey;
  final String? Function(String?)? nameValidator;
  final String? Function(String?)? positionValidator;
  final ValueChanged<String>? onAgeRangesChanged;
  final ValueChanged<String>? onAudiencesChanged;
  final ValueChanged<UiKitMenuItem<int>?>? onNicheChanged;

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
    required this.niches,
    required this.priceSegments,
    required this.targetAges,
  });

  @override
  Widget build(BuildContext context) {
    final boldTextTheme = context.uiKitTheme?.boldTextTheme;
    final colorScheme = context.uiKitTheme?.colorScheme;

    final config =
        GlobalComponent.of(context)?.globalConfiguration.appConfig.content ?? GlobalConfiguration().appConfig.content;
    final ComponentModel model = ComponentModel.fromJson(config['about_company']);
    final horizontalMargin = (model.positionModel?.horizontalMargin ?? 0).toDouble();
    final verticalMargin = (model.positionModel?.verticalMargin ?? 0).toDouble();

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
             AutoSizeText(
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
              child: UiKitMenu<int>(
                tilesColor: Colors.transparent,
                useCustomTiles: false,
                onSelected: (item) => onNicheChanged?.call(item),
                title: S.current.YourNiche,
                selectedItem: uiModel.selectedMenuItem,
                items: niches,
              ).paddingAll(EdgeInsetsFoundation.all4),
            ),
            SpacingFoundation.verticalSpace16,
            UiKitTitledSection(
              errorText: uiModel.errorSelectedAudiences,
              hasError: uiModel.errorSelectedAudiences != null,
              title: S.current.YourPriceSegment,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Wrap(
                  spacing: SpacingFoundation.horizontalSpacing8,
                  children: priceSegments
                      .map(
                        (e) => UiKitOrdinaryChip(
                          title: e,
                          selected: uiModel.selectedPriceSegments?.contains(e) ?? false,
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
                  children: targetAges
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
