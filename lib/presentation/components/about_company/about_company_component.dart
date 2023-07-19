import 'package:flutter/material.dart';
import 'package:shuffle_components_kit/shuffle_components_kit.dart';
import 'package:shuffle_uikit/shuffle_uikit.dart';

class AboutCompanyComponent extends StatelessWidget {
  final VoidCallback? onFinished;
  final ValueChanged<List<IntegerRange>>? onAgeRangesChanged;
  final ValueChanged<List<String>>? onAudiencesChanged;

  const AboutCompanyComponent({
    super.key,
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

    return Scaffold(
      body: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            height: MediaQuery.of(context).viewPadding.top,
          ),
          Text(
            'Now describe your business',
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
            title: 'Your niche',
            child: UiKitMenu<String>(
              title: 'Your niche',
              items: [
                UiKitMenuItem<String>(
                  title: 'Active Tiger Business',
                  value: 'tiger',
                  icon: ImageWidget(
                    svgAsset: GraphicsFoundation.instance.svg.swim,
                  ),
                  type: 'business',
                ),
                UiKitMenuItem<String>(
                  title: 'Active Tiger Business',
                  value: 'tiger',
                  icon: ImageWidget(
                    svgAsset: GraphicsFoundation.instance.svg.athlete,
                  ),
                  type: 'business',
                ),
                UiKitMenuItem<String>(
                  title: 'Active Tiger Business',
                  value: 'tiger',
                  icon: ImageWidget(
                    svgAsset: GraphicsFoundation.instance.svg.food,
                  ),
                  type: 'leisure',
                ),
              ],
            ),
          ),
          SpacingFoundation.verticalSpace16,
          UiKitTitledSection(
            title: 'Select your target audience',
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Wrap(
                spacing: SpacingFoundation.horizontalSpacing8,
                children: [
                  UiKitOrdinaryChip(
                    title: 'Luxury',
                    selected: false,
                  ),
                  UiKitOrdinaryChip(
                    title: 'Luxury',
                    selected: true,
                  ),
                  UiKitOrdinaryChip(
                    title: 'Luxury',
                    selected: false,
                  ),
                ],
              ),
            ),
          ),
          SpacingFoundation.verticalSpace16,
          UiKitTitledSection(
            title: 'Select range of age',
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Wrap(
                spacing: SpacingFoundation.horizontalSpacing8,
                children: [
                  UiKitOrdinaryChip(
                    title: '0-18',
                    selected: false,
                  ),
                  UiKitOrdinaryChip(
                    title: '0-18',
                    selected: false,
                  ),
                  UiKitOrdinaryChip(
                    title: '0-18',
                    selected: false,
                  ),
                ],
              ),
            ),
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
      ),
    );
  }
}
