import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shuffle_components_kit/presentation/components/invite/ui_invite_person_model.dart';
import 'package:shuffle_uikit/shuffle_uikit.dart';

class InviteComponent extends StatefulWidget {
  const InviteComponent.invitedUser({
    super.key,
    required this.scrollController,
    required this.guests,
    required this.onLoadMore,
    required this.onUserTap,
    required this.currentInvitedUser,
    required this.onRemoveUserOptionTap,
    required this.onInviteGuestChanged,
    this.date,
  })  : onDateChanged = null,
        onAddWishTap = null,
        wishController = null;

  const InviteComponent({
    super.key,
    required this.scrollController,
    required this.guests,
    required this.onLoadMore,
    required this.date,
    required this.wishController,
    required this.onUserTap,
    required this.onAddWishTap,
    required this.onInviteGuestChanged,
    this.currentInvitedUser,
    this.onDateChanged,
    this.onRemoveUserOptionTap,
  });

  final ScrollController scrollController;
  final List<UiInvitePersonModel> guests;
  final VoidCallback onLoadMore;
  final VoidCallback onUserTap;
  final Function(List<UiInvitePersonModel> guests) onInviteGuestChanged;

  final TextEditingController? wishController;
  final DateTime? date;
  final VoidCallback? onRemoveUserOptionTap;
  final void Function(String value)? onAddWishTap;
  final ValueChanged<DateTime>? onDateChanged;
  final UiInvitePersonModel? currentInvitedUser;

  @override
  State<InviteComponent> createState() => _InviteComponentState();
}

class _InviteComponentState extends State<InviteComponent> {
  late DateTime? _date;
  late final List<UiInvitePersonModel> _guests;

  @override
  void initState() {
    super.initState();
    widget.scrollController.addListener(_scrollListener);
    _guests = widget.guests;
    _date = widget.date;
  }

  void _scrollListener() {
    if (widget.scrollController.offset >= widget.scrollController.position.maxScrollExtent &&
        !widget.scrollController.position.outOfRange) {
      print('Its working');
      widget.onLoadMore.call();
    }
  }

  @override
  void didUpdateWidget(covariant InviteComponent oldWidget) {
    super.didUpdateWidget(oldWidget);
    _date = widget.date;
    _guests = widget.guests;
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
                  widget.onInviteGuestChanged(_guests);
                  showUiKitAlertDialog(
                    context,
                    AlertDialogData(
                      defaultButtonText: 'okay, cool!',
                      defaultButtonSmall: false,
                      defaultButtonOutlined: false,
                      title: Text(
                        'You sent an invitation to ${_guests.where((e) => e.isSelected)} people',
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
            controller: widget.scrollController,
            padding: EdgeInsets.symmetric(
              horizontal: EdgeInsetsFoundation.horizontal16,
              vertical: EdgeInsetsFoundation.vertical8,
            ),
            itemCount: _guests.length,
            itemBuilder: (_, index) {
              final guest = _guests[index];

              return UiKitUserTileWithCheckbox(
                title: guest.name,
                subtitle: guest.description,
                isSelected: true,
                date: guest.date,
                rating: guest.rating,
                avatarLink: guest.avatarLink,
                handShake: guest.handShakeStatus,
                onTap: (isInvited) {
                  setState(() => guest.isSelected = isInvited);
                },
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
                onOptionTap: widget.onRemoveUserOptionTap!,
                options: [
                  UiKitPopUpMenuButtonOption(
                    title: 'Delete from list',
                    value: 'Delete from list',
                    onTap: widget.onRemoveUserOptionTap,
                  )
                ],
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
                          onPressed: () => showUiKitCalendarDialog(context, firstDate: DateTime(1960, 1, 1)).then(
                            (date) {
                              if (date != null) {
                                setState(() => _date = date);
                                widget.onDateChanged?.call(_date!);
                              }
                            },
                          ),
                          icon: ImageWidget(
                            link: GraphicsFoundation.instance.svg.calendar.path,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      SpacingFoundation.horizontalSpace12,
                      Text(
                        DateFormat('MMMM dd').format(_date!),
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
                            if (widget.wishController!.text.isEmpty) {
                              SnackBarUtils.show(
                                context: context,
                                message: 'Please fill out your wishes',
                                type: AppSnackBarType.warning,
                              );
                            } else {
                              widget.onAddWishTap?.call(widget.wishController!.text);
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
