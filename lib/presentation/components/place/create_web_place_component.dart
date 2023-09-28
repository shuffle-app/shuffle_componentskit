import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shuffle_uikit/shuffle_uikit.dart';

import '../../../shuffle_components_kit.dart';

part 'web_form_field.dart';

class CreateWebPlaceComponent extends StatefulWidget {
  final Future Function(UiPlaceModel) onPlaceCreated;
  final UiPlaceModel? placeToEdit;
  final VoidCallback? onPlaceDeleted;
  final VoidCallback? onShowResult;
  final VoidCallback? onTimeEditTap;
  final Future<String?> Function()? getLocation;
  final Future<List<String>> Function(String)? onSuggest;

  const CreateWebPlaceComponent({
    super.key,
    required this.onPlaceCreated,
    this.placeToEdit,
    this.getLocation,
    this.onPlaceDeleted,
    this.onTimeEditTap,
    this.onSuggest,
    this.onShowResult,
  });

  @override
  State<CreateWebPlaceComponent> createState() => _CreateWebPlaceComponentState();
}

class _CreateWebPlaceComponentState extends State<CreateWebPlaceComponent> {
  late final TextEditingController _titleController = TextEditingController();
  late final TextEditingController _phoneController = TextEditingController();
  late final TextEditingController _websiteController = TextEditingController();
  late final TextEditingController _locationController = TextEditingController();
  late final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _personNameController = TextEditingController();
  final TextEditingController _personPhoneController = TextEditingController();
  final TextEditingController _personPositionController = TextEditingController();
  final TextEditingController _personEmailController = TextEditingController();
  late final GlobalKey _formKey = GlobalKey<FormState>();

  late UiPlaceModel _placeToEdit;

  double descriptionHeightConstraint = 50.h;
  final List<BaseUiKitMedia> _videos = [];
  final List<BaseUiKitMedia> _photos = [];

  @override
  void initState() {
    super.initState();
    _titleController.text = widget.placeToEdit?.title ?? '';
    _descriptionController.text = widget.placeToEdit?.description ?? '';
    _locationController.text = widget.placeToEdit?.location ?? '';
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
    final config =
        GlobalComponent.of(context)?.globalConfiguration.appConfig.content ?? GlobalConfiguration().appConfig.content;
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
            Text('Create place', style: theme?.boldTextTheme.title2),
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
                        title: 'Place type',
                        isRequired: true,
                        child: UiKitSuggestionField(
                          options: widget.onSuggest,
                          borderRadius: BorderRadiusFoundation.all12,
                          fillColor: theme?.colorScheme.surface1,
                        ),
                      ),
                      SpacingFoundation.verticalSpace24,
                      WebFormField(
                        title: 'Base properties',
                        isRequired: true,
                        child: UiKitTagSelector(
                          borderRadius: BorderRadiusFoundation.all12,
                          onNotFoundTagCallback: (value) {
                            setState(() {
                              _placeToEdit.baseTags = [..._placeToEdit.baseTags, UiKitTag(title: value, iconPath: '')];
                            });
                          },
                          tags: _placeToEdit.baseTags.map((e) => e.title).toList(),
                          onRemoveTagCallback: (value) {
                            _placeToEdit.baseTags.removeWhere((e) => e.title == value);
                          },
                        ),
                      ),
                      SpacingFoundation.verticalSpace24,
                      WebFormField(
                        title: 'Unique properties',
                        isRequired: true,
                        child: UiKitTagSelector(
                          borderRadius: BorderRadiusFoundation.all12,
                          onNotFoundTagCallback: (value) {
                            setState(() {
                              _placeToEdit.tags = [..._placeToEdit.baseTags, UiKitTag(title: value, iconPath: '')];
                            });
                          },
                          tags: _placeToEdit.tags.map((e) => e.title).toList(),
                          onRemoveTagCallback: (value) {
                            _placeToEdit.tags.removeWhere((e) => e.title == value);
                          },
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
                      WebFormField(
                        title: 'Name',
                        isRequired: true,
                        child: UiKitInputFieldNoIcon(
                          controller: _titleController,
                          hintText: 'Enter name',
                          fillColor: theme.colorScheme.surface1,
                          borderRadius: BorderRadiusFoundation.all12,
                        ),
                      ),
                      SpacingFoundation.verticalSpace24,
                      WebFormField(
                        title: 'Opening hours',
                        isRequired: true,
                        child: Row(children: [
                          Expanded(
                              flex: 3,
                              child: UiKitTitledDescriptionWithDivider(
                                description: [
                                  '${normalizedTi(_placeToEdit.openFrom)} - ${normalizedTi(_placeToEdit.openTo)}',
                                  _placeToEdit.weekdays.join(', ') ?? 'no weekdays selected'
                                ],
                                direction: Axis.horizontal,
                                // onTrailingTap: widget.onTimeEditTap,
                                title: '',
                              )),
                          context.smallOutlinedButton(
                            data: BaseUiKitButtonData(
                                icon:
                                    ImageWidget(svgAsset: GraphicsFoundation.instance.svg.pencil, color: Colors.white),
                                onPressed: () async {
                                  await showUiKitTimeFromToDialog(context, (from, to) {
                                    setState(() {
                                      _placeToEdit.openTo = to;
                                      _placeToEdit.openFrom = from;
                                    });
                                  });

                                  final weekdays = await showUiKitWeekdaySelector(context) ?? [];
                                  setState(() {
                                    _placeToEdit.weekdays = weekdays;
                                  });
                                }),
                          )
                        ]),
                      ),
                      SpacingFoundation.verticalSpace24,
                      WebFormField(
                        title: 'Description',
                        child: SizedBox(
                            height: descriptionHeightConstraint,
                            child: UiKitInputFieldNoIcon(
                              controller: _descriptionController,
                              minLines: 4,
                              expands: true,
                              hintText: 'Enter name',
                              fillColor: theme.colorScheme.surface1,
                              borderRadius: BorderRadiusFoundation.all12,
                            )),
                      ),
                      SpacingFoundation.verticalSpace24,
                      WebFormField(
                        title: 'Address',
                        isRequired: true,
                        child: InkWell(
                            onTap: () async {
                              _addressController.text = await widget.getLocation?.call() ?? '';
                              _placeToEdit.location = _addressController.text;
                            },
                            child: IgnorePointer(
                                child: UiKitInputFieldNoIcon(
                              controller: _addressController,
                              hintText: 'Enter address',
                              fillColor: theme.colorScheme.surface1,
                              borderRadius: BorderRadiusFoundation.all12,
                            ))),
                      ),
                      SpacingFoundation.verticalSpace24,
                      WebFormField(
                        title: 'Phone',
                        child: UiKitInputFieldNoIcon(
                          controller: _phoneController,
                          hintText: 'Enter phone',
                          fillColor: theme.colorScheme.surface1,
                          borderRadius: BorderRadiusFoundation.all12,
                        ),
                      ),
                      SpacingFoundation.verticalSpace24,
                      WebFormField(
                        title: 'Website',
                        child: UiKitInputFieldNoIcon(
                          controller: _websiteController,
                          hintText: 'Enter website',
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
                          Text('Contact Person', style: theme.boldTextTheme.title2),
                          SpacingFoundation.verticalSpace24,
                          WebFormField(
                            title: 'Name',
                            child: UiKitInputFieldNoIcon(
                              controller: _personNameController,
                              hintText: 'Enter name',
                              fillColor: theme.colorScheme.surface1,
                              borderRadius: BorderRadiusFoundation.all12,
                            ),
                          ),
                          SpacingFoundation.verticalSpace24,
                          WebFormField(
                            title: 'Position',
                            child: UiKitInputFieldNoIcon(
                              controller: _personPositionController,
                              hintText: 'Enter position',
                              fillColor: theme.colorScheme.surface1,
                              borderRadius: BorderRadiusFoundation.all12,
                            ),
                          ),
                          SpacingFoundation.verticalSpace24,
                          WebFormField(
                            title: 'Phone',
                            child: UiKitInputFieldNoIcon(
                              controller: _personPhoneController,
                              hintText: 'Enter phone',
                              fillColor: theme.colorScheme.surface1,
                              borderRadius: BorderRadiusFoundation.all12,
                            ),
                          ),
                          SpacingFoundation.verticalSpace24,
                          WebFormField(
                            title: 'Email',
                            child: UiKitInputFieldNoIcon(
                              controller: _personEmailController,
                              hintText: 'Enter email',
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
                                      text: 'save',
                                      onPressed: () {
                                        _placeToEdit.title = _titleController.text;
                                        _placeToEdit.website = _websiteController.text;
                                        _placeToEdit.phone = _phoneController.text;
                                        _placeToEdit.description = _descriptionController.text;
                                        _placeToEdit.media = [..._photos, ..._videos];
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
                                        text: 'show result',
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
