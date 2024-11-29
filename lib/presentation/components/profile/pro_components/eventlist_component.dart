import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shuffle_components_kit/presentation/components/components.dart';
import 'package:shuffle_uikit/shuffle_uikit.dart';
import 'package:collection/collection.dart';

class EventlistComponent extends StatelessWidget {
  final List<UiEventModel> events;
  final Function(UiEventModel) onTap;
  final Function(UiEventModel) onDelete;
  final bool isArchive;

  EventlistComponent(
      {super.key, required this.events, required this.onTap, required this.onDelete, this.isArchive = false});

  final GlobalKey<AnimatedListState> _animatedListKey = GlobalKey<AnimatedListState>();

  @override
  Widget build(BuildContext context) {
    final theme = context.uiKitTheme;

    return BlurredAppBarPage(
      autoImplyLeading: true,
      title: isArchive ? S.of(context).Archive : S.of(context).MyEvents,
      centerTitle: true,
      animatedListKey: _animatedListKey,
      childrenCount: events.isEmpty ? 1 : events.length,
      childrenBuilder: (context, index) {
        if (events.isEmpty) {
          return Center(
            child: Text(S.of(context).NothingFound, style: theme?.boldTextTheme.caption1Bold).paddingSymmetric(
                horizontal: SpacingFoundation.horizontalSpacing16, vertical: SpacingFoundation.verticalSpacing8),
          );
        }

        final event = events[index];
        return Dismissible(
            key: ValueKey(event.id),
            onDismissed: (_) => onDelete(event),
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
                        ? EdgeInsets.symmetric(horizontal: SpacingFoundation.horizontalSpacing16)
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
                        : ListTile(
                            contentPadding: EdgeInsets.zero,
                            leading: BorderedUserCircleAvatar(
                              imageUrl: event.owner?.logo ??
                                  event.media.firstWhereOrNull((element) => element.type == UiKitMediaType.image)?.link,
                              size: 40.w,
                            ),
                            title: Text(
                              event.title ?? '',
                              style: theme?.boldTextTheme.caption1Bold,
                            ),
                            subtitle: event.startDayForEvent != null
                                ? Text(
                                    DateFormat('MMMM d').format(event.startDayForEvent!),
                                    style: theme?.boldTextTheme.caption1Medium.copyWith(
                                      color: theme.colorScheme.darkNeutral500,
                                    ),
                                  )
                                : const SizedBox.shrink(),
                            trailing: context.smallButton(
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
                          ))
                .paddingSymmetric(
                    horizontal: SpacingFoundation.horizontalSpacing8, vertical: SpacingFoundation.verticalSpacing8));
      },
    );
  }
}
