import 'dart:math';
import 'dart:developer' as dev;
import 'package:collection/collection.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shuffle_components_kit/presentation/components/add_link_components/add_link_component.dart';
import 'package:shuffle_components_kit/presentation/components/add_link_components/select_booking_link_component.dart';
import 'package:shuffle_uikit/shuffle_uikit.dart';

import '../../../shuffle_components_kit.dart';
import '../../common/photolist_editing_component.dart';
import '../../common/tags_selection_component.dart';
import '../booking_component/payment_type_selection/booking_payment_type_selection_component.dart';

class CreatePlaceComponent extends StatefulWidget {
  final UiPlaceModel? placeToEdit;
  final VoidCallback? onPlaceDeleted;
  final AsyncValueChanged<void, UiPlaceModel> onPlaceCreated;
  final Future<String?> Function(String?)? getLocation;
  final Future<UiKitTag?> Function(String?)? onCategoryChanged;
  final Future<UiKitTag?> Function()? onNicheChanged;
  final List<UiKitTag> Function(String) propertiesOptions;
  final List<UiScheduleModel> availableTimeTemplates;
  final ValueChanged<UiScheduleModel>? onTimeTemplateCreated;
  final bool Function(BookingUiModel)? onBookingTap;
  final List<String> availableTagOptions;
  final Future<String?> Function()? onCityChanged;
  final ValueChanged<UiPlaceModel>? onDraftChanged;
  final StripeRegistrationStatus? stripeStatus;

  const CreatePlaceComponent({
    super.key,
    this.placeToEdit,
    this.getLocation,
    this.onPlaceDeleted,
    required this.onPlaceCreated,
    required this.propertiesOptions,
    this.onCategoryChanged,
    this.availableTimeTemplates = const [],
    this.onTimeTemplateCreated,
    this.onNicheChanged,
    this.onBookingTap,
    this.availableTagOptions = const [],
    this.onCityChanged,
    this.onDraftChanged,
    this.stripeStatus,
  });

  @override
  State<CreatePlaceComponent> createState() => _CreatePlaceComponentState();
}

class _CreatePlaceComponentState extends State<CreatePlaceComponent> {
  late final TextEditingController _titleController = TextEditingController();
  late final TextEditingController _phoneController = TextEditingController();
  late final TextEditingController _websiteController = TextEditingController();
  late final TextEditingController _locationController = TextEditingController();
  late final TextEditingController _cityController = TextEditingController();
  late final TextEditingController _descriptionController = TextEditingController();
  late final TextEditingController _priceController = TextEditingController();
  late final TextEditingController _bookingUrlController = TextEditingController();
  late final TextEditingController houseNumberController = TextEditingController();
  late final TextEditingController apartmentNumberController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late final GlobalKey<ReorderableListState> _reordablePhotokey = GlobalKey<ReorderableListState>();
  late final GlobalKey<ReorderableListState> _reordableVideokey = GlobalKey<ReorderableListState>();
  Key _refreshKey = UniqueKey();

  late UiPlaceModel _placeToEdit;
  late BookingUiModel? _bookingUiModel;

  final List<BaseUiKitMedia> _videos = [];
  final List<BaseUiKitMedia> _photos = [];

  @override
  void initState() {
    FocusManager.instance.addListener(_onFocusChanged);
    super.initState();
    _bookingUrlController.text = widget.placeToEdit?.bookingUrl ?? '';
    _titleController.text = widget.placeToEdit?.title ?? '';
    _descriptionController.text = widget.placeToEdit?.description ?? '';
    _locationController.text = widget.placeToEdit?.location ?? '';
    _cityController.text = widget.placeToEdit?.city ?? '';
    _placeToEdit = widget.placeToEdit ??
        UiPlaceModel(
          id: -1,
          media: [],
          tags: [],
          description: '',
        );
    _photos.addAll(_placeToEdit.media.where((element) => element.type == UiKitMediaType.image));
    if (_placeToEdit.verticalPreview != null) {
      _photos.add(_placeToEdit.verticalPreview!);
    }
    _videos.addAll(_placeToEdit.media.where((element) => element.type == UiKitMediaType.video));
    _websiteController.text = widget.placeToEdit?.website ?? '';
    _phoneController.text = widget.placeToEdit?.phone ?? '';
    _priceController.text = widget.placeToEdit?.price ?? '';
    _bookingUiModel = widget.placeToEdit?.bookingUiModel;
    houseNumberController.text = widget.placeToEdit?.houseNumber ?? '';
    apartmentNumberController.text = widget.placeToEdit?.apartmentNumber ?? '';
  }

  _onFocusChanged() {
    dev.log('focus changed', name: '_onFocusChanged');
    widget.onDraftChanged?.call(_placeToEdit.copyWith(
      city: _cityController.text,
      title: _titleController.text,
      description: _descriptionController.text,
      media: [..._photos, ..._videos],
      website: _websiteController.text.trim(),
      phone: _phoneController.text,
      price: _priceController.text.replaceAll(' ', ''),
      bookingUrl: _bookingUrlController.text,
      bookingUiModel: _bookingUiModel,
      verticalPreview: _photos.firstWhereOrNull((e) => e.type == UiKitMediaType.image),
      houseNumber: houseNumberController.text,
      apartmentNumber: apartmentNumberController.text,
    ));
  }

  _onVideoDeleted(int index) {
    setState(() {
      _videos.removeAt(index);
    });
  }

  _handleLocaleChanged() {
    setState(() {
      _refreshKey = UniqueKey();
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

  Future? requestMediaFuture;

  _onLogoAddRequested() async {
    if (requestMediaFuture != null) return;
    final file = await (requestMediaFuture ??= ImagePicker().pickImage(source: ImageSource.gallery));
    requestMediaFuture = null;
    if (file != null) {
      setState(() {
        _placeToEdit.logo = file.path;
      });
    }
  }

  _onVideoAddRequested() async {
    if (requestMediaFuture != null) return;
    final videoFile = await (requestMediaFuture ??= ImagePicker().pickVideo(source: ImageSource.gallery));
    requestMediaFuture = null;
    if (videoFile != null) {
      setState(() {
        _videos.add(UiKitMediaVideo(link: videoFile.path));
      });
    }
  }

  _onPhotoReorderRequested(int oldIndex, int newIndex) {
    if (oldIndex != newIndex) {
      setState(() {
        _photos.insert(min(newIndex, _photos.length - 1), _photos.removeAt(oldIndex));
      });
    }
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
      if (_placeToEdit.verticalPreview != null) {
        _photos.add(_placeToEdit.verticalPreview!);
      }
      _videos.addAll(_placeToEdit.media.where((element) => element.type == UiKitMediaType.video));
      _bookingUrlController.text = widget.placeToEdit?.bookingUrl ?? '';
      _descriptionController.text = widget.placeToEdit?.description ?? '';
      _websiteController.text = widget.placeToEdit?.website ?? '';
      _phoneController.text = widget.placeToEdit?.phone ?? '';
      _priceController.text = widget.placeToEdit?.price ?? '';
      _titleController.text = widget.placeToEdit?.title ?? '';
      _locationController.text = widget.placeToEdit?.location ?? '';
      _bookingUiModel = widget.placeToEdit?.bookingUiModel;
    }
    //handle location changes
    if (oldWidget.placeToEdit?.location == null || oldWidget.placeToEdit?.location == '') {
      _locationController.text = widget.placeToEdit?.location ?? '';
    }

    _cityController.text = widget.placeToEdit?.city ?? '';
    _handleLocaleChanged();
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    FocusManager.instance.removeListener(_onFocusChanged);
    apartmentNumberController.dispose();
    houseNumberController.dispose();
    _bookingUrlController.dispose();
    _titleController.dispose();
    _descriptionController.dispose();
    _locationController.dispose();
    _cityController.dispose();
    _phoneController.dispose();
    _priceController.dispose();
    _websiteController.dispose();
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

    final tagTextStyle = context.uiKitTheme?.boldTextTheme.caption2Bold.copyWith(
      color: ColorsFoundation.darkNeutral500,
    );

    return Form(
        key: _formKey,
        child: BlurredAppBarPage(
          title: S.of(context).Place,
          onIWidgetInfoString: S.current.ContentQualityNotice,
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
              onTap: () async {
                _cityController.text = await widget.onCityChanged?.call() ?? '';
                _placeToEdit.city = _cityController.text;

                FocusManager.instance.primaryFocus?.unfocus();
                setState(() {});
              },
              label: S.of(context).City,
              readOnly: true,
              controller: _cityController,
            ).paddingSymmetric(horizontal: horizontalPadding),
            SpacingFoundation.verticalSpace24,
            UiKitInputFieldNoFill(
              label: S.of(context).Address,
              onTap: () async {
                _locationController.text = await widget.getLocation?.call(_cityController.text) ?? '';
                _placeToEdit.location = _locationController.text;
                setState(() {});
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
                  controller: houseNumberController,
                ).paddingSymmetric(horizontal: horizontalPadding)),
                Expanded(
                    child: UiKitInputFieldNoFill(
                  label: S.of(context).OfficeAppartmentNumber,
                  controller: apartmentNumberController,
                ).paddingSymmetric(horizontal: horizontalPadding)),
              ],
            ),
            SpacingFoundation.verticalSpace24,
            UiKitInputFieldNoFill(
              label: S.of(context).Title,
              validator: titleValidator,
              controller: _titleController,
              hintText: 'Place name',
              onChanged: (_) {
                _formKey.currentState?.validate();
                setState(() {});
              },
            ).paddingSymmetric(horizontal: horizontalPadding),
            SpacingFoundation.verticalSpace24,
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  S.of(context).Logo,
                  style: theme?.regularTextTheme.labelSmall,
                ).paddingOnly(right: horizontalPadding),
                Builder(
                  builder: (context) => GestureDetector(
                    onTap: () => showUiKitPopover(
                      context,
                      customMinHeight: 30.h,
                      showButton: false,
                      title: Text(
                        S.of(context).SupportedFormatsBooking,
                        style: theme?.regularTextTheme.body.copyWith(color: Colors.black87),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    child: ImageWidget(
                      iconData: ShuffleUiKitIcons.info,
                      width: 16.w,
                      color: theme?.colorScheme.darkNeutral900,
                    ),
                  ),
                ),
                if (_placeToEdit.logo != null)
                  CircularAvatar(height: kIsWeb ? 40 : 40.h, avatarUrl: _placeToEdit.logo!),
                const Spacer(),
                context.smallOutlinedButton(
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
              positionModel: model.positionModel,
              videos: _videos,
              photos: _photos,
              onVideoAddRequested: _onVideoAddRequested,
              onVideoDeleted: _onVideoDeleted,
              onPhotoAddRequested: _onPhotoAddRequested,
              onPhotoDeleted: _onPhotoDeleted,
              onPhotoReorderRequested: _onPhotoReorderRequested,
              listPhotosKey: _reordablePhotokey,
              listVideosKey: _reordableVideokey,
              onVideoReorderRequested: _onVideoReorderRequested,
            ),
            SpacingFoundation.verticalSpace24,
            IntrinsicHeight(
              child: UiKitInputFieldNoFill(
                label: S.of(context).Description,
                hintText: 'Some amazing details about the place',
                validator: descriptionValidator,
                controller: _descriptionController,
                textInputAction: TextInputAction.newline,
                expands: true,
                onChanged: (_) {
                  _formKey.currentState?.validate();
                  setState(() {});
                },
              ),
            ).paddingSymmetric(horizontal: horizontalPadding),
            SpacingFoundation.verticalSpace24,
            UiKitInputFieldNoFill(
              keyboardType: TextInputType.url,
              label: S.of(context).Website,
              hintText: 'https://coolplace.com',
              inputFormatters: [PrefixFormatter(prefix: 'https://')],
              validator: websiteValidator,
              controller: _websiteController,
            ).paddingSymmetric(horizontal: horizontalPadding),
            SpacingFoundation.verticalSpace24,
            UiKitInputFieldNoFill(
              prefixText: '+',
              keyboardType: TextInputType.phone,
              inputFormatters: [
                (_cityController.text.toLowerCase() == 'пхукет' || _cityController.text.toLowerCase() == 'phuket')
                    ? phuketInternationalFormatter
                    : americanInputFormatter
              ],
              label: S.of(context).Phone,
              validator: phoneNumberValidator,
              controller: _phoneController,
            ).paddingSymmetric(horizontal: horizontalPadding),
            SpacingFoundation.verticalSpace24,
            UiKitFieldWithTagList(
              listUiKitTags: [
                UiKitTag(
                  title: _priceController.text.isNotEmpty
                      ? '${_placeToEdit.currency ?? ''} ${_priceController.text}'
                      : '0',
                  icon: ShuffleUiKitIcons.label,
                ),
              ],
              title: S.of(context).Price,
              onTap: () {
                showUiKitGeneralFullScreenDialog(
                  context,
                  GeneralDialogData(
                    topPadding: 1.sw <= 380 ? 0.12.sh : 0.37.sh,
                    useRootNavigator: false,
                    child: PriceSelectorComponent(
                      isPriceRangeSelected: _priceController.text.contains('-'),
                      initialPriceRangeStart: _priceController.text.split('-').first,
                      initialPriceRangeEnd:
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
                          }
                          _placeToEdit.currency = currency;
                        });
                      },
                    ),
                  ),
                );
              },
            ).paddingSymmetric(horizontal: horizontalPadding),
            SpacingFoundation.verticalSpace24,
            Row(
              children: [
                Text(S.of(context).WorkHours, style: theme?.regularTextTheme.labelSmall),
                const Spacer(),
                context.smallOutlinedButton(
                  data: BaseUiKitButtonData(
                    onPressed: () {
                      context.push(CreateScheduleWidget(
                        scheduleToEdit: [UiScheduleDatesModel, UiScheduleDatesRangeModel, UiScheduleTimeModel]
                                .contains(_placeToEdit.schedule.runtimeType)
                            ? _placeToEdit.schedule
                            : null,
                        availableTemplates: widget.availableTimeTemplates,
                        onTemplateCreated: widget.onTimeTemplateCreated,
                        availableTypes: const [
                          UiScheduleTimeModel.scheduleType,
                          UiScheduleDatesModel.scheduleType,
                          UiScheduleDatesRangeModel.scheduleType
                        ],
                        onScheduleCreated: (model) {
                          if (model is UiScheduleDatesModel) {
                            setState(() {
                              _placeToEdit.schedule = model;

                              _placeToEdit.scheduleString =
                                  model.getReadableScheduleString().map((pair) => pair.join(', ')).join(' / ');
                            });
                          } else if (model is UiScheduleDatesRangeModel) {
                            setState(() {
                              _placeToEdit.schedule = model;

                              _placeToEdit.scheduleString =
                                  model.getReadableScheduleString().map((pair) => pair.join(', ')).join(' / ');
                            });
                          } else if (model is UiScheduleTimeModel) {
                            setState(() {
                              _placeToEdit.schedule = model;

                              _placeToEdit.scheduleString =
                                  model.getReadableScheduleString().map((pair) => pair.join(': ')).join(' / ');
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
            Text(
              S.of(context).TypeOfContent,
              style: theme?.regularTextTheme.labelSmall,
            ).paddingSymmetric(horizontal: horizontalPadding),
            SpacingFoundation.verticalSpace4,
            UiKitCustomTabBar(
              key: _refreshKey,
              selectedTab: _placeToEdit.contentType,
              onTappedTab: (index) {
                final oldContentType = _placeToEdit.contentType;

                setState(() {
                  _placeToEdit.contentType = ['both', 'leisure', 'business'][index];

                  if (_placeToEdit.contentType != oldContentType) {
                    _placeToEdit.placeType = null;
                    _placeToEdit.niche = null;
                  }
                });
              },
              tabs: [
                UiKitCustomTab(
                  title: S.of(context).Both,
                  customValue: 'both',
                  group: _tabsGroup,
                ),
                UiKitCustomTab(
                  title: S.of(context).Leisure,
                  customValue: 'leisure',
                  group: _tabsGroup,
                ),
                UiKitCustomTab(
                  title: S.of(context).Business,
                  customValue: 'business',
                  group: _tabsGroup,
                ),
              ],
            ),
            SpacingFoundation.verticalSpace24,
            UiKitFieldWithTagList(
              title: S.of(context).PlaceType,
              listUiKitTags: _placeToEdit.placeType != null ? [_placeToEdit.placeType!] : null,
              onTap: () {
                widget.onCategoryChanged?.call(_placeToEdit.contentType).then((value) {
                  setState(() {
                    _placeToEdit.placeType = value;
                    _placeToEdit.baseTags.clear();
                    _placeToEdit.tags.clear();
                  });
                });
              },
            ).paddingSymmetric(horizontal: horizontalPadding),
            if (_placeToEdit.contentType == 'business') ...[
              UiKitFieldWithTagList(
                listUiKitTags: _placeToEdit.niche != null ? [_placeToEdit.niche!] : null,
                title: S.of(context).PleaseSelectANiche,
                onTap: () {
                  widget.onNicheChanged?.call().then((value) {
                    setState(() {
                      _placeToEdit.niche = value;
                    });
                  });
                },
              ).paddingSymmetric(horizontal: horizontalPadding)
            ],
            SpacingFoundation.verticalSpace24,
            if (_placeToEdit.placeType != null && _placeToEdit.placeType!.title.isNotEmpty) ...[
              if (widget.availableTagOptions.contains('base')) ...[
                UiKitFieldWithTagList(
                    listUiKitTags: _placeToEdit.baseTags.isNotEmpty
                        ? _placeToEdit.baseTags
                            .where((e) => widget.propertiesOptions('base').any((el) => e.id == el.id))
                            .toList()
                        : null,
                    title: S.of(context).BaseProperties,
                    onTap: () async {
                      final newTags = await context.push(TagsSelectionComponent(
                        positionModel: model.positionModel,
                        selectedTags: _placeToEdit.baseTags,
                        title: S.of(context).BaseProperties,
                        allTags: widget.propertiesOptions('base'),
                      ));
                      if (newTags != null) {
                        setState(() {
                          final tagList = List<UiKitTag>.from(_placeToEdit.baseTags
                              .where((e) => widget.propertiesOptions('base').any((el) => e.id == el.id)));
                          final notTypeTags = List<UiKitTag>.from(
                              _placeToEdit.baseTags.where((e) => !tagList.any((el) => el.id == e.id)));
                          final tagsToRemove = tagList.where((e) => !newTags.any((el) => el.id == e.id));
                          tagList.removeWhere((e) => tagsToRemove.any((el) => el.id == e.id));
                          tagList.addAll(newTags);
                          tagList.addAll(notTypeTags);
                          _placeToEdit.baseTags.clear();
                          _placeToEdit.baseTags.addAll(tagList.toSet());
                        });
                      }
                    }).paddingSymmetric(horizontal: horizontalPadding),
                SpacingFoundation.verticalSpace24
              ],
              UiKitFieldWithTagList(
                listUiKitTags: _placeToEdit.tags.isNotEmpty ? _placeToEdit.tags : null,
                title: S.of(context).UniqueProperties,
                onTap: () async {
                  final newTags = await context.push(TagsSelectionComponent(
                    positionModel: model.positionModel,
                    selectedTags: _placeToEdit.tags,
                    title: S.of(context).UniqueProperties,
                    allTags: widget.propertiesOptions('unique'),
                  ));
                  if (newTags != null) {
                    setState(() {
                      _placeToEdit.tags.clear();
                      _placeToEdit.tags.addAll(newTags.toSet());
                    });
                  }
                },
              ).paddingSymmetric(horizontal: horizontalPadding),
              SpacingFoundation.verticalSpace24,
              if (widget.availableTagOptions.contains('museumtype')) ...[
                UiKitFieldWithTagList(
                    listUiKitTags: _placeToEdit.baseTags.isNotEmpty
                        ? _placeToEdit.baseTags
                            .where((e) => widget.propertiesOptions('museumtype').any((el) => e.id == el.id))
                            .toList()
                        : null,
                    title: S.of(context).MuseumType,
                    onTap: () async {
                      final newTags = await context.push(TagsSelectionComponent(
                        positionModel: model.positionModel,
                        selectedTags: _placeToEdit.baseTags,
                        title: S.of(context).MuseumType,
                        allTags: widget.propertiesOptions('museumtype'),
                      ));
                      if (newTags != null) {
                        setState(() {
                          final tagList = List<UiKitTag>.from(_placeToEdit.baseTags
                              .where((e) => widget.propertiesOptions('museumtype').any((el) => e.id == el.id)));
                          final notTypeTags = List<UiKitTag>.from(
                              _placeToEdit.baseTags.where((e) => !tagList.any((el) => el.id == e.id)));
                          final tagsToRemove = tagList.where((e) => !newTags.any((el) => el.id == e.id));
                          tagList.removeWhere((e) => tagsToRemove.any((el) => el.id == e.id));
                          tagList.addAll(newTags);
                          tagList.addAll(notTypeTags);
                          _placeToEdit.baseTags.clear();
                          _placeToEdit.baseTags.addAll(tagList.toSet());
                        });
                      }
                    }).paddingSymmetric(horizontal: horizontalPadding),
                SpacingFoundation.verticalSpace24
              ],
              if (widget.availableTagOptions.contains('cuisinetype')) ...[
                UiKitFieldWithTagList(
                    listUiKitTags: _placeToEdit.baseTags.isNotEmpty
                        ? _placeToEdit.baseTags
                            .where((e) => widget.propertiesOptions('cuisinetype').any((el) => e.id == el.id))
                            .toList()
                        : null,
                    title: S.of(context).CuisineType,
                    onTap: () async {
                      final newTags = await context.push(TagsSelectionComponent(
                        positionModel: model.positionModel,
                        selectedTags: _placeToEdit.baseTags,
                        title: S.of(context).CuisineType,
                        allTags: widget.propertiesOptions('cuisinetype'),
                      ));
                      if (newTags != null) {
                        setState(() {
                          final tagList = List<UiKitTag>.from(_placeToEdit.baseTags
                              .where((e) => widget.propertiesOptions('cuisinetype').any((el) => e.id == el.id)));
                          final notTypeTags = List<UiKitTag>.from(
                              _placeToEdit.baseTags.where((e) => !tagList.any((el) => el.id == e.id)));
                          final tagsToRemove = tagList.where((e) => !newTags.any((el) => el.id == e.id));
                          tagList.removeWhere((e) => tagsToRemove.any((el) => el.id == e.id));
                          tagList.addAll(newTags);
                          tagList.addAll(notTypeTags);
                          _placeToEdit.baseTags.clear();
                          _placeToEdit.baseTags.addAll(tagList.toSet());
                        });
                      }
                    }).paddingSymmetric(horizontal: horizontalPadding),
                SpacingFoundation.verticalSpace24
              ],
              if (widget.availableTagOptions.contains('gallerytype')) ...[
                UiKitFieldWithTagList(
                    listUiKitTags: _placeToEdit.baseTags.isNotEmpty
                        ? _placeToEdit.baseTags
                            .where((e) => widget.propertiesOptions('gallerytype').any((el) => e.id == el.id))
                            .toList()
                        : null,
                    title: S.of(context).GalleryType,
                    onTap: () async {
                      final newTags = await context.push(TagsSelectionComponent(
                        positionModel: model.positionModel,
                        selectedTags: _placeToEdit.baseTags,
                        title: S.of(context).GalleryType,
                        allTags: widget.propertiesOptions('gallerytype'),
                      ));
                      if (newTags != null) {
                        setState(() {
                          final tagList = List<UiKitTag>.from(_placeToEdit.baseTags
                              .where((e) => widget.propertiesOptions('gallerytype').any((el) => e.id == el.id)));
                          final notTypeTags = List<UiKitTag>.from(
                              _placeToEdit.baseTags.where((e) => !tagList.any((el) => el.id == e.id)));
                          final tagsToRemove = tagList.where((e) => !newTags.any((el) => el.id == e.id));
                          tagList.removeWhere((e) => tagsToRemove.any((el) => el.id == e.id));
                          tagList.addAll(newTags);
                          tagList.addAll(notTypeTags);
                          _placeToEdit.baseTags.clear();
                          _placeToEdit.baseTags.addAll(tagList.toSet());
                        });
                      }
                    }).paddingSymmetric(horizontal: horizontalPadding),
                SpacingFoundation.verticalSpace24
              ],
              if (widget.availableTagOptions.contains('musictype')) ...[
                UiKitFieldWithTagList(
                    listUiKitTags: _placeToEdit.baseTags.isNotEmpty
                        ? _placeToEdit.baseTags
                            .where((e) => widget.propertiesOptions('musictype').any((el) => e.id == el.id))
                            .toList()
                        : null,
                    title: S.of(context).MusicType,
                    onTap: () async {
                      final newTags = await context.push(TagsSelectionComponent(
                        positionModel: model.positionModel,
                        selectedTags: _placeToEdit.baseTags,
                        title: S.of(context).MusicType,
                        allTags: widget.propertiesOptions('musictype'),
                      ));
                      if (newTags != null) {
                        setState(() {
                          final tagList = List<UiKitTag>.from(_placeToEdit.baseTags
                              .where((e) => widget.propertiesOptions('musictype').any((el) => e.id == el.id)));
                          final notTypeTags = List<UiKitTag>.from(
                              _placeToEdit.baseTags.where((e) => !tagList.any((el) => el.id == e.id)));
                          final tagsToRemove = tagList.where((e) => !newTags.any((el) => el.id == e.id));
                          tagList.removeWhere((e) => tagsToRemove.any((el) => el.id == e.id));
                          tagList.addAll(newTags);
                          tagList.addAll(notTypeTags);
                          _placeToEdit.baseTags.clear();
                          _placeToEdit.baseTags.addAll(tagList.toSet());
                        });
                      }
                    }).paddingSymmetric(horizontal: horizontalPadding),
                SpacingFoundation.verticalSpace24
              ],
            ],
            if (_placeToEdit.bookingUiModel == null || _placeToEdit.id <= 0)
              context
                  .button(
                    data: BaseUiKitButtonData(
                      fit: ButtonFit.fitWidth,
                      autoSizeGroup: AutoSizeGroup(),
                      text: _bookingUiModel == null && (_placeToEdit.bookingUrl ?? '').isEmpty
                          ? S.of(context).CreateBooking
                          : '${S.of(context).Edit} ${S.of(context).Booking}',
                      onPressed: () {
                        FocusScope.of(context).requestFocus(FocusNode());

                        showUiKitGeneralFullScreenDialog(
                          context,
                          GeneralDialogData(
                            isWidgetScrollable: true,
                            topPadding: 1.sw <= 380 ? 0.40.sh : 0.59.sh,
                            child: SelectBookingLinkComponent(
                              onExternalTap: () {
                                _bookingUrlController.text = _placeToEdit.bookingUrl ?? '';

                                context.pop();
                                showUiKitGeneralFullScreenDialog(
                                  context,
                                  GeneralDialogData(
                                    isWidgetScrollable: true,
                                    topPadding: 1.sw <= 380 ? 0.50.sh : 0.65.sh,
                                    child: AddLinkComponent(
                                      onSave: () {
                                        if (_bookingUrlController.text.isEmpty) {
                                          _placeToEdit.bookingUrl = null;
                                        } else {
                                          _placeToEdit.bookingUrl = _bookingUrlController.text.trim();
                                        }

                                        context.pop();
                                        setState(() {
                                          _bookingUiModel = null;
                                        });
                                      },
                                      linkController: _bookingUrlController,
                                    ),
                                  ),
                                );
                              },
                              onBookingTap: () {
                                context.pop();
                                context.push(
                                  BookingPaymentTypeSelectionComponent(
                                      stripeRegistrationStatus: widget.stripeStatus,
                                      selectedPaymentTypes: _bookingUiModel?.selectedPaymentTypes ?? [],
                                      goNext: (types) => CreateBookingComponent(
                                            selectedTypes: types,
                                            bookingUiModel: _bookingUiModel,
                                            currency: _placeToEdit.currency,
                                            onBookingCreated: (bookingUiModel) {
                                              if (widget.onBookingTap?.call(bookingUiModel) ?? false) {
                                                _bookingUiModel = bookingUiModel;
                                                setState(() {
                                                  _placeToEdit.bookingUrl = null;
                                                });
                                                navigatorKey.currentContext?.pop();
                                              }
                                            },
                                          )),
                                );
                              },
                            ),
                          ),
                        );
                      },
                    ),
                  )
                  .paddingSymmetric(horizontal: horizontalPadding),
            if (_placeToEdit.bookingUrl != null && _placeToEdit.bookingUrl!.isNotEmpty) ...[
              SpacingFoundation.verticalSpace10,
              Text(
                _placeToEdit.bookingUrl!,
                style: tagTextStyle,
                textAlign: TextAlign.center,
              )
            ],
            SpacingFoundation.verticalSpace24,
            SafeArea(
              top: false,
              child: context.gradientButton(
                data: BaseUiKitButtonData(
                  fit: ButtonFit.fitWidth,
                  text: S.of(context).Save.toUpperCase(),
                  onPressed: () {
                    _formKey.currentState?.validate();
                    _placeToEdit.city = _cityController.text;
                    _placeToEdit.title = _titleController.text;
                    _placeToEdit.website = _websiteController.text.trim();
                    _placeToEdit.phone = _phoneController.text;
                    _placeToEdit.description = _descriptionController.text;
                    _placeToEdit.price = _priceController.text.replaceAll(' ', '');
                    _placeToEdit.media = [..._photos, ..._videos];
                    _placeToEdit.bookingUiModel = _bookingUiModel;
                    _placeToEdit.houseNumber = houseNumberController.text;
                    _placeToEdit.apartmentNumber = apartmentNumberController.text;
                    widget.onPlaceCreated.call(_placeToEdit);
                  },
                ),
              ),
            ).paddingSymmetric(horizontal: horizontalPadding)
          ],
        ));
  }
}

AutoSizeGroup _tabsGroup = AutoSizeGroup();
