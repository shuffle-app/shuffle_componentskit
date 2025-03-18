import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shuffle_components_kit/presentation/components/components.dart';
import 'package:shuffle_uikit/shuffle_uikit.dart';

class EventListComponent extends StatelessWidget {
  final List<UiEventModel> events;
  final Function(UiEventModel) onTap;
  final Function(UiEventModel) onDelete;
  final Future<String?> Function(String?)? onCityChanged;
  final bool isArchive;
  final GlobalKey<SliverAnimatedListState> animatedListKey;

  const EventListComponent({
    super.key,
    required this.events,
    required this.onTap,
    required this.onDelete,
    required this.animatedListKey,
    this.isArchive = false,
    this.onCityChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = context.uiKitTheme;
    final ValueNotifier<String> selectedCity = ValueNotifier<String>(S.current.SelectCity);
    final Set<int?> citiesIds = events.map((element) => element.cityId).toSet();
    final bool showSelectCity = citiesIds.length > 1;

    return BlurredAppBarPage(
      autoImplyLeading: true,
      title: isArchive ? S.of(context).Archive : S.of(context).MyEvents,
      centerTitle: true,
      animatedListKey: animatedListKey,
      childrenCount: events.isEmpty ? 1 : events.length + (showSelectCity ? 1 : 0),
      physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
      childrenBuilder: (context, index) {
        if (index == 0 && showSelectCity) {
          return SelectedCityRow(
            selectedCity: selectedCity,
            onTap: () async {
              final city = await onCityChanged?.call(selectedCity.value) ?? S.current.SelectCity;
              selectedCity.value = city == selectedCity.value ? S.current.SelectCity : city;
            },
          );
        }

        if (events.isEmpty) {
          return Center(
            child: Text(S.of(context).NothingFound, style: theme?.boldTextTheme.caption1Bold).paddingSymmetric(
                horizontal: SpacingFoundation.horizontalSpacing16, vertical: SpacingFoundation.verticalSpacing8),
          );
        }

        final event = events[index - (showSelectCity ? 1 : 0)];
        return Dismissible(
            key: ValueKey(event.id),
            confirmDismiss: (_) => onDelete(event),
            direction: DismissDirection.endToStart,
            background: ClipRRect(
                clipBehavior: Clip.hardEdge,
                borderRadius: BorderRadiusFoundation.all24,
                child: ColoredBox(
                    color: UiKitColors.red,
                    child: Align(
                        alignment: Alignment.centerRight,
                        child: const ImageWidget(
                          iconData: ShuffleUiKitIcons.trash,
                          color: Colors.white,
                        ).paddingOnly(right: 5.w)))),
            child: UiKitCardWrapper(
              padding: event.reviewStatus == null
                  ? EdgeInsets.symmetric(horizontal: SpacingFoundation.horizontalSpacing12)
                  : null,
              child: event.reviewStatus != null
                  ? DecoratedBox(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadiusFoundation.all24,
                          gradient: LinearGradient(
                              colors: [theme!.colorScheme.inversePrimary.withOpacity(0.3), Colors.transparent])),
                      child: Center(
                        child: Text(
                          event.reviewStatus!,
                          style: theme.boldTextTheme.caption1Bold.copyWith(color: Colors.white),
                        ).paddingSymmetric(vertical: SpacingFoundation.verticalSpacing8),
                      ))
                  : Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        BorderedUserCircleAvatar(
                          imageUrl: event.verticalPreview?.link,
                          size: 40.w,
                        ),
                        SpacingFoundation.horizontalSpace8,
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                event.title ?? '',
                                style: theme?.boldTextTheme.caption1Bold,
                              ),
                              SpacingFoundation.verticalSpace2,
                              event.startDayForEvent != null
                                  ? Text(
                                      DateFormat('MMMM d').format(event.startDayForEvent!),
                                      style: theme?.boldTextTheme.caption1Medium.copyWith(
                                        color: theme.colorScheme.darkNeutral500,
                                      ),
                                    )
                                  : const SizedBox.shrink(),
                            ],
                          ),
                        ),
                        SpacingFoundation.horizontalSpace8,
                        context.smallButton(
                          data: BaseUiKitButtonData(
                            backgroundColor: theme?.colorScheme.surface1,
                            onPressed: () => onTap(event),
                            iconInfo: BaseUiKitButtonIconData(
                              color: theme?.colorScheme.inversePrimary,
                              iconData: CupertinoIcons.right_chevron,
                              size: 20.w,
                            ),
                          ),
                        ),
                      ],
                    ).paddingSymmetric(
                      vertical: SpacingFoundation.verticalSpacing12,
                    ),
            ).paddingSymmetric(
                horizontal: SpacingFoundation.horizontalSpacing16, vertical: SpacingFoundation.verticalSpacing8));
      },
    );
  }
}
