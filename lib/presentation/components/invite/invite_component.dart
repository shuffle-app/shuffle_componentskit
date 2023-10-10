import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shuffle_components_kit/presentation/components/invite/ui_invite_person_model.dart';
import 'package:shuffle_uikit/shuffle_uikit.dart';

class InviteComponent extends StatefulWidget {
  const InviteComponent({
    super.key,
    required this.scrollController,
    required this.guests,
    required this.onPagination,
    required this.onInviteTap,
    required this.date,
    required this.wishController,
    this.currentInvitedUser,
    this.onDateChanged,
    this.onRemoveUserOption,
    required this.onAddWishTap,
  }) : assert(
          currentInvitedUser != null && onRemoveUserOption == null,
          'onRemoveUserOption must be provided.',
        );

  final ScrollController scrollController;
  final TextEditingController wishController;
  final DateTime date;
  final UiInvitePersonModel? currentInvitedUser;
  final VoidCallback onInviteTap;
  final VoidCallback? onRemoveUserOption;
  final void Function(String value) onAddWishTap;
  final List<UiInvitePersonModel> guests;
  final List<UiInvitePersonModel> Function(int lastElementIndex) onPagination;
  final ValueChanged<DateTime>? onDateChanged;

  @override
  State<InviteComponent> createState() => _InviteComponentState();
}

class _InviteComponentState extends State<InviteComponent> {
  late DateTime _date;
  int _currentTile = 0;

  @override
  void initState() {
    super.initState();
    widget.onPagination.call(_currentTile);
    widget.scrollController.addListener(_scrollListener);
    _date = widget.date;
  }

  void _scrollListener() {
    if (widget.scrollController.offset >= widget.scrollController.position.maxScrollExtent &&
        !widget.scrollController.position.outOfRange) {
      setState(() => _currentTile += 5);
      widget.onPagination.call(_currentTile);
    }
  }

  @override
  void didUpdateWidget(covariant InviteComponent oldWidget) {
    super.didUpdateWidget(oldWidget);
    _date = widget.date;
  }

  @override
  void dispose() {
    widget.scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.uiKitTheme;
    final boldTextTheme = context.uiKitTheme?.boldTextTheme;
    final regularTextTheme = context.uiKitTheme?.regularTextTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SpacingFoundation.verticalSpace16,
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Invite people', style: boldTextTheme?.subHeadline),
            context.smallGradientButton(
              data: BaseUiKitButtonData(
                text: 'Invite',
                onPressed: () {
                  widget.onInviteTap.call();
                  showUiKitAlertDialog(
                    context,
                    AlertDialogData(
                      defaultButtonText: 'okay, cool!',
                      defaultButtonSmall: false,
                      defaultButtonOutlined: false,
                      title: Text(
                        'You sent an invitation to 2 people',
                        style: boldTextTheme?.title2.copyWith(color: theme?.colorScheme.primary),
                        textAlign: TextAlign.center,
                      ),
                      content: Text(
                        'Invitations can be viewed in private messages',
                        style: boldTextTheme?.body.copyWith(color: theme?.colorScheme.primary),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ).paddingSymmetric(horizontal: EdgeInsetsFoundation.horizontal16),
        SpacingFoundation.verticalSpace16,
        UiKitCardWrapper(
          height: 0.55.sh,
          borderRadius: BorderRadius.zero,
          color: ColorsFoundation.surface1,
          child: ListView.separated(
            padding: EdgeInsets.symmetric(
              horizontal: EdgeInsetsFoundation.horizontal16,
              vertical: EdgeInsetsFoundation.vertical8,
            ),
            itemCount: widget.guests.length,
            itemBuilder: (_, index) {
              final guest = widget.guests[index];

              return UiKitUserTileWithCheckbox(
                title: guest.name,
                subtitle: guest.description,
                isSelected: true,
                date: guest.date,
                rating: guest.rating,
                avatarLink: guest.avatarLink,
                handShake: guest.handShakeStatus,
                onTap: () {},
              );
            },
            separatorBuilder: (_, __) => SpacingFoundation.verticalSpace16,
          ),
        ),
        SpacingFoundation.verticalSpace16,
        widget.currentInvitedUser != null
            ? UiKitUserTileWithOption(
                title: widget.currentInvitedUser!.name,
                subtitle: widget.currentInvitedUser!.description,
                onOptionTap: widget.onRemoveUserOption!,
                options: [],
                avatarLink: widget.currentInvitedUser!.avatarLink,
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Add yourself to list',
                    style: boldTextTheme?.subHeadline,
                  ).paddingSymmetric(horizontal: EdgeInsetsFoundation.horizontal16),
                  SpacingFoundation.verticalSpace4,
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      context.smallOutlinedButton(
                        blurred: false,
                        data: BaseUiKitButtonData(
                          onPressed: () =>
                              showUiKitCalendarDialog(context, firstDate: DateTime(1960, 1, 1)).then((date) {
                            if (date != null) {
                              setState(() => _date = date);
                              widget.onDateChanged?.call(_date);
                            }
                          }),
                          icon: ImageWidget(
                            link: GraphicsFoundation.instance.svg.calendar.path,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      SpacingFoundation.horizontalSpace12,
                      Text(
                        DateFormat('MMMM dd').format(_date),
                        style: regularTextTheme?.body,
                      ),
                    ],
                  ).paddingSymmetric(horizontal: EdgeInsetsFoundation.horizontal16),
                  SpacingFoundation.verticalSpace16,
                  Row(
                    children: [
                      Expanded(
                        child: UiKitInputFieldNoIcon(
                          controller: TextEditingController(),
                          hintText: 'describe your wishes'.toUpperCase(),
                          fillColor: theme?.colorScheme.surface1,
                        ),
                      ),
                      SpacingFoundation.horizontalSpace16,
                      context.gradientButton(
                        data: BaseUiKitButtonData(
                          onPressed: () {
                            if (widget.wishController.text.isEmpty) {
                              SnackBarUtils.show(
                                context: context,
                                message: 'Please fill out your wishes',
                                type: AppSnackBarType.warning,
                              );
                            } else {
                              widget.onAddWishTap.call(widget.wishController.text);
                            }
                          },
                          icon: ImageWidget(
                            svgAsset: GraphicsFoundation.instance.svg.plus,
                          ),
                        ),
                      ),
                    ],
                  ).paddingSymmetric(horizontal: EdgeInsetsFoundation.horizontal16),
                ],
              ),
        SpacingFoundation.verticalSpace16,
      ],
    );
  }
}
