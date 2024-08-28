import 'package:flutter/material.dart';
import 'package:shuffle_components_kit/presentation/components/booking_component/booking_ui_model/subs_or_upsale_ui_model.dart';
import 'package:shuffle_uikit/shuffle_uikit.dart';

class SubsInContentCard extends StatelessWidget {
  final List<SubsUiModel> subs;

  const SubsInContentCard({
    super.key,
    required this.subs,
  });

  @override
  Widget build(BuildContext context) {
    final theme = context.uiKitTheme;

    return DecoratedBox(
      decoration: BoxDecoration(color: theme?.colorScheme.surface1),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            S.of(context).Subs,
            style: theme?.boldTextTheme.caption2Medium,
          ).paddingOnly(left: SpacingFoundation.horizontalSpacing16),
          SpacingFoundation.verticalSpace4,
          SizedBox(
            height: 1.sw <= 380 ? 140.h : 105.h,
            child: ListView.separated(
              itemCount: subs.length,
              scrollDirection: Axis.horizontal,
              shrinkWrap: true,
              separatorBuilder: (context, index) => SpacingFoundation.horizontalSpace8,
              itemBuilder: (context, index) {
                final sub = subs[index];

                return SubsOrUpsaleItem(
                  limit: sub.bookingLimit,
                  titleOrPrice: sub.title,
                  photoLink: GraphicsFoundation.instance.png.leto1.path,
                  actualLimit: sub.actualbookingLimit,
                  description: sub.description,
                  onEdit: () {
                    showGeneralDialog(
                      barrierColor: const Color(0xff2A2A2A),
                      transitionBuilder: (context, a1, a2, widget) {
                        return Transform.scale(
                          scale: a1.value,
                          child: Opacity(
                            opacity: a1.value,
                            child: widget,
                          ),
                        );
                      },
                      transitionDuration: const Duration(milliseconds: 200),
                      barrierDismissible: true,
                      barrierLabel: '',
                      context: context,
                      pageBuilder: (context, animation1, animation2) {
                        return Dialog(
                          insetPadding: EdgeInsets.all(EdgeInsetsFoundation.all16),
                          backgroundColor: Colors.transparent,
                          clipBehavior: Clip.antiAlias,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadiusFoundation.all24,
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              GestureDetector(
                                onTap: context.pop,
                                child: ImageWidget(
                                  iconData: ShuffleUiKitIcons.cross,
                                  color: theme?.colorScheme.darkNeutral900,
                                  height: 19.h,
                                  fit: BoxFit.fitHeight,
                                ),
                              ),
                              SpacingFoundation.verticalSpace16,
                              UiKitCardWrapper(
                                padding: EdgeInsets.all(EdgeInsetsFoundation.all24),
                                color: theme?.colorScheme.surface,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      sub.title ?? '',
                                      style: theme?.boldTextTheme.title2,
                                    ),
                                    1.sw <= 380 ? SpacingFoundation.verticalSpace12 : SpacingFoundation.verticalSpace16,
                                    Center(
                                      child: GradientableWidget(
                                        blendMode: BlendMode.dstIn,
                                        gradient: LinearGradient(
                                          colors: [theme?.colorScheme.primary ?? Colors.white, Colors.transparent],
                                          stops: const [0.80, 1.0],
                                          begin: Alignment.topCenter,
                                          end: Alignment.bottomCenter,
                                        ),
                                        child: UiKitCardWrapper(
                                          borderRadius: BorderRadiusFoundation.all12,
                                          child: ImageWidget(
                                            height: 0.4.sh,
                                            link: GraphicsFoundation.instance.png.leto1.path,
                                            fit: BoxFit.fill,
                                          ),
                                        ),
                                      ),
                                    ),
                                    SpacingFoundation.verticalSpace24,
                                    Text(
                                      sub.description ?? '',
                                      style: theme?.regularTextTheme.caption2,
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        );
                      },
                    );
                  },
                ).paddingOnly(
                  left: sub == subs.first ? SpacingFoundation.horizontalSpacing16 : 0,
                  right: sub == subs.last ? SpacingFoundation.horizontalSpacing16 : 0,
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
