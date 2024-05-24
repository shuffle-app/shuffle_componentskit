import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shuffle_uikit/shuffle_uikit.dart';
import 'package:auto_size_text/auto_size_text.dart';
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
  final Future<List<String>> Function(String, String) propertiesOptions;
  final List<UiScheduleModel> availableTimeTemplates;
  final ValueChanged<UiScheduleModel>? onTimeTemplateCreated;

  const CreateEventComponent(
      {super.key,
      this.eventToEdit,
      this.getLocation,
      this.onEventDeleted,
      required this.onEventCreated,
      this.onCategoryChanged,
      this.onNicheChanged,
      required this.propertiesOptions,
      required this.availableTimeTemplates,
      this.onTimeTemplateCreated});

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
  final TextEditingController _nicheController = TextEditingController();
  late final GlobalKey _formKey = GlobalKey<FormState>();

  late UiEventModel _eventToEdit;

  double descriptionHeightConstraint = 50.h;
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
    _descriptionController.addListener(_checkDescriptionHeightConstraint);
    _websiteController.text = widget.eventToEdit?.website ?? '';
    _phoneController.text = widget.eventToEdit?.phone ?? '';
    _nicheController.text = widget.eventToEdit?.niche ?? '';
  }

  _checkDescriptionHeightConstraint() {
    if (_descriptionController.text.length * 5.8.w / (kIsWeb ? 390 : 0.9.sw) > descriptionHeightConstraint / 50.h) {
      setState(() {
        descriptionHeightConstraint += 30.h;
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
      _nicheController.text = widget.eventToEdit?.niche ?? '';
      _photos.clear();
      _videos.clear();
      _photos.addAll(_eventToEdit.media.where((element) => element.type == UiKitMediaType.image));
      _videos.addAll(_eventToEdit.media.where((element) => element.type == UiKitMediaType.video));
      _descriptionController.addListener(_checkDescriptionHeightConstraint);
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
          ConstrainedBox(
            constraints: BoxConstraints(maxHeight: descriptionHeightConstraint),
            child: UiKitInputFieldNoFill(
              label: S.of(context).Description,
              controller: _descriptionController,
              expands: true,
            ),
          ).paddingSymmetric(horizontal: horizontalPadding),
          SpacingFoundation.verticalSpace24,
          UiKitCustomTabBar(
            tabs: const [UiKitCustomTab(title: 'Single'), UiKitCustomTab(title: 'Cyclic')],
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
            )
          ],

          SpacingFoundation.verticalSpace24,
          InkWell(
            onTap: () async {
              _locationController.text = await widget.getLocation?.call() ?? '';
              _eventToEdit.location = _locationController.text;

              FocusManager.instance.primaryFocus?.unfocus();
            },
            child: IgnorePointer(
              child: UiKitInputFieldNoFill(
                label: S.of(context).Address,
                controller: _locationController,
                icon: ImageWidget(
                  iconData: ShuffleUiKitIcons.landmark,
                  color: theme?.colorScheme.inversePrimary,
                ),
              ).paddingSymmetric(horizontal: horizontalPadding),
            ),
          ),
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
                context.push(PriceSelectorComponent(
                  initialPrice1: _priceController.text.split('-').first,
                  initialPrice2: _priceController.text.contains('-') ? _priceController.text.split('-').last : null,
                  initialCurrency: _eventToEdit.currency,
                  onSubmit: (price1, price2, currency) {
                    setState(() {
                      _priceController.text = price1;
                      if (price2.isNotEmpty) {
                        _priceController.text += '-$price2';
                      }
                      _eventToEdit.currency = currency;
                    });

                    FocusManager.instance.primaryFocus?.unfocus();
                  },
                ));
              }).paddingSymmetric(horizontal: horizontalPadding),
          SpacingFoundation.verticalSpace24,
          UiKitInputFieldNoFill(
            keyboardType: TextInputType.text,
            label: S.of(context).EventType,
            controller: _typeController,
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
                _eventToEdit.contentType = ['leisure', 'business', 'both'][index];
              });
            },
            tabs: [
              UiKitCustomTab(
                title: S.of(context).Leisure,
                customValue: 'leisure',
                group: contentSelectionGroup,
              ),
              UiKitCustomTab(title: S.of(context).Business, customValue: 'business', group: contentSelectionGroup),
              UiKitCustomTab(title: S.of(context).Both, customValue: 'both', group: contentSelectionGroup),
            ],
          ),
          if (_eventToEdit.contentType != 'leisure') ...[
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
                  _eventToEdit.niche = value ?? '';
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
                  tags: _eventToEdit.baseTags.map((tag) => tag.title).toList(),
                  title: S.of(context).BaseProperties,
                  options: (String v) => widget.propertiesOptions(v, 'base'),
                ));
                log('here we have baseTags $newTags');
                if (newTags != null) {
                  setState(() {
                    _eventToEdit.baseTags.clear();
                    _eventToEdit.baseTags.addAll((newTags as List<String>).map((e) => UiKitTag(title: e, icon: null)));
                  });
                }
              },
              child: IgnorePointer(
                  child: UiKitTagSelector(
                showTextField: false,
                tags: _eventToEdit.baseTags.map((tag) => tag.title).toList(),
              )).paddingSymmetric(horizontal: horizontalPadding)),
          SpacingFoundation.verticalSpace24,
          if (_eventToEdit.eventType != null && _eventToEdit.eventType!.isNotEmpty) ...[
            Text(S.of(context).UniqueProperties, style: theme?.regularTextTheme.labelSmall)
                .paddingSymmetric(horizontal: horizontalPadding),
            SpacingFoundation.verticalSpace4,
            GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: () async {
                  final newTags = await context.push(TagsSelectionComponent(
                    positionModel: model.positionModel,
                    tags: _eventToEdit.tags.map((tag) => tag.title).toList(),
                    title: S.of(context).UniqueProperties,
                    options: (String v) => widget.propertiesOptions(v, 'unique'),
                  ));
                  log('here we have uniqueTags $newTags');
                  if (newTags != null) {
                    setState(() {
                      _eventToEdit.tags.clear();
                      _eventToEdit.tags.addAll((newTags as List<String>).map((e) => UiKitTag(title: e, icon: null)));
                    });
                  }
                },
                child: IgnorePointer(
                    child: UiKitTagSelector(
                  showTextField: false,
                  tags: _eventToEdit.tags.map((tag) => tag.title).toList(),
                )).paddingSymmetric(horizontal: horizontalPadding)),
            SpacingFoundation.verticalSpace24,
          ],
          SafeArea(
            top: false,
            child: context.gradientButton(
              data: BaseUiKitButtonData(
                text: S.of(context).Save.toUpperCase(),
                fit: ButtonFit.fitWidth,
                onPressed: () {
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
