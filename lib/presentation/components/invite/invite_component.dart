import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shuffle_components_kit/shuffle_components_kit.dart';
import 'package:shuffle_uikit/shuffle_uikit.dart';

class InviteComponent extends StatefulWidget {
  const InviteComponent({
    super.key,
    required this.persons,
    required this.onLoadMore,
    this.alreadyInvitedUserIds,
    this.selfInvitationModel,
    this.initialDate,
    this.onRemoveUserOptionTap,
    this.onDisabledUserTileTap,
    this.onAddWishTap,
    this.onInviteTap,
    this.changeDate,
    this.isLoading = false,
  }) : assert(
          selfInvitationModel != null ? onRemoveUserOptionTap != null : changeDate != null,
          'Once an invited user is not null, onRemoveUserOptionTap must be provided.',
        );

  final List<UiInvitePersonModel> persons;
  final List<int>? alreadyInvitedUserIds;
  final VoidCallback onLoadMore;

  final UiInvitePersonModel? selfInvitationModel;
  final VoidCallback? onRemoveUserOptionTap;
  final VoidCallback? onDisabledUserTileTap;
  final void Function(String value, DateTime date)? onAddWishTap;
  final Future<DateTime?> Function()? changeDate;
  final DateTime? initialDate;
  final bool isLoading;
  final Future Function(List<UiInvitePersonModel>)? onInviteTap;

  @override
  State<InviteComponent> createState() => _InviteComponentState();
}

class _InviteComponentState extends State<InviteComponent> {
  late final TextEditingController _wishController = TextEditingController();
  late final ScrollController scrollController = ScrollController();
  DateTime? _date;
  bool loading = false;
  bool isEditing = false;

  @override
  void initState() {
    if (widget.initialDate != null) {
      _date = widget.initialDate;
    }
    super.initState();
    scrollController.addListener(_scrollListener);
  }

  @override
  void didUpdateWidget(covariant InviteComponent oldWidget) {
    if (widget.initialDate != null) {
      _date = widget.initialDate;
    }
    super.didUpdateWidget(oldWidget);
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
    final colorScheme = theme?.colorScheme;

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
                loading: loading,
                text: S.of(context).Invite,
                onPressed: widget.persons.where((e) => e.isSelected).isEmpty
                    ? null
                    : () {
                        setState(() => loading = true);
                        final invitedPersons = widget.persons.where((e) => e.isSelected);
                        widget.onInviteTap
                            ?.call(invitedPersons.toList())
                            .whenComplete(() => setState(() => loading = false));
                      },
              ),
            ),
          ],
        ).paddingSymmetric(horizontal: EdgeInsetsFoundation.horizontal16),
        SpacingFoundation.verticalSpace16,
        UiKitCardWrapper(
          height: 0.5.sh - MediaQuery.viewInsetsOf(context).bottom,
          borderRadius: BorderRadius.zero,
          color: colorScheme?.surface1,
          child: widget.persons.isEmpty
              ? Center(
                  child: Text(
                  S.of(context).NoPeopleAvailableToInvite,
                  style: theme?.boldTextTheme.subHeadline,
                ))
              : ListView.separated(
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
                      disableSelection: widget.alreadyInvitedUserIds?.contains(person.id) ?? false,
                      subtitle: person.description,
                      isSelected: person.isSelected,
                      date: person.date,
                      rating: person.rating ?? 0,
                      avatarLink: person.avatarLink,
                      handShake: person.handshake,
                      onDisabledTap: widget.onDisabledUserTileTap,
                      onTap: (isInvited) => setState(() => person.isSelected = isInvited),
                    );
                  },
                  separatorBuilder: (_, __) => SpacingFoundation.verticalSpace16,
                ),
        ),
        SpacingFoundation.verticalSpace16,
        widget.selfInvitationModel != null && !isEditing
            ? UiKitUserTileWithOption(
                date: widget.selfInvitationModel!.date,
                name: widget.selfInvitationModel!.name,
                type: widget.selfInvitationModel!.userTileType,
                subtitle: widget.selfInvitationModel!.description,
                onOptionTap: widget.onRemoveUserOptionTap!,
                options: [
                  UiKitPopUpMenuButtonOption(
                    title: S.of(context).Edit,
                    value: 'Edit',
                    textColor: colorScheme?.surface,
                    onTap: () {
                      setState(() {
                        isEditing = true;
                        _wishController.text = widget.selfInvitationModel!.description;
                      });
                    },
                  ),
                  UiKitPopUpMenuButtonOption(
                    title: S.of(context).DeleteFromList,
                    value: 'Delete from list',
                    textColor: ColorsFoundation.error,
                    onTap: widget.onRemoveUserOptionTap,
                  ),
                ],
                avatarLink: widget.selfInvitationModel!.avatarLink,
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
                          onPressed: widget.initialDate == null
                              ? () => widget.changeDate?.call().then((selectedDate) {
                                    if (selectedDate != null) {
                                      setState(() => _date = selectedDate);
                                    }
                                  })
                              : null,
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
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ConstrainedBox(
                        constraints: BoxConstraints(
                          maxHeight: 0.15.sh,
                          maxWidth: 0.75.sw,
                        ),
                        child: UiKitInputFieldNoIcon(
                          minLines: 1,
                          maxSymbols: 100,
                          controller: _wishController,
                          hintText: S.of(context).DescribeYourWishes.toUpperCase(),
                          fillColor: theme?.colorScheme.surface1,
                        ),
                      ),
                      const Spacer(),
                      context.gradientButton(
                        data: BaseUiKitButtonData(
                          loading: widget.isLoading,
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
                              setState(() {
                                isEditing = false;
                              });
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
        SpacingFoundation.verticalSpace16,
      ],
    );
  }
}
