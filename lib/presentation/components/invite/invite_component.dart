import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shuffle_components_kit/presentation/components/invite/ui_invite_person_model.dart';
import 'package:shuffle_uikit/shuffle_uikit.dart';

class InviteComponent extends StatefulWidget {
  const InviteComponent.invitedUser({
    super.key,
    required this.scrollController,
    required this.persons,
    required this.onLoadMore,
    required this.currentInvitedUser,
    required this.onRemoveUserOptionTap,
    required this.onInvitePersonsChanged,
    this.date,
  })  : onDateChanged = null,
        onAddWishTap = null,
        wishController = null;

  const InviteComponent({
    super.key,
    required this.scrollController,
    required this.persons,
    required this.onLoadMore,
    required this.date,
    required this.wishController,
    required this.onAddWishTap,
    required this.onInvitePersonsChanged,
    this.onDateChanged,
  })  : currentInvitedUser = null,
        onRemoveUserOptionTap = null;

  final ScrollController scrollController;
  final List<UiInvitePersonModel> persons;
  final VoidCallback onLoadMore;
  final Function(List<UiInvitePersonModel> persons) onInvitePersonsChanged;

  final DateTime? date;
  final TextEditingController? wishController;
  final UiInvitePersonModel? currentInvitedUser;
  final VoidCallback? onRemoveUserOptionTap;
  final void Function(String value)? onAddWishTap;
  final ValueChanged<DateTime>? onDateChanged;

  @override
  State<InviteComponent> createState() => _InviteComponentState();
}

class _InviteComponentState extends State<InviteComponent> {
  late DateTime? _date;
  late final List<UiInvitePersonModel> _persons;

  @override
  void initState() {
    super.initState();
    widget.scrollController.addListener(_scrollListener);
    _persons = widget.persons;
    _date = widget.date;
  }

  void _scrollListener() {
    if (widget.scrollController.offset >= widget.scrollController.position.maxScrollExtent &&
        !widget.scrollController.position.outOfRange) {
      widget.onLoadMore.call();
    }
  }

  @override
  void didUpdateWidget(covariant InviteComponent oldWidget) {
    super.didUpdateWidget(oldWidget);
    _persons = widget.persons;
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
                  final invitedPersonsLength = _persons.where((e) => e.isSelected).length;
                  if (invitedPersonsLength > 0) {
                    showUiKitAlertDialog(
                      context,
                      AlertDialogData(
                        defaultButtonText: 'okay, cool!',
                        defaultButtonSmall: false,
                        title: Text(
                          'You sent an invitation to $invitedPersonsLength people',
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
                  }
                  widget.onInvitePersonsChanged(_persons);
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
            itemCount: _persons.length,
            itemBuilder: (_, index) {
              final person = _persons[index];

              return UiKitUserTileWithCheckbox(
                title: person.name,
                subtitle: person.description,
                isSelected: person.isSelected,
                date: person.date,
                rating: person.rating,
                avatarLink: person.avatarLink,
                handShake: person.handShakeStatus,
                onTap: (isInvited) => setState(() => person.isSelected = isInvited),
              );
            },
            separatorBuilder: (_, __) => SpacingFoundation.verticalSpace16,
          ),
        ),
        SpacingFoundation.verticalSpace16,
        widget.currentInvitedUser != null
            ? UiKitUserTileWithOption(
                date: widget.currentInvitedUser!.date,
                title: widget.currentInvitedUser!.name,
                subtitle: widget.currentInvitedUser!.description,
                onOptionTap: widget.onRemoveUserOptionTap!,
                options: [
                  UiKitPopUpMenuButtonOption(
                    title: 'Delete from list',
                    value: 'Delete from list',
                    textColor: ColorsFoundation.error,
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
      ],
    );
  }
}
