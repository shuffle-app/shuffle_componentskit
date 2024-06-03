import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shuffle_uikit/shuffle_uikit.dart';

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
  final List<String> Function(String) propertiesOptions;
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
    _websiteController.text = widget.placeToEdit?.website ?? '';
    _phoneController.text = widget.placeToEdit?.phone ?? '';
    _priceController.text = widget.placeToEdit?.price ?? '';
    _typeController.text = widget.placeToEdit?.placeType ?? '';
    _nicheController.text = widget.placeToEdit?.niche ?? '';
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
        UiKitInputFieldNoFill(
          label: S.of(context).Address,
          onTap: () async {
            _locationController.text = await widget.getLocation?.call() ?? '';
            _placeToEdit.location = _locationController.text;
          },
          readOnly: true,
          controller: _locationController,
          icon: ImageWidget(
            iconData: ShuffleUiKitIcons.landmark,
            color: theme?.colorScheme.inversePrimary,
            height: 16.h,
            width: 16.h,
          ),
        ).paddingSymmetric(horizontal: horizontalPadding),
        SpacingFoundation.verticalSpace12,
        Row(
          children: [
            Expanded(
                child: UiKitInputFieldNoFill(
              label: S.of(context).BuildingNumber,
              controller: _placeToEdit.houseNumberController,
            ).paddingSymmetric(horizontal: horizontalPadding)),
            Expanded(
                child: UiKitInputFieldNoFill(
              label: S.of(context).OfficeAppartmentNumber,
              controller: _placeToEdit.apartmentNumberController,
            ).paddingSymmetric(horizontal: horizontalPadding)),
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
        IntrinsicHeight(
          child: UiKitInputFieldNoFill(
            label: S.of(context).Description,
            controller: _descriptionController,
            expands: true,
          ),
        ).paddingSymmetric(horizontal: horizontalPadding),
        SpacingFoundation.verticalSpace24,
        Row(
          children: [
            Text(S.of(context).WorkHours, style: theme?.regularTextTheme.labelSmall),
            const Spacer(),
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
                  iconData: CupertinoIcons.chevron_forward,
                  size: 16.h,
                ),
              ),
            ),
          ],
        ).paddingSymmetric(horizontal: horizontalPadding),
        if (_placeToEdit.scheduleString != null) ...[
          SpacingFoundation.verticalSpace24,
          Text(
            _placeToEdit.scheduleString!,
            style: theme?.boldTextTheme.body,
            textAlign: TextAlign.center,
          )
        ],
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
            readOnly: true,
            controller: _priceController,
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'^\d*([.,]?\d*)$')),
            ],
            onTap: () {
              showUiKitGeneralFullScreenDialog(
                context,
                GeneralDialogData(
                  topPadding: 1.sw <= 380 ? 0.15.sh : 0.40.sh,
                  useRootNavigator: false,
                  child: PriceSelectorComponent(
                    averagePriceSelected: _priceController.text.contains('-'),
                    initialPriceRange1: _priceController.text.split('-').first,
                    initialPriceRange2:
                        _priceController.text.contains('-') ? _priceController.text.split('-').last : null,
                    initialCurrency: _placeToEdit.currency,
                    onSubmit: (averagePrice, rangePrice1, rangePrice2, currency, averageSelected) {
                      setState(() {
                        if (averageSelected) {
                          _priceController.text = averagePrice;
                        } else {
                          _priceController.text = rangePrice1;
                          if (rangePrice2.isNotEmpty && rangePrice1.isNotEmpty) {
                            _priceController.text += '-$rangePrice2';
                          }
                          _placeToEdit.currency = currency;
                        }
                      });
                    },
                  ),
                ),
              );
            }).paddingSymmetric(horizontal: horizontalPadding),
        SpacingFoundation.verticalSpace24,
        UiKitInputFieldNoFill(
          keyboardType: TextInputType.text,
          label: S.of(context).PlaceType,
          controller: _typeController,
          readOnly: true,
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
            UiKitCustomTab(
              title: S.of(context).Both,
              customValue: 'both',
            ),
            UiKitCustomTab(
              title: S.of(context).Leisure,
              customValue: 'leisure',
            ),
            UiKitCustomTab(
              title: S.of(context).Business,
              customValue: 'business',
              group: AutoSizeGroup(),
            ),
          ],
        ),
        if (_placeToEdit.contentType == 'business') ...[
          SpacingFoundation.verticalSpace24,
          Text(
            S.of(context).PleaseSelectANiche,
            style: theme?.regularTextTheme.labelSmall,
          ).paddingSymmetric(horizontal: horizontalPadding),
          SpacingFoundation.verticalSpace4,
          UiKitInputFieldNoFill(
            keyboardType: TextInputType.text,
            label: S.of(context).Niche,
            readOnly: true,
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
                selectedTags: _placeToEdit.baseTags.map((tag) => tag.title).toList(),
                title: S.of(context).BaseProperties,
                allTags: widget.propertiesOptions('base'),
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
                  selectedTags: _placeToEdit.tags.map((tag) => tag.title).toList(),
                  title: S.of(context).UniqueProperties,
                  allTags: widget.propertiesOptions('unique'),
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
                _placeToEdit.price = _priceController.text;
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
