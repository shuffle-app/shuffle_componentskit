import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shuffle_uikit/shuffle_uikit.dart';
import 'package:auto_size_text/auto_size_text.dart';
import '../../../shuffle_components_kit.dart';
import '../../common/photolist_editing_component.dart';
import '../../common/price_selector_component.dart';
import '../../common/tags_selection_component.dart';

class CreatePlaceComponent extends StatefulWidget {
  final UiPlaceModel? placeToEdit;
  final VoidCallback? onPlaceDeleted;
  final Future Function(UiPlaceModel) onPlaceCreated;
  final Future<String?> Function()? getLocation;
  final Future<String?> Function()? onCategoryChanged;
  final Future<String?> Function()? onNicheChanged;
  final Future<List<String>> Function(String, String) propertiesOptions;
  final List<UiScheduleModel> availableTimeTemplates;
  final ValueChanged<UiScheduleModel>? onTimeTemplateCreated;

  const CreatePlaceComponent({
    super.key,
    this.placeToEdit,
    this.getLocation,
    this.onPlaceDeleted,
    required this.onPlaceCreated,
    required this.propertiesOptions,
    this.onCategoryChanged,
    this.onNicheChanged,
    this.availableTimeTemplates = const [],
    this.onTimeTemplateCreated,
  });

  @override
  State<CreatePlaceComponent> createState() => _CreatePlaceComponentState();
}

class _CreatePlaceComponentState extends State<CreatePlaceComponent> {
  late final TextEditingController _titleController = TextEditingController();
  late final TextEditingController _phoneController = TextEditingController();
  late final TextEditingController _websiteController = TextEditingController();
  late final TextEditingController _locationController = TextEditingController();
  late final TextEditingController _descriptionController = TextEditingController();
  late final TextEditingController _priceController = TextEditingController();
  late final TextEditingController _typeController = TextEditingController();
  late final TextEditingController _nicheController = TextEditingController();

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
    _websiteController.text = widget.placeToEdit?.website ?? '';
    _phoneController.text = widget.placeToEdit?.phone ?? '';
    _priceController.text = widget.placeToEdit?.price ?? '';
    _typeController.text = widget.placeToEdit?.placeType ?? '';
    _nicheController.text = widget.placeToEdit?.niche ?? '';
  }

  _checkDescriptionHeightConstraint() {
    if (_descriptionController.text.length * 5.8.w / (kIsWeb ? 390 : 0.9.sw) > descriptionHeightConstraint / 50.h) {
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
    final config =
        GlobalComponent.of(context)?.globalConfiguration.appConfig.content ?? GlobalConfiguration().appConfig.content;
    final ComponentEventModel model = kIsWeb
        ? ComponentEventModel(version: '1', pageBuilderType: PageBuilderType.page)
        : ComponentEventModel.fromJson(config['event_edit']);
    final editedPhotos = await context.push(PhotoListEditingComponent(
      photos: _photos,
      positionModel: model.positionModel,
    ));
    setState(() {
      _photos.clear();
      _photos.addAll(editedPhotos);
    });
    // final files = await ImagePicker().pickMultiImage();
    // if (files.isNotEmpty) {
    //   setState(() {
    //     _photos.addAll(files.map((file) => UiKitMediaPhoto(link: file.path)));
    //   });
    // }
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
  void didUpdateWidget(covariant CreatePlaceComponent oldWidget) {
    if (oldWidget.placeToEdit != widget.placeToEdit) {
      _placeToEdit = widget.placeToEdit ??
          UiPlaceModel(
            id: -1,
            media: [],
            tags: [],
            description: '',
          );
      _photos.clear();
      _videos.clear();
      _photos.addAll(_placeToEdit.media.where((element) => element.type == UiKitMediaType.image));
      _videos.addAll(_placeToEdit.media.where((element) => element.type == UiKitMediaType.video));
      _descriptionController.text = widget.placeToEdit?.description ?? '';
      _websiteController.text = widget.placeToEdit?.website ?? '';
      _phoneController.text = widget.placeToEdit?.phone ?? '';
      _priceController.text = widget.placeToEdit?.price ?? '';
      _typeController.text = widget.placeToEdit?.placeType ?? '';
      _titleController.text = widget.placeToEdit?.title ?? '';
      _locationController.text = widget.placeToEdit?.location ?? '';
      _nicheController.text = widget.placeToEdit?.niche ?? '';
    }
    super.didUpdateWidget(oldWidget);
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
    final horizontalPadding = model.positionModel?.horizontalMargin?.toDouble() ?? 0;

    final theme = context.uiKitTheme;
    final AutoSizeGroup contentSelectionGroup = AutoSizeGroup();

    return BlurredAppBarPage(
      title: S.of(context).Place,
      centerTitle: true,
      autoImplyLeading: true,
      appBarTrailing: (widget.placeToEdit?.id ?? -1) > 0
          ? IconButton(
              icon: ImageWidget(
                  iconData: ShuffleUiKitIcons.trash,
                  color: theme?.colorScheme.inversePrimary,
                  height: 20.h,
                  fit: BoxFit.fitHeight),
              onPressed: widget.onPlaceDeleted,
            )
          : null,
      children: [
        SpacingFoundation.verticalSpace16,
        InkWell(
          onTap: () async {
            _locationController.text = await widget.getLocation?.call() ?? '';
            _placeToEdit.location = _locationController.text;
          },
          child: IgnorePointer(
            child: UiKitInputFieldNoFill(
              label: S.of(context).Address,
              controller: _locationController,
              icon: ImageWidget(
                iconData: ShuffleUiKitIcons.landmark,
                color: theme?.colorScheme.inversePrimary,
                height: 16.h,
                width: 16.h,
              ),
            ).paddingSymmetric(horizontal: horizontalPadding),
          ),
        ),
        SpacingFoundation.verticalSpace12,
        Row(
          children: [
            UiKitInputFieldNoFill(
              label: S.of(context).BuildingNumber,
              controller: _placeToEdit.houseNumberController,
            ).paddingSymmetric(horizontal: horizontalPadding),
            UiKitInputFieldNoFill(
              label: S.of(context).OfficeAppartmentNumber,
              controller: _placeToEdit.apartmentNumberController,
            ).paddingSymmetric(horizontal: horizontalPadding),
          ],
        ),
        SpacingFoundation.verticalSpace24,
        UiKitInputFieldNoFill(
          label: S.of(context).Title,
          controller: _titleController,
        ).paddingSymmetric(horizontal: horizontalPadding),
        SpacingFoundation.verticalSpace24,
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              S.of(context).Logo,
              style: theme?.regularTextTheme.labelSmall,
            ).paddingOnly(right: horizontalPadding),
            if (_placeToEdit.logo != null) CircularAvatar(height: kIsWeb ? 40 : 40.h, avatarUrl: _placeToEdit.logo!),
            const Spacer(),
            context.outlinedButton(
              data: BaseUiKitButtonData(
                onPressed: _onLogoAddRequested,
                iconInfo: BaseUiKitButtonIconData(
                  iconData: ShuffleUiKitIcons.cameraplus,
                  size: 16.h,
                ),
              ),
            )
          ],
        ).paddingSymmetric(horizontal: horizontalPadding),
        SpacingFoundation.verticalSpace24,
        PhotoVideoSelector(
          hideVideosSelection: true,
          positionModel: model.positionModel,
          // videos: _videos,
          photos: _photos,
          // onVideoAddRequested: _onVideoAddRequested,
          // onVideoDeleted: _onVideoDeleted,
          onPhotoAddRequested: _onPhotoAddRequested,
          onPhotoDeleted: _onPhotoDeleted,
          onPhotoReorderRequested: _onPhotoReorderRequested,
          // onVideoReorderRequested: _onVideoReorderRequested,
        ),
        SpacingFoundation.verticalSpace24,
        ConstrainedBox(
          constraints: BoxConstraints(maxHeight: descriptionHeightConstraint),
          child: UiKitInputFieldNoFill(
            label: S.of(context).Description,
            controller: _descriptionController,
            expands: true,
          ),
        ).paddingSymmetric(horizontal: horizontalPadding),
        SpacingFoundation.verticalSpace24,
        Row(
          children: [
            Text(S.of(context).OpenFrom, style: theme?.regularTextTheme.labelSmall),
            Expanded(
                child: Text(
              _placeToEdit.scheduleString == null
                  ? S.of(context).SelectType(S.of(context).Time.toLowerCase()).toLowerCase()
                  : _placeToEdit.scheduleString!,
              style: theme?.boldTextTheme.body,
              textAlign: TextAlign.center,
            )),
            context.outlinedButton(
              data: BaseUiKitButtonData(
                onPressed: () {
                  context.push(CreateScheduleWidget(
                    availableTemplates: widget.availableTimeTemplates,
                    onTemplateCreated: widget.onTimeTemplateCreated,
                    availableTypes: const [UiScheduleTimeModel.scheduleType],
                    onScheduleCreated: (model) {
                      if (model is UiScheduleTimeModel) {
                        setState(() {
                          _placeToEdit.schedule = model;
                          _placeToEdit.scheduleString = model.weeklySchedule
                              .map((e) => '${e.key}: ${e.value.map((e) => normalizedTi(e)).join('-')}')
                              .join(', ');
                        });
                      }
                    },
                  ));
                },
                iconInfo: BaseUiKitButtonIconData(
                  iconData: ShuffleUiKitIcons.clock,
                  size: 16.h,
                ),
              ),
            ),
          ],
        ).paddingSymmetric(horizontal: horizontalPadding),
        // SpacingFoundation.verticalSpace24,

        SpacingFoundation.verticalSpace24,
        UiKitInputFieldNoFill(
          keyboardType: TextInputType.url,
          label: S.of(context).Website,
          controller: _websiteController,
        ).paddingSymmetric(horizontal: horizontalPadding),
        SpacingFoundation.verticalSpace24,
        UiKitInputFieldNoFill(
          keyboardType: TextInputType.phone,
          label: S.of(context).Phone,
          controller: _phoneController,
        ).paddingSymmetric(horizontal: horizontalPadding),
        SpacingFoundation.verticalSpace24,
        UiKitInputFieldNoFill(
                keyboardType: TextInputType.text,
                label: S.of(context).Price,
                controller: _priceController,
                onTap: () {
                  context.push(PriceSelectorComponent(onSubmit: (price1,price2,currency){
                    setState(() {
                      _priceController.text = price1;
                      if(price2.isNotEmpty){
                        _priceController.text += '-$price2';
                      }
                      _placeToEdit.currency = currency;
                    });
                  },));
                })
            .paddingSymmetric(horizontal: horizontalPadding),
        SpacingFoundation.verticalSpace24,
        UiKitInputFieldNoFill(
          keyboardType: TextInputType.text,
          label: S.of(context).Category,
          controller: _typeController,
          onTap: () {
            widget.onCategoryChanged?.call().then((value) {
              _typeController.text = value ?? '';
              setState(() {
                _placeToEdit.placeType = value ?? '';
              });
            });
          },
        ).paddingSymmetric(horizontal: horizontalPadding),
        SpacingFoundation.verticalSpace24,
        Text(
          S.of(context).TypeOfContent,
          style: theme?.regularTextTheme.labelSmall,
        ).paddingSymmetric(horizontal: horizontalPadding),
        SpacingFoundation.verticalSpace4,
        UiKitCustomTabBar(
          selectedTab: _placeToEdit.contentType,
          onTappedTab: (index) {
            setState(() {
              _placeToEdit.contentType = [
                'both',
                'leisure',
                'business',
              ][index];
            });
          },
          tabs: [
            UiKitCustomTab(title: S.of(context).Both, customValue: 'both', group: contentSelectionGroup),
            UiKitCustomTab(
              title: S.of(context).Leisure,
              customValue: 'leisure',
              group: contentSelectionGroup,
            ),
            UiKitCustomTab(title: S.of(context).Business, customValue: 'business', group: contentSelectionGroup),
          ],
        ),
        if (_placeToEdit.contentType != 'leisure') ...[
          SpacingFoundation.verticalSpace24,
          Text(
            S.of(context).PleaseSelectANiche,
            style: theme?.regularTextTheme.labelSmall,
          ).paddingSymmetric(horizontal: horizontalPadding),
          SpacingFoundation.verticalSpace4,
          UiKitInputFieldNoFill(
            keyboardType: TextInputType.text,
            label: S.of(context).Niche,
            controller: _nicheController,
            onTap: () {
              widget.onNicheChanged?.call().then((value) {
                _nicheController.text = value ?? '';
                _placeToEdit.niche = value ?? '';
              });
            },
          ).paddingSymmetric(horizontal: horizontalPadding),
        ],
        SpacingFoundation.verticalSpace24,
        Text(
          S.of(context).BaseProperties,
          style: theme?.regularTextTheme.labelSmall,
        ).paddingSymmetric(horizontal: horizontalPadding),
        SpacingFoundation.verticalSpace4,
        GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () async {
              final newTags = await context.push(TagsSelectionComponent(
                positionModel: model.positionModel,
                tags: _placeToEdit.baseTags.map((tag) => tag.title).toList(),
                title: S.of(context).BaseProperties,
                options: (String v) => widget.propertiesOptions(v, 'base'),
              ));
              if (newTags != null) {
                setState(() {
                  _placeToEdit.baseTags.clear();
                  _placeToEdit.baseTags.addAll((newTags as List<String>).map((e) => UiKitTag(title: e, icon: null)));
                });
              }
            },
            child: IgnorePointer(
                child: UiKitTagSelector(
              showTextField: false,
              tags: _placeToEdit.baseTags.map((tag) => tag.title).toList(),
            )).paddingSymmetric(horizontal: horizontalPadding)),
        SpacingFoundation.verticalSpace24,
        if (_placeToEdit.placeType != null && _placeToEdit.placeType!.isNotEmpty) ...[
          Text(S.of(context).UniqueProperties, style: theme?.regularTextTheme.labelSmall)
              .paddingSymmetric(horizontal: horizontalPadding),
          SpacingFoundation.verticalSpace4,
          GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () async {
                final newTags = await context.push(TagsSelectionComponent(
                  positionModel: model.positionModel,
                  tags: _placeToEdit.tags.map((tag) => tag.title).toList(),
                  title: S.of(context).UniqueProperties,
                  options: (String v) => widget.propertiesOptions(v, 'unique'),
                ));
                if (newTags != null) {
                  setState(() {
                    _placeToEdit.tags.clear();
                    _placeToEdit.tags.addAll((newTags as List<String>).map((e) => UiKitTag(title: e, icon: null)));
                  });
                }
              },
              child: IgnorePointer(
                  child: UiKitTagSelector(
                showTextField: false,
                tags: _placeToEdit.tags.map((tag) => tag.title).toList(),
              )).paddingSymmetric(horizontal: horizontalPadding)),
          SpacingFoundation.verticalSpace24,
        ],
        SafeArea(
          top: false,
          child: context.gradientButton(
            data: BaseUiKitButtonData(
              fit: ButtonFit.fitWidth,
              text: S.of(context).Save.toUpperCase(),
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
        ).paddingSymmetric(horizontal: horizontalPadding)
      ],
    );
  }
}
