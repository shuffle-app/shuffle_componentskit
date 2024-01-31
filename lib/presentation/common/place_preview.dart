import 'dart:developer';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shuffle_components_kit/shuffle_components_kit.dart';
import 'package:shuffle_uikit/shuffle_uikit.dart';

class PlacePreview extends StatelessWidget {
  final Function? onTap;
  final UiPlaceModel place;
  final UiBaseModel model;
  final bool showFavoriteBtn;
  final Stream<bool>? isFavorite;
  final bool showFavoriteHint;
  final Size? cellSize;
  final VoidCallback? onFavoriteChanged;
  final String? status;
  final DateTime? updatedAt;
  final DateTime? shouldVisitAt;
  final ValueNotifier<LottieAnimation?> _animationNotifier = ValueNotifier<LottieAnimation?>(null);

  PlacePreview({
    Key? key,
    required this.onTap,
    required this.place,
    required this.model,
    this.onFavoriteChanged,
    this.cellSize,
    this.status,
    this.shouldVisitAt,
    this.updatedAt,
    this.showFavoriteBtn = false,
    this.showFavoriteHint = false,
    this.isFavorite,
  }) : super(key: key);

  PlacePreview.eventPreview(
      {super.key,
      required this.onTap,
      required UiEventModel event,
      required this.model,
      this.onFavoriteChanged,
      this.cellSize,
      this.updatedAt,
      this.shouldVisitAt,
      this.status,
      this.showFavoriteBtn = false,
      this.showFavoriteHint = false,
      this.isFavorite})
      : place = UiPlaceModel(
            id: event.id,
            title: event.title ?? '',
            description: event.description ?? '',
            media: event.media,
            weekdays: event.weekdays,
            openFrom: event.time,
            openTo: event.timeTo,
            location: event.location,
            placeType: event.eventType,
            tags: event.tags,
            baseTags: event.baseTags);

  @override
  Widget build(BuildContext context) {
    final theme = context.uiKitTheme;
    final size = cellSize ?? MediaQuery.sizeOf(context);
    final horizontalMargin = (model.positionModel?.horizontalMargin ?? 0).toDouble();

    final double calculatedOpacity = (shouldVisitAt?.isAtSameDay ?? true) ? 1 : 0.2;

    return SizedBox(
      width: double.infinity,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          if (shouldVisitAt != null)
            Text(shouldVisitAt!.isAtSameDay ? S.of(context).Today : DateFormat('MMM dd, yyyy').format(shouldVisitAt!),
                    style: theme?.boldTextTheme.title2)
                .paddingOnly(top: SpacingFoundation.verticalSpacing6, bottom: SpacingFoundation.verticalSpacing24),
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              StreamBuilder<bool>(
                  stream: isFavorite ?? Stream.value(false),
                  builder: (context, snapshot) => Align(
                      alignment: Alignment.center,
                      child: GestureDetector(
                        onLongPressStart: showFavoriteBtn
                            ? null
                            : (event) {
                                FeedbackIsolate.instance.addEvent(FeedbackIsolateHaptics(
                                  intensities: [140, 150, 170, 200],
                                  pattern: [20, 15, 10, 5],
                                ));
                              },
                        onLongPress: showFavoriteBtn
                            ? null
                            : () {
                                if (onFavoriteChanged != null) {
                                  onFavoriteChanged!();
                                  if (snapshot.data ?? false) {
                                    _animationNotifier.value = LottieAnimation(
                                      lottiePath: GraphicsFoundation.instance.animations.lottie.starOutline.path,
                                    );
                                  } else {
                                    _animationNotifier.value = LottieAnimation(
                                      lottiePath: GraphicsFoundation.instance.animations.lottie.starFill.path,
                                    );
                                  }
                                  Future.delayed(const Duration(milliseconds: 1500), () {
                                    _animationNotifier.value = null;
                                  });
                                }
                              },
                        child: Stack(
                          clipBehavior: Clip.none,
                          alignment: Alignment.center,
                          children: [
                            Opacity(
                              opacity: calculatedOpacity,
                              child: UiKitPhotoSlider(
                                media: place.media.isEmpty ? [UiKitMediaPhoto(link: '')] : place.media,
                                onTap: () => onTap?.call(place.id),
                                width: size.width - horizontalMargin * 2,
                                height: cellSize?.height ?? 156.h,
                              ),
                            ),
                            if (!showFavoriteBtn)
                              ListenableBuilder(
                                  listenable: _animationNotifier,
                                  builder: (context, child) {
                                    return _animationNotifier.value ??
                                        (showFavoriteHint
                                            ? const DelayAndDisposeAnimationWrapper(
                                                delay: Duration(milliseconds: 500),
                                                durationToDelay: Duration(milliseconds: 1700 * 5),
                                                child: UiKitLongTapHintAnimation(
                                                  duration: Duration(milliseconds: 1700),
                                                ),
                                              )
                                            : const SizedBox.shrink());
                                  }),
                            if (showFavoriteBtn)
                              Positioned(
                                top: -5.h,
                                right: -5.w,
                                child: context.smallButton(
                                  blurred: true,
                                  data: BaseUiKitButtonData(
                                    onPressed: onFavoriteChanged,
                                    iconInfo: BaseUiKitButtonIconData(
                                      iconData: (snapshot.data ?? false)
                                          ? ShuffleUiKitIcons.star
                                          : ShuffleUiKitIcons.staroutline,
                                      size: (snapshot.data ?? false) ? 15.w : null,
                                    ),
                                  ),
                                ),
                              )
                            else if (shouldVisitAt?.isAtSameDay ?? false)
                              Positioned(
                                  top: -10.h,
                                  right: -5.w,
                                  child: context.smallOutlinedButton(
                                      blurred: true,
                                      color: Colors.white,
                                      gradient: GradientFoundation.attentionCard,
                                      data: BaseUiKitButtonData(
                                          onPressed: () {
                                            log('check in');
                                          },
                                          text: S.of(context).CheckIn.toUpperCase()))),
                            if (shouldVisitAt != null && !shouldVisitAt!.isAtSameDay)
                              Positioned(
                                bottom: -15.h,
                                child: UiKitCardWrapper(
                                  color: theme?.colorScheme.surface2.withOpacity(0.35),
                                  child: Center(
                                    child: Text(S.of(context).VisitFirstToOpenNext, style: theme?.boldTextTheme.body),
                                  ).paddingSymmetric(
                                      horizontal: SpacingFoundation.horizontalSpacing20,
                                      vertical: SpacingFoundation.verticalSpacing12),
                                ),
                              ),
                            if (status != null && status!.isNotEmpty)
                              ClipRRect(
                                borderRadius: BorderRadiusFoundation.all24,
                                child: BackdropFilter(
                                  filter: ImageFilter.blur(sigmaX: 25, sigmaY: 25),
                                  child: SizedBox(
                                    width: size.width - horizontalMargin * 2,
                                    height: cellSize?.height ?? 156.h,
                                    child: Center(
                                      child: Text(
                                        '$status\n${DateFormat('dd.MM.yy').format(updatedAt ?? DateTime.now())}',
                                        textAlign: TextAlign.center,
                                        style: theme?.boldTextTheme.body,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ))),
              if (calculatedOpacity == 1) ...[
                SpacingFoundation.verticalSpace8,
                Text(place.title ?? '', style: theme?.boldTextTheme.caption1Bold)
                    .paddingSymmetric(horizontal: horizontalMargin),
                SpacingFoundation.verticalSpace4,
                UiKitTagsWidget(
                  baseTags: place.baseTags,
                  uniqueTags: place.tags,
                ).paddingSymmetric(horizontal: horizontalMargin)
              ]
            ],
          ),
        ],
      ),
    );
  }
}
