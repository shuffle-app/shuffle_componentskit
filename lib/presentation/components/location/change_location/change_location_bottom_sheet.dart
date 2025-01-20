import 'package:flutter/material.dart';
import 'package:shuffle_uikit/shuffle_uikit.dart';

changeLocationBottomSheet({
  required BuildContext context,
  VoidCallback? onMyLocationTap,
  ValueChanged<String>? onSelectCity,
  Map<String, List<String>>? countriesCities,
  ValueNotifier<String?>? selectedCity,
  double? topPadding,
}) {
  return showUiKitGeneralFullScreenDialog(
    context,
    GeneralDialogData(
      topPadding: topPadding ?? (1.sw <= 380 ? 0.6.sw : 0.8.sw),
      useRootNavigator: false,
      isWidgetScrollable: true,
      child: ChangeLocationApp(
        countriesCities: countriesCities,
        onMyLocationTap: onMyLocationTap,
        selectedCity: selectedCity,
        onSelectCity: onSelectCity,
      ),
    ),
  );
}

class ChangeLocationApp extends StatefulWidget {
  final VoidCallback? onMyLocationTap;
  final ValueChanged<String>? onSelectCity;
  final Map<String, List<String>>? countriesCities;
  final ValueNotifier<String?>? selectedCity;

  const ChangeLocationApp({
    super.key,
    this.onMyLocationTap,
    this.countriesCities,
    this.selectedCity,
    this.onSelectCity,
  });

  @override
  State<ChangeLocationApp> createState() => _ChangeLocationAppState();
}

class _ChangeLocationAppState extends State<ChangeLocationApp> {
  String? selectedCity;

  @override
  void initState() {
    super.initState();
    selectedCity = widget.selectedCity?.value ?? S.current.NothingFound;
    if (widget.selectedCity != null) {
      widget.selectedCity!.addListener(_cityChangeListener);
    }
  }

  _cityChangeListener() {
    setState(() {
      selectedCity = widget.selectedCity?.value ?? S.current.NothingFound;
    });
  }

  @override
  void dispose() {
    widget.selectedCity?.removeListener(_cityChangeListener);
    widget.selectedCity?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final boldTextTheme = context.uiKitTheme?.boldTextTheme;
    final colorScheme = context.uiKitTheme?.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SpacingFoundation.verticalSpace16,
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Text(
                S.of(context).SelectLocation,
                style: boldTextTheme?.subHeadline,
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ).paddingSymmetric(horizontal: SpacingFoundation.horizontalSpacing16),
        SpacingFoundation.verticalSpace16,
        SizedBox(
          width: 1.sw,
          child: Stack(
            children: [
              RichText(
                textAlign: TextAlign.left,
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: S.of(context).CurrentLocation,
                      style: boldTextTheme?.labelLarge,
                    ),
                    TextSpan(
                      text: selectedCity ?? S.of(context).NothingFound,
                      style: boldTextTheme?.body.copyWith(color: Colors.white),
                    ),
                  ],
                ),
              ),
              GradientableWidget(
                gradient: GradientFoundation.attentionCard,
                child: RichText(
                  textAlign: TextAlign.left,
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: S.of(context).CurrentLocation,
                        style: boldTextTheme?.labelLarge.copyWith(color: Colors.transparent),
                      ),
                      TextSpan(
                        text: selectedCity ?? S.of(context).NothingFound,
                        style: boldTextTheme?.body.copyWith(color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: InkWell(
                  onTap: widget.onMyLocationTap,
                  child: ImageWidget(
                    link: GraphicsFoundation.instance.svg.location.path,
                    color: colorScheme?.inversePrimary,
                  ),
                ),
              ),
            ],
          ),
        ).paddingSymmetric(horizontal: SpacingFoundation.horizontalSpacing16),
        SpacingFoundation.verticalSpace16,
        if (widget.countriesCities != null && widget.countriesCities!.isNotEmpty)
          Expanded(
              child: ColoredBox(
                  color: colorScheme?.surface1 ?? ColorsFoundation.darkNeutral900,
                  child: ListView.separated(
                      separatorBuilder: (context, _) => Divider(
                            thickness: 2.h,
                            color: colorScheme?.surface2,
                          ).paddingSymmetric(vertical: SpacingFoundation.verticalSpacing16),
                      itemCount: widget.countriesCities!.entries.length,
                      shrinkWrap: true,
                      // physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        final entry = widget.countriesCities!.entries.elementAt(index);
                        final country = entry.key;
                        final cities = entry.value;
                        // String? lastCity;

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              country.toUpperCase(),
                              style: boldTextTheme?.caption1UpperCaseMedium.copyWith(
                                color: ColorsFoundation.mutedText,
                              ),
                            ),
                            SpacingFoundation.verticalSpace16,
                            ...cities.map(
                              (city) {
                                // lastCity = city;
                                if (selectedCity == city) {
                                  return GradientableWidget(
                                    gradient: GradientFoundation.attentionCard,
                                    child: Text(
                                      city,
                                      style: boldTextTheme?.caption1Medium.copyWith(color: Colors.white),
                                    ),
                                  );
                                } else {
                                  return InkWell(
                                    onTap: () {
                                      setState(() {
                                        selectedCity = city;
                                      });
                                      widget.onSelectCity?.call(city);
                                    },
                                    child: Text(
                                      city,
                                      style: boldTextTheme?.caption1Medium,
                                    ),
                                  );
                                }
                              },
                            ),
                          ],
                        ).paddingSymmetric(
                          horizontal: SpacingFoundation.horizontalSpacing16,
                          vertical:
                              country == widget.countriesCities?.keys.first ? SpacingFoundation.verticalSpacing4 : 0,
                        );
                      }))),
      ],
    );
  }
}
