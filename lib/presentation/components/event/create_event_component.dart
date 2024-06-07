import 'dart:developer';

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

class CreateEventComponent extends StatefulWidget {
  final UiEventModel? eventToEdit;
  final VoidCallback? onEventDeleted;
  final Future Function(UiEventModel) onEventCreated;
  final Future<String?> Function()? getLocation;
  final Future<String?> Function()? onCategoryChanged;
  final Future<String?> Function()? onNicheChanged;
  final List<String> Function(String) propertiesOptions;
  final List<UiScheduleModel> availableTimeTemplates;
  final ValueChanged<UiScheduleModel>? onTimeTemplateCreated;

  const CreateEventComponent({
    super.key,
    this.eventToEdit,
    this.getLocation,
    this.onEventDeleted,
    required this.onEventCreated,
    this.onCategoryChanged,
    this.onNicheChanged,
    required this.propertiesOptions,
    required this.availableTimeTemplates,
    this.onTimeTemplateCreated,
  });

  @override
  State<CreateEventComponent> createState() => _CreateEventComponentState();
}

class _CreateEventComponentState extends State<CreateEventComponent> {
  late final TextEditingController _titleController = TextEditingController();
  late final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _typeController = TextEditingController();
  final TextEditingController _websiteController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  late final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  late UiEventModel _eventToEdit;

  final List<BaseUiKitMedia> _videos = [];
  final List<BaseUiKitMedia> _photos = [];

  @override
  void initState() {
    super.initState();
    _titleController.text = widget.eventToEdit?.title ?? '';
    _descriptionController.text = widget.eventToEdit?.description ?? '';
    _eventToEdit = widget.eventToEdit ?? UiEventModel(id: -1);
    _locationController.text = widget.eventToEdit?.location ?? '';
    _priceController.text = widget.eventToEdit?.price ?? '';
    _typeController.text = widget.eventToEdit?.eventType ?? '';
    _photos.addAll(_eventToEdit.media.where((element) => element.type == UiKitMediaType.image));
    _videos.addAll(_eventToEdit.media.where((element) => element.type == UiKitMediaType.video));
    _websiteController.text = widget.eventToEdit?.website ?? '';
    _phoneController.text = widget.eventToEdit?.phone ?? '';
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
    if (editedPhotos != null) {
      setState(() {
        _photos.clear();
        _photos.addAll(editedPhotos);
      });
    }
    // final files = await ImagePicker().pickMultiImage();
    // if (files.isNotEmpty) {
    //   setState(() {
    //     _photos.addAll(files.map((file) => UiKitMediaPhoto(link: file.path)));
    //   });
    // }
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
  void didUpdateWidget(covariant CreateEventComponent oldWidget) {
    if (oldWidget.eventToEdit != widget.eventToEdit) {
      _titleController.text = widget.eventToEdit?.title ?? '';
      _descriptionController.text = widget.eventToEdit?.description ?? '';
      _eventToEdit = widget.eventToEdit ?? UiEventModel(id: -1);
      _locationController.text = widget.eventToEdit?.location ?? '';
      _priceController.text = widget.eventToEdit?.price ?? '';
      _typeController.text = widget.eventToEdit?.eventType ?? '';
      _websiteController.text = widget.eventToEdit?.website ?? '';
      _phoneController.text = widget.eventToEdit?.phone ?? '';
      _photos.clear();
      _videos.clear();
      _photos.addAll(_eventToEdit.media.where((element) => element.type == UiKitMediaType.image));
      _videos.addAll(_eventToEdit.media.where((element) => element.type == UiKitMediaType.video));
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

    return Form(
      key: _formKey,
      child: BlurredAppBarPage(
        title: S.of(context).Event,
        centerTitle: true,
        autoImplyLeading: true,
        appBarTrailing: (widget.eventToEdit?.id ?? -1) > 0
            ? IconButton(
                icon: ImageWidget(
                    iconData: ShuffleUiKitIcons.trash,
                    color: theme?.colorScheme.inversePrimary,
                    height: 20.h,
                    fit: BoxFit.fitHeight),
                onPressed: widget.onEventDeleted,
              )
            : null,
        children: [
          SpacingFoundation.verticalSpace16,
          UiKitInputFieldNoFill(
            label: S.of(context).Title,
            controller: _titleController,
            validator: titleValidator,
          ).paddingSymmetric(horizontal: horizontalPadding),
          SpacingFoundation.verticalSpace24,
          PhotoVideoSelector(
            positionModel: model.positionModel,
            videos: _videos,
            photos: _photos,
            hideVideosSelection: true,
            onVideoAddRequested: _onVideoAddRequested,
            onVideoDeleted: _onVideoDeleted,
            onPhotoAddRequested: _onPhotoAddRequested,
            onPhotoDeleted: _onPhotoDeleted,
            onPhotoReorderRequested: _onPhotoReorderRequested,
            onVideoReorderRequested: _onVideoReorderRequested,
          ),
          SpacingFoundation.verticalSpace24,
          IntrinsicHeight(
            child: UiKitInputFieldNoFill(
              label: S.of(context).Description,
              controller: _descriptionController,
              expands: true,
              validator: descriptionValidator,
            ),
          ).paddingSymmetric(horizontal: horizontalPadding),
          SpacingFoundation.verticalSpace24,
          UiKitInputFieldNoFill(
            onTap: () async {
              _locationController.text = await widget.getLocation?.call() ?? '';
              _eventToEdit.location = _locationController.text;

              FocusManager.instance.primaryFocus?.unfocus();
            },
            label: S.of(context).Address,
            readOnly: true,
            controller: _locationController,
            icon: ImageWidget(
              iconData: ShuffleUiKitIcons.landmark,
              color: theme?.colorScheme.inversePrimary,
            ),
          ).paddingSymmetric(horizontal: horizontalPadding),
          SpacingFoundation.verticalSpace12,
          Row(
            children: [
              Expanded(
                  child: UiKitInputFieldNoFill(
                label: S.of(context).BuildingNumber,
                controller: _eventToEdit.houseNumberController,
              ).paddingSymmetric(horizontal: horizontalPadding)),
              Expanded(
                  child: UiKitInputFieldNoFill(
                label: S.of(context).OfficeAppartmentNumber,
                controller: _eventToEdit.apartmentNumberController,
              ).paddingSymmetric(horizontal: horizontalPadding)),
            ],
          ),
          SpacingFoundation.verticalSpace24,
          UiKitInputFieldNoFill(
            keyboardType: TextInputType.url,
            label: S.of(context).Website,
            controller: _websiteController,
            validator: websiteValidator,
          ).paddingSymmetric(horizontal: horizontalPadding),
          SpacingFoundation.verticalSpace24,
          UiKitInputFieldNoFill(
            keyboardType: TextInputType.phone,
            label: S.of(context).Phone,
            controller: _phoneController,
            validator: phoneNumberValidator,
          ).paddingSymmetric(horizontal: horizontalPadding),
          SpacingFoundation.verticalSpace24,
          UiKitInputFieldNoFill(
              keyboardType: TextInputType.text,
              label: S.of(context).Price,
              readOnly: true,
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'^\d*([.,]?\d*)$')),
              ],
              controller: _priceController,
              onTap: () {
                showUiKitGeneralFullScreenDialog(
                  context,
                  GeneralDialogData(
                    topPadding: 1.sw <= 380 ? 0.12.sh : 0.37.sh,
                    useRootNavigator: false,
                    child: PriceSelectorComponent(
                      isPriceRangeSelected: _priceController.text.contains('-'),
                      initialPriceRange1: _priceController.text.split('-').first,
                      initialPriceRange2:
                          _priceController.text.contains('-') ? _priceController.text.split('-').last : null,
                      initialCurrency: _eventToEdit.currency,
                      onSubmit: (averagePrice, rangePrice1, rangePrice2, currency, averageSelected) {
                        setState(() {
                          if (averageSelected) {
                            _priceController.text = averagePrice;
                          } else {
                            _priceController.text = rangePrice1;
                            if (rangePrice2.isNotEmpty && rangePrice1.isNotEmpty) {
                              _priceController.text += '-$rangePrice2';
                            }
                            _eventToEdit.currency = currency;
                          }
                        });

                        FocusManager.instance.primaryFocus?.unfocus();
                      },
                    ),
                  ),
                );
              }).paddingSymmetric(horizontal: horizontalPadding),
          SpacingFoundation.verticalSpace24,
          UiKitInputFieldNoFill(
            keyboardType: TextInputType.text,
            label: S.of(context).EventType,
            controller: _typeController,
            readOnly: true,
            onTap: () {
              widget.onCategoryChanged?.call().then((value) {
                _typeController.text = value ?? '';
                setState(() {
                  _eventToEdit.eventType = value ?? '';
                });
                FocusManager.instance.primaryFocus?.unfocus();
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
            selectedTab: _eventToEdit.contentType,
            onTappedTab: (index) {
              setState(() {
                _eventToEdit.contentType = ['both', 'leisure', 'business'][index];
              });
            },
            tabs: [
              UiKitCustomTab(
                height: 20.h,
                title: S.of(context).Both,
                customValue: 'both',
              ),
              UiKitCustomTab(
                height: 20.h,
                title: S.of(context).Leisure,
                customValue: 'leisure',
              ),
              UiKitCustomTab(
                height: 20.h,
                title: S.of(context).Business,
                customValue: 'business',
                group: AutoSizeGroup(),
              ),
            ],
          ),
          if (_eventToEdit.contentType == 'business') ...[
            SpacingFoundation.verticalSpace24,
            UiKitFieldWithTagList(
              listUiKitTags: _eventToEdit.niche != null ? [UiKitTag(title: _eventToEdit.niche!, icon: '')] : null,
              title: S.of(context).PleaseSelectANiche,
              onTap: () {
                setState(() {
                  widget.onNicheChanged?.call().then((value) {
                    _eventToEdit.niche = value ?? '';
                  });
                });
              },
            ).paddingSymmetric(horizontal: horizontalPadding),
            SpacingFoundation.verticalSpace4,
            UiKitFieldWithTagList(
                listUiKitTags: _eventToEdit.baseTags.isNotEmpty ? _eventToEdit.baseTags : null,
                title: S.of(context).BaseProperties,
                onTap: () async {
                  final newTags = await context.push(TagsSelectionComponent(
                    positionModel: model.positionModel,
                    selectedTags: _eventToEdit.baseTags.map((tag) => tag.title).toList(),
                    title: S.of(context).BaseProperties,
                    allTags: widget.propertiesOptions('base'),
                  ));
                  if (newTags != null) {
                    setState(() {
                      _eventToEdit.baseTags.clear();
                      _eventToEdit.baseTags
                          .addAll((newTags as List<String>).map((e) => UiKitTag(title: e, icon: null)));
                    });
                  }
                }).paddingSymmetric(horizontal: horizontalPadding),
            SpacingFoundation.verticalSpace4,
            UiKitFieldWithTagList(
              listUiKitTags: _eventToEdit.tags.isNotEmpty ? _eventToEdit.tags : null,
              title: S.of(context).UniqueProperties,
              onTap: () async {
                final newTags = await context.push(TagsSelectionComponent(
                  positionModel: model.positionModel,
                  selectedTags: _eventToEdit.tags.map((tag) => tag.title).toList(),
                  title: S.of(context).UniqueProperties,
                  allTags: widget.propertiesOptions('unique'),
                ));
                if (newTags != null) {
                  setState(() {
                    _eventToEdit.tags.clear();
                    _eventToEdit.tags.addAll((newTags as List<String>).map((e) => UiKitTag(title: e, icon: null)));
                  });
                }
              },
            ).paddingSymmetric(horizontal: horizontalPadding),
          ],
          SpacingFoundation.verticalSpace24,
          Text(S.of(context).SetWorkHours, style: theme?.boldTextTheme.title2)
              .paddingSymmetric(horizontal: horizontalPadding),
          SpacingFoundation.verticalSpace16,
          UiKitCustomTabBar(
            tabs: [UiKitCustomTab(height: 20.h, title: 'Single'), UiKitCustomTab(height: 20.h, title: 'Cyclic')],
            onTappedTab: (int index) {
              setState(() {
                switch (index) {
                  case 0:
                    _eventToEdit.isRecurrent = false;
                    break;
                  case 1:
                    _eventToEdit.isRecurrent = true;
                    break;
                }
              });
            },
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
                      availableTypes: const [UiScheduleDatesModel.scheduleType, UiScheduleDatesRangeModel.scheduleType],
                      onScheduleCreated: (model) {
                        if (model is UiScheduleDatesModel) {
                          setState(() {
                            _eventToEdit.schedule = model;
                            _eventToEdit.scheduleString = model.dailySchedule
                                .map((e) => '${e.key}: ${e.value.map((e) => normalizedTi(e)).join('-')}')
                                .join(', ');
                          });
                        } else if (model is UiScheduleDatesRangeModel) {
                          setState(() {
                            _eventToEdit.schedule = model;
                            _eventToEdit.scheduleString = model.dailySchedule
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
          if (_eventToEdit.scheduleString != null) ...[
            SpacingFoundation.verticalSpace24,
            Text(
              _eventToEdit.scheduleString!,
              style: theme?.boldTextTheme.body,
              textAlign: TextAlign.center,
            ).paddingSymmetric(horizontal: horizontalPadding)
          ],
          SpacingFoundation.verticalSpace24,
          SafeArea(
            top: false,
            child: context.gradientButton(
              data: BaseUiKitButtonData(
                text: S.of(context).Save.toUpperCase(),
                fit: ButtonFit.fitWidth,
                onPressed: () {
                  _formKey.currentState?.validate();
                  _eventToEdit.title = _titleController.text;
                  _eventToEdit.description = _descriptionController.text;
                  _eventToEdit.media = [..._photos, ..._videos];
                  _eventToEdit.website = _websiteController.text;
                  _eventToEdit.phone = _phoneController.text;
                  _eventToEdit.price = _priceController.text;
                  widget.onEventCreated.call(_eventToEdit);
                },
              ),
            ),
          ).paddingSymmetric(horizontal: horizontalPadding)
        ],
      ),
    );
  }
}
