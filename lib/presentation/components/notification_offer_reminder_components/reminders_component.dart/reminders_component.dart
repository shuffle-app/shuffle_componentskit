import 'package:flutter/material.dart';
import 'package:shuffle_components_kit/shuffle_components_kit.dart';
import 'package:shuffle_uikit/shuffle_uikit.dart';
import 'package:auto_size_text/auto_size_text.dart';

class RemindersComponent extends StatefulWidget {
  final String? placeOrEventName;
  final List<UniversalNotOfferRemUiModel> bookingReminders;
  final List<UniversalNotOfferRemUiModel> favoriteReminders;
  final ValueChanged<int?>? onEditReminder;
  final Future Function()? onCreateReminder;
  final Future Function(int?)? onRemoveReminder;
  final Future Function(int?)? onPayTap;
  final GlobalKey<SliverAnimatedListState> bookingListKey;
  final GlobalKey<SliverAnimatedListState> favoriteListKey;
  final ValueChanged<int>? onTabChange;
  final int selectedTabIndex;

  const RemindersComponent({
    super.key,
    required this.bookingListKey,
    required this.favoriteListKey,
    this.placeOrEventName,
    required this.bookingReminders,
    required this.favoriteReminders,
    this.onEditReminder,
    this.onRemoveReminder,
    this.onPayTap,
    this.onCreateReminder,
    this.onTabChange,
    this.selectedTabIndex = 0,
  });

  @override
  State<RemindersComponent> createState() => _RemindersComponentState();
}

class _RemindersComponentState extends State<RemindersComponent> with SingleTickerProviderStateMixin {
  final AutoSizeGroup _group = AutoSizeGroup();
  late final TabController _tabController;
  late final List<UiKitCustomTab> _tabs;

  int? editingItemId;

  @override
  void initState() {
    _tabs = [
      UiKitCustomTab(title: S.current.BookingsHeading.toUpperCase(), customValue: 'booking', group: _group),
      UiKitCustomTab(title: S.current.Favorites.toUpperCase(), customValue: 'favorites', group: _group),
    ];
    _tabController = TabController(length: 2, vsync: this, initialIndex: widget.selectedTabIndex);
    _tabController.addListener(() {
      widget.onTabChange?.call(_tabController.index);
    });

    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  _onLongPress(int? itemId) {
    setState(() {
      if (editingItemId == itemId) {
        editingItemId = null;
      } else {
        editingItemId = itemId;
      }
    });
  }

  _onTapOutside() {
    setState(() {
      editingItemId = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.uiKitTheme;

    return Scaffold(
      body: GestureDetector(
        onTap: () {
          _onTapOutside();
        },
        child: BlurredAppBarPage(
          childrenPadding: EdgeInsets.symmetric(horizontal: SpacingFoundation.horizontalSpacing16),
          customTitle: Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Flexible(
                  child: AutoSizeText(
                    S.of(context).Reminders,
                    style: theme?.boldTextTheme.title1,
                    textAlign: TextAlign.center,
                    maxLines: 1,
                  ),
                ),
                // SpacingFoundation.horizontalSpace8,
                // Builder(
                //   builder: (context) => GestureDetector(
                //     onTap: () => showUiKitPopover(
                //       context,
                //       customMinHeight: 30.h,
                //       showButton: false,
                //       title: Text(
                //         S.of(context).LongTapCardEdit,
                //         style: theme?.regularTextTheme.body.copyWith(color: Colors.black87),
                //         textAlign: TextAlign.center,
                //       ),
                //     ),
                //     child: ImageWidget(
                //       iconData: ShuffleUiKitIcons.info,
                //       width: 16.w,
                //       color: theme?.colorScheme.darkNeutral900,
                //     ),
                //   ),
                // ),
              ],
            ),
          ),
          autoImplyLeading: true,
          appBarTrailing: context.outlinedButton(
            padding: EdgeInsets.all(EdgeInsetsFoundation.all6),
            data: BaseUiKitButtonData(
              onPressed: () async {
                await widget.onCreateReminder?.call();
                setState(() {});
              },
              iconInfo: BaseUiKitButtonIconData(
                iconData: ShuffleUiKitIcons.plus,
              ),
            ),
          ),
          children: [
            SpacingFoundation.verticalSpace16,
            UiKitCustomTabBar(
              tabController: _tabController,
              tabs: _tabs,
              onTappedTab: (index) {
                widget.onTabChange?.call(index);
              },
            ),
            SpacingFoundation.verticalSpace16,
            SizedBox(
              height: 0.75.sh,
              child: TabBarView(
                controller: _tabController,
                children: [
                  ///Booking reminder
                  ReminderAnimatedList(
                    reminders: widget.bookingReminders,
                    listKey: widget.bookingListKey,
                    editingItemId: editingItemId,
                    placeOrEventName: widget.placeOrEventName,
                    onTapOutside: () => _onTapOutside(),
                    onPayTap: (id) async {
                      await widget.onPayTap?.call(id);
                      setState(() {});
                    },
                    onDismissed: (id) async {
                      await widget.onRemoveReminder?.call(id);
                      setState(() {});
                    },
                    onEditing: (id) {
                      widget.onEditReminder?.call(id);
                      editingItemId = null;
                    },
                    onLongPress: (id) {
                      // _onLongPress(id);
                    },
                  ),

                  ///Favorite reminder
                  ReminderAnimatedList(
                    reminders: widget.favoriteReminders,
                    listKey: widget.favoriteListKey,
                    editingItemId: editingItemId,
                    placeOrEventName: widget.placeOrEventName,
                    onTapOutside: () => _onTapOutside(),
                    onPayTap: (id) async {
                      await widget.onPayTap?.call(id);
                      setState(() {});
                    },
                    onDismissed: (id) async {
                      await widget.onRemoveReminder?.call(id);
                      setState(() {});
                    },
                    onEditing: (id) {
                      widget.onEditReminder?.call(id);
                      editingItemId = null;
                    },
                    onLongPress: (id) {
                      // _onLongPress(id);
                    },
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class ReminderAnimatedList extends StatelessWidget {
  final List<UniversalNotOfferRemUiModel> reminders;
  final GlobalKey<SliverAnimatedListState> listKey;
  final int? editingItemId;
  final String? placeOrEventName;

  final VoidCallback? onTapOutside;
  final ValueChanged<int>? onDismissed;
  final ValueChanged<int>? onEditing;
  final ValueChanged<int>? onLongPress;
  final ValueChanged<int>? onPayTap;

  const ReminderAnimatedList({
    super.key,
    required this.reminders,
    required this.listKey,
    this.editingItemId,
    this.placeOrEventName,
    this.onTapOutside,
    this.onDismissed,
    this.onEditing,
    this.onLongPress,
    this.onPayTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = context.uiKitTheme;

    return CustomScrollView(
      physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
      slivers: [
        if (reminders.isEmpty)
          UiKitCardWrapper(
            borderRadius: BorderRadiusFoundation.all24r,
            child: Row(
              children: [
                Flexible(
                  flex: 3,
                  child: Text(
                    S.of(context).CreateNewXForYourY(
                          S.of(context).Remainder,
                          placeOrEventName ?? S.of(context).Place.toLowerCase(),
                        ),
                    style: theme?.boldTextTheme.body,
                  ),
                ),
                Flexible(
                  child: ImageWidget(
                    height: 60.h,
                    fit: BoxFit.fitHeight,
                    link: GraphicsFoundation.instance.png.indexFingerHands.path,
                  ),
                )
              ],
            ).paddingAll(EdgeInsetsFoundation.all16),
          ).wrapSliverBox
        else
          SliverAnimatedList(
            key: listKey,
            initialItemCount: reminders.length,
            itemBuilder: (context, index, animation) {
              final reminder = reminders[index];
              final isItemEditing = editingItemId == reminder.id;

              return ScaleTransition(
                alignment: Alignment.topRight,
                scale: animation,
                child: GestureDetector(
                  onTap: onTapOutside,
                  onLongPress: () => onLongPress?.call(reminder.id),
                  child: TapRegion(
                    onTapOutside: (_) {
                      if (isItemEditing) {
                        onTapOutside?.call();
                      }
                    },
                    child: UniversalNotOfferRemItemWidget(
                      model: reminder,
                      onDismissed: () => onDismissed?.call(reminder.id),
                      onEdit: () => onEditing?.call(reminder.id),
                      onLongPress: () => onLongPress?.call(reminder.id),
                      onPayTap: () => onPayTap?.call(reminder.id),
                      isEditingMode: isItemEditing,
                    ).paddingOnly(bottom: SpacingFoundation.verticalSpacing16),
                  ),
                ),
              );
            },
          ),
      ],
    );
  }
}
