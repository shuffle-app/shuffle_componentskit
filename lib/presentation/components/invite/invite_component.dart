import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shuffle_components_kit/shuffle_components_kit.dart';
import 'package:shuffle_uikit/shuffle_uikit.dart';

class InviteComponent extends StatefulWidget {
  const InviteComponent({
    super.key,
    required this.persons,
    required this.onLoadMore,
    required this.onInvitePersonsChanged,
    this.invitedUser,
    this.onRemoveUserOptionTap,
    this.onAddWishTap,
    this.onInviteTap,
    this.changeDate,
  }) : assert(
          invitedUser != null ? onRemoveUserOptionTap != null : changeDate != null,
          'Once an invited user is not null, onRemoveUserOptionTap must be provided.',
        );

  final List<UiInvitePersonModel> persons;
  final VoidCallback onLoadMore;
  final Function(List<UiInvitePersonModel> persons) onInvitePersonsChanged;

  final UiInvitePersonModel? invitedUser;
  final VoidCallback? onRemoveUserOptionTap;
  final void Function(String value, DateTime date)? onAddWishTap;
  final Future<DateTime?> Function()? changeDate;
  final ValueChanged<List<UiInvitePersonModel>>? onInviteTap;

  @override
  State<InviteComponent> createState() => _InviteComponentState();
}

class _InviteComponentState extends State<InviteComponent> {
  late final TextEditingController _wishController = TextEditingController();
  late final ScrollController scrollController = ScrollController();
  DateTime? _date;

  @override
  void initState() {
    super.initState();
    scrollController.addListener(_scrollListener);
  }

  void _scrollListener() {
    if (scrollController.offset >= scrollController.position.maxScrollExtent && !scrollController.position.outOfRange) {
      widget.onLoadMore.call();
    }
  }

  @override
  void dispose() {
    scrollController.dispose();
    _wishController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.uiKitTheme;
    final boldTextTheme = theme?.boldTextTheme;
    final regularTextTheme = theme?.regularTextTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SpacingFoundation.verticalSpace16,
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(S.of(context).InvitePeople, style: boldTextTheme?.subHeadline),
            context.smallGradientButton(
              data: BaseUiKitButtonData(
                text: S.of(context).Invite,
                onPressed: widget.persons.where((e) => e.isSelected).isEmpty
                    ? null
                    : () {
                        final invitedPersons = widget.persons.where((e) => e.isSelected);
                        widget.onInviteTap?.call(invitedPersons.toList());
                        showUiKitAlertDialog(
                          context,
                          AlertDialogData(
                            defaultButtonText: S.of(context).OkayCool.toLowerCase(),
                            defaultButtonSmall: false,
                            title: Text(
                              S.of(context).YouSentInvitationToNPeople(invitedPersons.length),
                              style: boldTextTheme?.title2.copyWith(color: theme?.colorScheme.primary),
                              textAlign: TextAlign.center,
                            ),
                            content: Text(
                              S.of(context).InvitationsCanBeViewedInPrivateMessages,
                              style: boldTextTheme?.body.copyWith(color: theme?.colorScheme.primary),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ).then((value) => context.pop());
                        widget.onInvitePersonsChanged(invitedPersons.toList());
                      },
              ),
            ),
          ],
        ).paddingSymmetric(horizontal: EdgeInsetsFoundation.horizontal16),
        SpacingFoundation.verticalSpace16,
        UiKitCardWrapper(
          height: 0.5.sh - MediaQuery.viewInsetsOf(context).bottom,
          borderRadius: BorderRadius.zero,
          color: ColorsFoundation.surface1,
          child: ListView.separated(
            controller: scrollController,
            padding: EdgeInsets.symmetric(
              horizontal: EdgeInsetsFoundation.horizontal16,
              vertical: EdgeInsetsFoundation.vertical8,
            ),
            itemCount: widget.persons.length,
            itemBuilder: (_, index) {
              final person = widget.persons[index];

              return UiKitUserTileWithCheckbox(
                name: person.name,
                subtitle: person.description,
                isSelected: person.isSelected,
                date: person.date,
                rating: person.rating ?? 0,
                avatarLink: person.avatarLink,
                handShake: person.handshake,
                onTap: (isInvited) => setState(() => person.isSelected = isInvited),
              );
            },
            separatorBuilder: (_, __) => SpacingFoundation.verticalSpace16,
          ),
        ),
        SpacingFoundation.verticalSpace16,
        widget.invitedUser != null
            ? UiKitUserTileWithOption(
                date: widget.invitedUser!.date,
                name: widget.invitedUser!.name,
                type: widget.invitedUser!.userTileType,
                subtitle: widget.invitedUser!.description,
                onOptionTap: widget.onRemoveUserOptionTap!,
                options: [
                  UiKitPopUpMenuButtonOption(
                    title: S.of(context).DeleteFromList,
                    value: 'Delete from list',
                    textColor: ColorsFoundation.error,
                    onTap: widget.onRemoveUserOptionTap,
                  )
                ],
                avatarLink: widget.invitedUser!.avatarLink,
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    S.of(context).AddYourselfToList,
                    style: boldTextTheme?.subHeadline,
                  ).paddingSymmetric(horizontal: EdgeInsetsFoundation.horizontal16),
                  SpacingFoundation.verticalSpace4,
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      context.smallOutlinedButton(
                        blurred: false,
                        data: BaseUiKitButtonData(
                          onPressed: () => widget.changeDate?.call().then((selectedDate) {
                            if (selectedDate != null) {
                              setState(() => _date = selectedDate);
                            }
                          }),
                          iconInfo: BaseUiKitButtonIconData(
                            iconData: ShuffleUiKitIcons.calendar,
                          ),
                        ),
                      ),
                      SpacingFoundation.horizontalSpace12,
                      _date != null
                          ? Text(
                              DateFormat('MMMM dd').format(_date!),
                              style: regularTextTheme?.body,
                            )
                          : Text(
                              S.of(context).NoDateSelected,
                              style: regularTextTheme?.body,
                            ),
                    ],
                  ).paddingSymmetric(horizontal: EdgeInsetsFoundation.horizontal16),
                  SpacingFoundation.verticalSpace8,
                  Row(
                    children: [
                      ConstrainedBox(
                        constraints: BoxConstraints(
                          maxHeight: 0.15.sh,
                          maxWidth: 0.75.sw,
                        ),
                        child: UiKitInputFieldNoIcon(
                          maxLines: 3,
                          minLines: 1,
                          controller: _wishController,
                          hintText: S.of(context).DescribeYourWishes.toUpperCase(),
                          fillColor: theme?.colorScheme.surface1,
                        ),
                      ),
                      const Spacer(),
                      context.gradientButton(
                        data: BaseUiKitButtonData(
                          onPressed: () {
                            if (_wishController.text.isEmpty) {
                              SnackBarUtils.show(
                                context: context,
                                message: S.of(context).PleaseFillOutYourWishes,
                                type: AppSnackBarType.warning,
                              );
                            } else if (_date == null) {
                              SnackBarUtils.show(
                                context: context,
                                message: S.of(context).PleaseFillOutDate,
                                type: AppSnackBarType.warning,
                              );
                            } else {
                              widget.onAddWishTap?.call(_wishController.text, _date!);
                            }
                          },
                          iconInfo: BaseUiKitButtonIconData(
                            iconData: ShuffleUiKitIcons.plus,
                          ),
                        ),
                      ),
                    ],
                  ).paddingSymmetric(horizontal: EdgeInsetsFoundation.horizontal16),
                ],
              ),
        SpacingFoundation.verticalSpace24,
      ],
    );
  }
}
