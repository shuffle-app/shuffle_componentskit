import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shuffle_uikit/shuffle_uikit.dart';

import '../../../shuffle_components_kit.dart';

//ignore_for_file: use_build_context_synchronously

class CreateWebPlaceComponent extends StatefulWidget {
  final Future Function(UiPlaceModel) onPlaceCreated;
  final UiPlaceModel? placeToEdit;
  final VoidCallback? onPlaceDeleted;
  final VoidCallback? onShowResult;
  final Future<String?> Function()? getLocation;
  final Future<List<String>> Function(String) placeCategoriesLoader;
  final ValueChanged<String> onCategorySelected;
  final VoidCallback? onBaseTagsAdded;
  final VoidCallback? onUniqueTagsAdded;
  final ValueChanged<String>? onBaseTagRemoved;
  final ValueChanged<String>? onUniqueTagRemoved;

  const CreateWebPlaceComponent({
    super.key,
    required this.onPlaceCreated,
    required this.placeCategoriesLoader,
    required this.onCategorySelected,
    this.placeToEdit,
    this.getLocation,
    this.onPlaceDeleted,
    this.onShowResult,
    this.onBaseTagsAdded,
    this.onUniqueTagsAdded,
    this.onBaseTagRemoved,
    this.onUniqueTagRemoved,
  });

  @override
  State<CreateWebPlaceComponent> createState() => _CreateWebPlaceComponentState();
}

class _CreateWebPlaceComponentState extends State<CreateWebPlaceComponent> {
  late final TextEditingController _titleController = TextEditingController();
  late final TextEditingController _phoneController = TextEditingController();
  late final TextEditingController _websiteController = TextEditingController();
  late final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _personNameController = TextEditingController();
  final TextEditingController _personPhoneController = TextEditingController();
  final TextEditingController _personPositionController = TextEditingController();
  final TextEditingController _personEmailController = TextEditingController();
  final TextEditingController _placeTypeController = TextEditingController();
  late final GlobalKey _formKey = GlobalKey<FormState>();

  late UiPlaceModel _placeToEdit;

  double descriptionHeightConstraint = 50.h;
  final List<BaseUiKitMedia> _videos = [];
  final List<BaseUiKitMedia> _photos = [];

  @override
  void initState() {
    super.initState();
    _titleController.text = widget.placeToEdit?.title ?? '';
    _placeTypeController.text = widget.placeToEdit?.placeType ?? '';
    _descriptionController.text = widget.placeToEdit?.description ?? '';
    _addressController.text = widget.placeToEdit?.location ?? '';
    _placeToEdit = widget.placeToEdit ??
        UiPlaceModel(
          id: -1,
          media: [],
          tags: [],
          description: '',
        );
    _photos.addAll(_placeToEdit.media.where((element) => element.type == UiKitMediaType.image));
    _videos.addAll(_placeToEdit.media.where((element) => element.type == UiKitMediaType.video));
    _descriptionController.addListener(_checkDescriptionHeightConstraint);
    _websiteController.text = widget.placeToEdit?.website ?? '';
    _phoneController.text = widget.placeToEdit?.phone ?? '';
  }

  _checkDescriptionHeightConstraint() {
    if (_descriptionController.text.length * 5.8.w / 0.6.sw > descriptionHeightConstraint / 50.h) {
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

  _onLogoAddRequested() async {
    final file = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (file != null) {
      setState(() {
        _placeToEdit.logo = file.path;
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
    _descriptionController.removeListener(_checkDescriptionHeightConstraint);
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
            Text(
              S.of(context).EditingTypePlace(
                    widget.placeToEdit != null ? S.of(context).Update : S.of(context).Create,
                  ),
              style: theme?.boldTextTheme.title2,
            ),
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
                        title: S.of(context).PlaceType,
                        isRequired: true,
                        child: UiKitSuggestionField(
                          options: widget.placeCategoriesLoader,
                          hintText: 'Enter place category',
                          onFieldSubmitted: (value) {
                            _placeToEdit.placeType = value;
                            setState(() {});
                            widget.onCategorySelected.call(value);
                          },
                        ),

                        //TODO return when we will get a backend categories method
                        // child: UiKitSuggestionField(
                        //   initialValue: widget.placeToEdit?.placeType == null
                        //       ? null
                        //       : TextEditingValue(text: widget.placeToEdit?.placeType ?? ''),
                        //   options: widget.onSuggest ?? (q) => Future.value([]),
                        //   borderRadius: BorderRadiusFoundation.all12,
                        //   fillColor: theme?.colorScheme.surface1,
                        // ),
                      ),
                      SpacingFoundation.verticalSpace24,
                      WebFormField(
                        title: S.of(context).BaseProperties,
                        isRequired: true,
                        child: GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onTap: widget.onBaseTagsAdded,
                          child: IgnorePointer(
                            child: UiKitTagSelector.darkBackground(
                              borderRadius: BorderRadiusFoundation.all12,
                              onNotFoundTagCallback: (value) {
                                setState(() {
                                  _placeToEdit.baseTags = [
                                    ..._placeToEdit.baseTags,
                                    UiKitTag(title: value, icon: GraphicsFoundation.instance.iconFromString(''))
                                  ];
                                });
                              },
                              tags: _placeToEdit.baseTags.map((e) => e.title).toList(),
                              onRemoveTagCallback: (value) {
                                _placeToEdit.baseTags.removeWhere((e) => e.title == value);
                                setState(() {});
                                widget.onBaseTagRemoved?.call(value);
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
                          onTap: widget.onUniqueTagsAdded,
                          child: IgnorePointer(
                            child: UiKitTagSelector.darkBackground(
                              borderRadius: BorderRadiusFoundation.all12,
                              onNotFoundTagCallback: (value) {
                                setState(() {
                                  _placeToEdit.tags = [
                                    ..._placeToEdit.tags,
                                    UiKitTag(title: value, icon: GraphicsFoundation.instance.iconFromString(''))
                                  ];
                                });
                              },
                              tags: _placeToEdit.tags.map((e) => e.title).toList(),
                              onRemoveTagCallback: (value) {
                                _placeToEdit.tags.removeWhere((e) => e.title == value);
                                setState(() {});
                                widget.onUniqueTagRemoved?.call(value);
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
                        logo: _placeToEdit.logo,
                        onPhotoAddRequested: _onPhotoAddRequested,
                        onVideoAddRequested: _onVideoAddRequested,
                        onPhotoReorderRequested: _onPhotoReorderRequested,
                        onVideoReorderRequested: _onVideoReorderRequested,
                        onPhotoDeleted: _onPhotoDeleted,
                        onVideoDeleted: _onVideoDeleted,
                        onLogoAddRequested: _onLogoAddRequested,
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
                      if (_placeToEdit.status != null) ...[
                        WebFormField(
                            title: S.of(context).Published,
                            isRequired: true,
                            child: UiKitGradientSwitch(
                                switchedOn: _placeToEdit.status == 'published',
                                onChanged: (value) {
                                  setState(() {
                                    _placeToEdit.status = value ? 'published' : 'unpublished';
                                  });
                                })),
                        SpacingFoundation.verticalSpace24,
                      ],
                      WebFormField(
                        title: S.of(context).Name,
                        isRequired: true,
                        child: UiKitInputFieldNoIcon(
                          controller: _titleController,
                          hintText: S.of(context).EnterInputType(S.of(context).Time.toLowerCase()),
                          fillColor: theme.colorScheme.surface1,
                          borderRadius: BorderRadiusFoundation.all12,
                        ),
                      ),
                      SpacingFoundation.verticalSpace24,
                      //TODO restore editing schedules
                      // WebFormField(
                      //   title: S.of(context).OpeningHours,
                      //   isRequired: true,
                      //   child: Row(
                      //     children: [
                      //       Expanded(
                      //           flex: 3,
                      //           child: UiKitTitledDescriptionWithDivider(
                      //             description: [
                      //               '${normalizedTi(_placeToEdit.openFrom)} - ${normalizedTi(_placeToEdit.openTo)}',
                      //               _placeToEdit.weekdays.join(', ')
                      //             ],
                      //             direction: Axis.horizontal,
                      //             // onTrailingTap: widget.onTimeEditTap,
                      //             title: '',
                      //           )),
                      //       context.smallOutlinedButton(
                      //         data: BaseUiKitButtonData(
                      //             iconInfo: BaseUiKitButtonIconData(
                      //               iconData: ShuffleUiKitIcons.clock,
                      //             ),
                      //             onPressed: () async {
                      //               await showUiKitTimeFromToDialog(context, (from, to) {
                      //                 setState(() {
                      //                   _placeToEdit.openTo = to;
                      //                   _placeToEdit.openFrom = from;
                      //                 });
                      //               });
                      //
                      //               final weekdays = await showUiKitWeekdaySelector(context) ?? [];
                      //               setState(() {
                      //                 _placeToEdit.weekdays = weekdays;
                      //               });
                      //             }),
                      //       )
                      //     ],
                      //   ),
                      // ),
                      SpacingFoundation.verticalSpace24,
                      WebFormField(
                        title: S.of(context).Description,
                        child: SizedBox(
                          height: descriptionHeightConstraint,
                          child: UiKitInputFieldNoIcon(
                            controller: _descriptionController,
                            minLines: 4,
                            expands: true,
                            hintText: S.of(context).EnterInputType(S.of(context).Description.toLowerCase()),
                            fillColor: theme.colorScheme.surface1,
                            borderRadius: BorderRadiusFoundation.all12,
                          ),
                        ),
                      ),
                      SpacingFoundation.verticalSpace24,
                      WebFormField(
                        title: S.of(context).Address,
                        isRequired: true,
                        child: InkWell(
                          splashColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          hoverColor: Colors.transparent,
                          onTap: () async {
                            _addressController.text = await widget.getLocation?.call() ?? '';
                            _placeToEdit.location = _addressController.text;
                            setState(() {});
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
                      SpacingFoundation.verticalSpace24,
                      WebFormField(
                        title: S.of(context).Phone,
                        child: UiKitInputFieldNoIcon(
                          controller: _phoneController,
                          hintText: S.of(context).EnterInputType(S.of(context).Phone.toLowerCase()),
                          fillColor: theme.colorScheme.surface1,
                          borderRadius: BorderRadiusFoundation.all12,
                        ),
                      ),
                      SpacingFoundation.verticalSpace24,
                      WebFormField(
                        title: S.of(context).Website,
                        child: UiKitInputFieldNoIcon(
                          controller: _websiteController,
                          hintText: S.of(context).EnterInputType(S.of(context).Website.toLowerCase()),
                          fillColor: theme.colorScheme.surface1,
                          borderRadius: BorderRadiusFoundation.all12,
                        ),
                      ),
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
                              hintText: S.of(context).EnterInputType(S.of(context).Time.toLowerCase()),
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
                                        _placeToEdit.title = _titleController.text;
                                        _placeToEdit.website = _websiteController.text;
                                        _placeToEdit.phone = _phoneController.text;
                                        _placeToEdit.description = _descriptionController.text;
                                        _placeToEdit.media = [..._photos, ..._videos];
                                        setState(() {});
                                        widget.onPlaceCreated.call(_placeToEdit);
                                      },
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
