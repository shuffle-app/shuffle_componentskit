import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shuffle_uikit/shuffle_uikit.dart';

import '../../../shuffle_components_kit.dart';

//ignore_for_file: use_build_context_synchronously

class CreateWebEventComponent extends StatefulWidget {
  final Future Function(UiEventModel) onEventCreated;
  final UiEventModel? eventToEdit;
  final VoidCallback? onEventDeleted;
  final VoidCallback? onShowResult;
  final Future<String?> Function()? getLocation;
  final Future<List<String>> Function(String)? onSuggestCategories;
  final Future<List<String>> Function()? onBaseTagsAdded;
  final Future<List<String>> Function()? onUniqueTagsAdded;
  final void Function(String)? onCategorySelected;
  final void Function(String)? onBaseTagSelected;
  final void Function(String)? onBaseTagUnselected;
  final void Function(String)? onUniqueTagSelected;
  final void Function(String)? onUniqueTagUnselected;
  final VoidCallback? onDescriptionTapped;
  final TextEditingController descriptionController;
  final bool isLoading;

  const CreateWebEventComponent({
    super.key,
    required this.onEventCreated,
    required this.descriptionController,
    this.onUniqueTagsAdded,
    this.onCategorySelected,
    this.onBaseTagsAdded,
    this.onBaseTagSelected,
    this.onBaseTagUnselected,
    this.onUniqueTagSelected,
    this.onUniqueTagUnselected,
    this.eventToEdit,
    this.getLocation,
    this.onEventDeleted,
    this.onSuggestCategories,
    this.onShowResult,
    this.onDescriptionTapped,
    this.isLoading = false,
  });

  @override
  State<CreateWebEventComponent> createState() => _CreateWebEventComponentState();
}

class _CreateWebEventComponentState extends State<CreateWebEventComponent> {
  late final TextEditingController _titleController = TextEditingController();
  late final TextEditingController _addressController = TextEditingController();
  final TextEditingController _personNameController = TextEditingController();
  final TextEditingController _personPhoneController = TextEditingController();
  final TextEditingController _personPositionController = TextEditingController();
  final TextEditingController _personEmailController = TextEditingController();
  late final GlobalKey _formKey = GlobalKey<FormState>();

  late UiEventModel _eventToEdit;

  double descriptionHeightConstraint = 50.h;
  final List<BaseUiKitMedia> _videos = [];
  final List<BaseUiKitMedia> _photos = [];

  @override
  void initState() {
    super.initState();
    _titleController.text = widget.eventToEdit?.title ?? '';
    widget.descriptionController.text = widget.eventToEdit?.description ?? '';
    _eventToEdit = widget.eventToEdit ??
        UiEventModel(
          id: -1,
          media: [],
          tags: [],
          description: '',
        );
    _addressController.text = widget.eventToEdit?.location ?? '';
    _photos.addAll(_eventToEdit.media.where((element) => element.type == UiKitMediaType.image));
    _videos.addAll(_eventToEdit.media.where((element) => element.type == UiKitMediaType.video));
    widget.descriptionController.addListener(_checkDescriptionHeightConstraint);
  }

  _checkDescriptionHeightConstraint() {
    if (widget.descriptionController.text.length * 5.8.w / 0.6.sw > descriptionHeightConstraint / 50.h) {
      setState(() {
        descriptionHeightConstraint += 35.h;
      });
    }
  }

  _onVideoDeleted(int index) {
    setState(() {
      _videos.removeAt(index);
    });
  }

  _onPhotoDeleted(int index) {
    setState(() {
      _photos.removeAt(index);
    });
  }

  _onPhotoAddRequested() async {
    final files = await ImagePicker().pickMultiImage();
    if (files.isNotEmpty) {
      setState(() {
        _photos.addAll(files.map((file) => UiKitMediaPhoto(link: file.path)));
      });
    }
  }

  _onVideoAddRequested() async {
    final videoFile = await ImagePicker().pickVideo(source: ImageSource.gallery);
    if (videoFile != null) {
      setState(() {
        _videos.add(UiKitMediaVideo(link: videoFile.path));
      });
    }
  }

  _onPhotoReorderRequested(int oldIndex, int newIndex) {
    setState(() {
      _photos.insert(newIndex, _photos.removeAt(oldIndex));
    });
  }

  _onVideoReorderRequested(int oldIndex, int newIndex) {
    setState(() {
      _videos.insert(newIndex, _videos.removeAt(oldIndex));
    });
  }

  @override
  void dispose() {
    widget.descriptionController.removeListener(_checkDescriptionHeightConstraint);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final config = GlobalComponent.of(context)?.globalConfiguration.appConfig.content ?? GlobalConfiguration().appConfig.content;
    final ComponentEventModel model = kIsWeb
        ? ComponentEventModel(version: '1', pageBuilderType: PageBuilderType.page)
        : ComponentEventModel.fromJson(config['event_edit']);

    final theme = context.uiKitTheme;

    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(
        horizontal: EdgeInsetsFoundation.horizontal32,
        vertical: EdgeInsetsFoundation.vertical24,
      ),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(S.of(context).CreateEvent, style: theme?.boldTextTheme.title2),
            SpacingFoundation.verticalSpace24,
            Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 2,
                  child: Column(
                    children: [
                      WebFormField(
                        title: S.of(context).EventType,
                        isRequired: true,
                        child: UiKitSuggestionField(
                          showAllOptions: true,
                          options: widget.onSuggestCategories ?? (q) => Future.value([]),
                          borderRadius: BorderRadiusFoundation.all12,
                          fillColor: theme?.colorScheme.surface1,
                          onFieldSubmitted: (value) {
                            _eventToEdit.eventType = value;
                            setState(() {});
                            widget.onCategorySelected?.call(value);
                          },
                        ),
                      ),
                      SpacingFoundation.verticalSpace24,
                      WebFormField(
                        title: S.of(context).BaseProperties,
                        isRequired: true,
                        child: GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onTap: () async {
                            final baseTags = await widget.onBaseTagsAdded?.call();
                            if (baseTags != null) {
                              setState(() {
                                _eventToEdit.baseTags = baseTags
                                    .map((e) => UiKitTag(title: e, icon: GraphicsFoundation.instance.iconFromString('')))
                                    .toList();
                              });
                            }
                          },
                          child: IgnorePointer(
                            child: UiKitTagSelector.darkBackground(
                              borderRadius: BorderRadiusFoundation.all12,
                              onNotFoundTagCallback: (value) {
                                setState(() {
                                  _eventToEdit.baseTags = [
                                    ..._eventToEdit.baseTags,
                                    UiKitTag(title: value, icon: GraphicsFoundation.instance.iconFromString(''))
                                  ];
                                });
                              },
                              tags: _eventToEdit.baseTags.map((e) => e.title).toList(),
                              onRemoveTagCallback: (value) {
                                _eventToEdit.baseTags.removeWhere((e) => e.title == value);
                                setState(() {});
                                widget.onBaseTagUnselected?.call(value);
                              },
                            ),
                          ),
                        ),
                      ),
                      SpacingFoundation.verticalSpace24,
                      WebFormField(
                        title: S.of(context).UniqueProperties,
                        isRequired: true,
                        child: GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onTap: () async {
                            final uniqueTags = await widget.onUniqueTagsAdded?.call();
                            if (uniqueTags != null) {
                              setState(() {
                                _eventToEdit.tags = uniqueTags
                                    .map((e) => UiKitTag(title: e, icon: GraphicsFoundation.instance.iconFromString('')))
                                    .toList();
                              });
                            }
                          },
                          child: IgnorePointer(
                            child: UiKitTagSelector.darkBackground(
                              borderRadius: BorderRadiusFoundation.all12,
                              onNotFoundTagCallback: (value) {
                                setState(() {
                                  _eventToEdit.tags = [
                                    ..._eventToEdit.tags,
                                    UiKitTag(title: value, icon: GraphicsFoundation.instance.iconFromString(''))
                                  ];
                                });
                              },
                              tags: _eventToEdit.tags.map((e) => e.title).toList(),
                              onRemoveTagCallback: (value) {
                                _eventToEdit.tags.removeWhere((e) => e.title == value);
                                setState(() {});
                                widget.onUniqueTagUnselected?.call(value);
                              },
                            ),
                          ),
                        ),
                      ),
                      SpacingFoundation.verticalSpace24,
                      WebPhotoVideoSelector(
                        positionModel: model.positionModel,
                        videos: _videos,
                        photos: _photos,
                        onPhotoAddRequested: _onPhotoAddRequested,
                        onVideoAddRequested: _onVideoAddRequested,
                        onPhotoReorderRequested: _onPhotoReorderRequested,
                        onVideoReorderRequested: _onVideoReorderRequested,
                        onPhotoDeleted: _onPhotoDeleted,
                        onVideoDeleted: _onVideoDeleted,
                      ),
                      SpacingFoundation.verticalSpace24,
                    ],
                  ),
                ),
                SpacingFoundation.horizontalSpace24,
                SizedBox(
                  width: 1,
                  height: 1500.h,
                  child: ColoredBox(color: theme!.colorScheme.darkNeutral900),
                ),
                SpacingFoundation.horizontalSpace24,
                Expanded(
                  flex: 3,
                  child: Column(
                    children: [
                      WebFormField(
                        title: S.of(context).Name,
                        isRequired: true,
                        child: UiKitInputFieldNoIcon(
                          controller: _titleController,
                          hintText: S.of(context).EnterInputType(S.of(context).Name.toLowerCase()),
                          fillColor: theme.colorScheme.surface1,
                          borderRadius: BorderRadiusFoundation.all12,
                        ),
                      ),
                      SpacingFoundation.verticalSpace24,
                      Row(children: [
                        Text(
                          S.of(context).IsRecurrent,
                          style: theme.boldTextTheme.body.copyWith(
                            color: theme.colorScheme.darkNeutral900,
                          ),
                        ),
                        SpacingFoundation.horizontalSpace16,
                        UiKitGradientSwitch(
                          switchedOn: _eventToEdit.isRecurrent,
                          onChanged: (bool? value) {
                            setState(() {
                              _eventToEdit.isRecurrent = value ?? false;
                            });
                          },
                        )
                      ]),
                      SpacingFoundation.verticalSpace24,
                      //TODO restore editing schedules
                      // WebFormField(
                      //   title: S.of(context).OpeningHours,
                      //   isRequired: true,
                      //   child: Row(children: [
                      //     Expanded(
                      //         flex: 3,
                      //         child: UiKitTitledDescriptionWithDivider(
                      //           description: [
                      //             '${normalizedTi(_eventToEdit.time)} - ${normalizedTi(_eventToEdit.timeTo)}',
                      //             if (_eventToEdit.isRecurrent)
                      //               _eventToEdit.weekdays.join(', ')
                      //             else
                      //               '${_eventToEdit.date == null ? '' : DateFormat('MMM dd').format(_eventToEdit.date!)} - ${_eventToEdit.dateTo == null ? '' : DateFormat('MMM dd').format(_eventToEdit.dateTo!)}'
                      //           ],
                      //           direction: Axis.horizontal,
                      //           // onTrailingTap: widget.onTimeEditTap,
                      //           title: '',
                      //         )),
                      //     Transform.scale(
                      //         scale: 0.6,
                      //         child: context.smallOutlinedButton(
                      //           data: BaseUiKitButtonData(
                      //               iconInfo: BaseUiKitButtonIconData(
                      //                 iconData: ShuffleUiKitIcons.clock,
                      //               ),
                      //               onPressed: () async {
                      //                 await showUiKitTimeFromToDialog(context, (from, to) {
                      //                   setState(() {
                      //                     _eventToEdit.time = to;
                      //                     _eventToEdit.timeTo = from;
                      //                   });
                      //                 });
                      //                 if (_eventToEdit.isRecurrent) {
                      //                   final weekdays = await showUiKitWeekdaySelector(context) ?? [];
                      //                   setState(() {
                      //                     _eventToEdit.weekdays = weekdays;
                      //                   });
                      //                 } else {
                      //                   await showUiKitCalendarFromToDialog(context, (from, to) {
                      //                     setState(() {
                      //                       _eventToEdit.date = to;
                      //                       _eventToEdit.dateTo = from;
                      //                     });
                      //                   });
                      //                 }
                      //               }),
                      //         ))
                      //   ]),
                      // ),
                      SpacingFoundation.verticalSpace24,
                      GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: widget.onDescriptionTapped,
                        child: WebFormField(
                          title: S.of(context).Description,
                          child: SizedBox(
                            height: descriptionHeightConstraint,
                            child: IgnorePointer(
                              child: UiKitInputFieldNoIcon(
                                controller: widget.descriptionController,
                                minLines: 4,
                                expands: true,
                                hintText: S.of(context).EnterInputType(S.of(context).Description.toLowerCase()),
                                fillColor: theme.colorScheme.surface1,
                                borderRadius: BorderRadiusFoundation.all12,
                              ),
                            ),
                          ),
                        ),
                      ),
                      SpacingFoundation.verticalSpace24,
                      WebFormField(
                        title: S.of(context).Address,
                        child: InkWell(
                          splashColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          hoverColor: Colors.transparent,
                          onTap: () async {
                            _addressController.text = await widget.getLocation?.call() ?? '';
                            _eventToEdit.location = _addressController.text;
                          },
                          child: IgnorePointer(
                            child: UiKitInputFieldRightIcon(
                              controller: _addressController,
                              hintText: S.of(context).TapToSetAddress,
                              fillColor: theme.colorScheme.surface1,
                              borderRadius: BorderRadiusFoundation.all12,
                              icon: Icon(Icons.location_on, color: theme.colorScheme.inversePrimary, size: 18),
                            ),
                          ),
                        ),
                      ),
                      // SpacingFoundation.verticalSpace24,
                      // WebFormField(
                      //   title: 'Phone',
                      //   child: UiKitInputFieldNoIcon(
                      //     controller: _phoneController,
                      //     hintText: 'Enter phone',
                      //     fillColor: theme.colorScheme.surface1,
                      //     borderRadius: BorderRadiusFoundation.all12,
                      //   ),
                      // ),
                      // SpacingFoundation.verticalSpace24,
                      // WebFormField(
                      //   title: 'Website',
                      //   child: UiKitInputFieldNoIcon(
                      //     controller: _websiteController,
                      //     hintText: 'Enter website',
                      //     fillColor: theme.colorScheme.surface1,
                      //     borderRadius: BorderRadiusFoundation.all12,
                      //   ),
                      // ),
                      SpacingFoundation.verticalSpace24,
                      SizedBox(
                        height: 1,
                        width: double.infinity,
                        child: ColoredBox(color: theme.colorScheme.darkNeutral900),
                      ),
                      SpacingFoundation.verticalSpace24,
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(S.of(context).ContactPerson, style: theme.boldTextTheme.title2),
                          SpacingFoundation.verticalSpace24,
                          WebFormField(
                            title: S.of(context).Name,
                            child: UiKitInputFieldNoIcon(
                              controller: _personNameController,
                              hintText: S.of(context).EnterInputType(S.of(context).Name.toLowerCase()),
                              fillColor: theme.colorScheme.surface1,
                              borderRadius: BorderRadiusFoundation.all12,
                            ),
                          ),
                          SpacingFoundation.verticalSpace24,
                          WebFormField(
                            title: S.of(context).Position,
                            child: UiKitInputFieldNoIcon(
                              controller: _personPositionController,
                              hintText: S.of(context).EnterInputType(S.of(context).Position.toLowerCase()),
                              fillColor: theme.colorScheme.surface1,
                              borderRadius: BorderRadiusFoundation.all12,
                            ),
                          ),
                          SpacingFoundation.verticalSpace24,
                          WebFormField(
                            title: S.of(context).Phone,
                            child: UiKitInputFieldNoIcon(
                              controller: _personPhoneController,
                              hintText: S.of(context).EnterInputType(S.of(context).Phone.toLowerCase()),
                              fillColor: theme.colorScheme.surface1,
                              borderRadius: BorderRadiusFoundation.all12,
                            ),
                          ),
                          SpacingFoundation.verticalSpace24,
                          WebFormField(
                            title: S.of(context).Email,
                            child: UiKitInputFieldNoIcon(
                              controller: _personEmailController,
                              hintText: S.of(context).EnterInputType(S.of(context).Email.toLowerCase()),
                              fillColor: theme.colorScheme.surface1,
                              borderRadius: BorderRadiusFoundation.all12,
                            ),
                          ),
                          SpacingFoundation.verticalSpace24,
                          ConstrainedBox(
                            constraints: BoxConstraints(maxWidth: widget.onShowResult != null ? 0.3.sw : 0.15.sw),
                            child: Row(
                              children: [
                                Expanded(
                                  child: context.gradientButton(
                                    data: BaseUiKitButtonData(
                                      text: S.of(context).Save,
                                      onPressed: () {
                                        _eventToEdit.title = _titleController.text;
                                        // _eventToEdit.website = _websiteController.text;
                                        // _eventToEdit.phone = _phoneController.text;
                                        _eventToEdit.description = widget.descriptionController.text;
                                        _eventToEdit.media = [..._photos, ..._videos];
                                        widget.onEventCreated.call(_eventToEdit);
                                      },
                                      loading: widget.isLoading,
                                    ),
                                  ),
                                ),
                                if (widget.onShowResult != null) ...[
                                  SpacingFoundation.horizontalSpace24,
                                  Expanded(
                                    child: context.outlinedButton(
                                      data: BaseUiKitButtonData(
                                        text: S.of(context).ShowResult.toLowerCase(),
                                        onPressed: widget.onShowResult,
                                      ),
                                      isGradientEnabled: true,
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
