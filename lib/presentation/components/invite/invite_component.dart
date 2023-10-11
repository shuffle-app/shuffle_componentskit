import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shuffle_components_kit/presentation/components/invite/ui_invite_person_model.dart';
import 'package:shuffle_uikit/shuffle_uikit.dart';

class InviteComponent extends StatefulWidget {
  const InviteComponent({
    super.key,
    required this.scrollController,
    required this.persons,
    required this.onLoadMore,
    required this.onInvitePersonsChanged,
    this.invitedUser,
    this.onRemoveUserOptionTap,
    this.onAddWishTap,
    this.changeDate,
  }) : assert(
          invitedUser != null ? onRemoveUserOptionTap != null : changeDate != null,
          'Once an invited user is not null, onRemoveUserOptionTap must be provided.',
        );

  final ScrollController scrollController;
  final List<UiInvitePersonModel> persons;
  final VoidCallback onLoadMore;
  final Function(List<UiInvitePersonModel> persons) onInvitePersonsChanged;

  final UiInvitePersonModel? invitedUser;
  final VoidCallback? onRemoveUserOptionTap;
  final void Function(String value)? onAddWishTap;
  final Future<DateTime?> Function()? changeDate;

  @override
  State<InviteComponent> createState() => _InviteComponentState();
}

class _InviteComponentState extends State<InviteComponent> {
  late final TextEditingController _wishController;
  DateTime? _date;

  @override
  void initState() {
    super.initState();
    widget.scrollController.addListener(_scrollListener);
    _wishController = TextEditingController();
  }

  void _scrollListener() {
    if (widget.scrollController.offset >= widget.scrollController.position.maxScrollExtent &&
        !widget.scrollController.position.outOfRange) {
      widget.onLoadMore.call();
    }
  }

  @override
  void dispose() {
    widget.scrollController.dispose();
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
            Text('Invite people', style: boldTextTheme?.subHeadline),
            context.smallGradientButton(
              data: BaseUiKitButtonData(
                text: 'Invite',
                onPressed: widget.persons.where((e) => e.isSelected).isEmpty
                    ? null
                    : () {
                        final invitedPersons = widget.persons.where((e) => e.isSelected);
                        showUiKitAlertDialog(
                          context,
                          AlertDialogData(
                            defaultButtonText: 'okay, cool!',
                            defaultButtonSmall: false,
                            title: Text(
                              'You sent an invitation to ${invitedPersons.length} people',
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
                        widget.onInvitePersonsChanged(invitedPersons.toList());
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
            itemCount: widget.persons.length,
            itemBuilder: (_, index) {
              final person = widget.persons[index];

              return UiKitUserTileWithCheckbox(
                title: person.name,
                subtitle: person.description,
                isSelected: person.isSelected,
                date: person.date,
                rating: person.rating,
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
                title: widget.invitedUser!.name,
                subtitle: widget.invitedUser!.description,
                onOptionTap: widget.onRemoveUserOptionTap!,
                options: [
                  UiKitPopUpMenuButtonOption(
                    title: 'Delete from list',
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
                          onPressed: () => widget.changeDate?.call().then((selectedDate) {
                            if (selectedDate != null) {
                              setState(() => _date = selectedDate);
                            }
                          }),
                          icon: ImageWidget(
                            link: GraphicsFoundation.instance.svg.calendar.path,
                            color: Colors.white,
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
                              'No date selected',
                              style: regularTextTheme?.body,
                            ),
                    ],
                  ).paddingSymmetric(horizontal: EdgeInsetsFoundation.horizontal16),
                  SpacingFoundation.verticalSpace8,
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
                            if (_wishController.text.isEmpty || _date == null) {
                              SnackBarUtils.show(
                                context: context,
                                message: 'Please fill out your wishes',
                                type: AppSnackBarType.warning,
                              );
                            } else {
                              widget.onAddWishTap?.call(_wishController.text);
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
