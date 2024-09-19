import 'dart:math';

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

class CreateEventComponent extends StatefulWidget {
  final UiEventModel? eventToEdit;
  final VoidCallback? onEventDeleted;
  final Future Function(UiEventModel) onEventCreated;
  final Future<String?> Function()? getLocation;
  final Future<UiKitTag?> Function(String?)? onCategoryChanged;
  final Future<UiKitTag?> Function()? onNicheChanged;
  final List<UiKitTag> Function(String) propertiesOptions;
  final List<UiScheduleModel> availableTimeTemplates;
  final ValueChanged<UiScheduleModel>? onTimeTemplateCreated;
  final bool Function(BookingUiModel)? onBookingTap;

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
    this.onBookingTap,
  });

  @override
  State<CreateEventComponent> createState() => _CreateEventComponentState();
}

class _CreateEventComponentState extends State<CreateEventComponent> {
  late final TextEditingController _titleController = TextEditingController();
  late final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _websiteController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _upsalesController = TextEditingController();
  late final TextEditingController _bookingUrlController = TextEditingController();
  late final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late final GlobalKey<ReorderableListState> _reordablePhotokey = GlobalKey<ReorderableListState>();
  late final GlobalKey<ReorderableListState> _reordableVideokey = GlobalKey<ReorderableListState>();

  late UiEventModel _eventToEdit;
  late BookingUiModel? _bookingUiModel;

  final List<BaseUiKitMedia> _videos = [];
  final List<BaseUiKitMedia> _photos = [];

  late bool _upsalesSwitcher;

  @override
  void initState() {
    super.initState();
    _bookingUrlController.text = widget.eventToEdit?.bookingUrl ?? '';
    _upsalesSwitcher = widget.eventToEdit?.upsalesItems?.isNotEmpty ?? false;
    _titleController.text = widget.eventToEdit?.title ?? '';
    _descriptionController.text = widget.eventToEdit?.description ?? '';
    _eventToEdit = widget.eventToEdit ?? UiEventModel(id: -1);
    _locationController.text = widget.eventToEdit?.location ?? '';
    _priceController.text = widget.eventToEdit?.price ?? '';
    _photos.addAll(_eventToEdit.media.where((element) => element.type == UiKitMediaType.image));
    if (_eventToEdit.verticalPreview != null &&
        //in case that if event has not verticalPreview and we put there horizontal or just first image
        !_photos.map((e) => e.link).contains(_eventToEdit.verticalPreview!.link)) {
      _photos.add(_eventToEdit.verticalPreview!);
    }
    _videos.addAll(_eventToEdit.media.where((element) => element.type == UiKitMediaType.video));
    _websiteController.text = widget.eventToEdit?.website ?? '';
    _phoneController.text = widget.eventToEdit?.phone ?? '';
    _upsalesController.text = widget.eventToEdit?.upsalesItems?.join(', ') ?? '';
    _bookingUiModel = widget.eventToEdit?.bookingUiModel;
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
  void didUpdateWidget(covariant CreateEventComponent oldWidget) {
    if (oldWidget.eventToEdit != widget.eventToEdit) {
      _bookingUrlController.text = widget.eventToEdit?.bookingUrl ?? '';
      _upsalesController.text = widget.eventToEdit?.upsalesItems?.join(', ') ?? '';
      _upsalesSwitcher = widget.eventToEdit?.upsalesItems?.isNotEmpty ?? false;
      _titleController.text = widget.eventToEdit?.title ?? '';
      _descriptionController.text = widget.eventToEdit?.description ?? '';
      _eventToEdit = widget.eventToEdit ?? UiEventModel(id: -1);
      _locationController.text = widget.eventToEdit?.location ?? '';
      _priceController.text = widget.eventToEdit?.price ?? '';
      _websiteController.text = widget.eventToEdit?.website ?? '';
      _phoneController.text = widget.eventToEdit?.phone ?? '';
      _photos.clear();
      _videos.clear();
      _photos.addAll(_eventToEdit.media.where((element) => element.type == UiKitMediaType.image));
      if (_eventToEdit.verticalPreview != null &&
          //in case that if event has not verticalPreview and we put there horizontal or just first image
          !_photos.map((e) => e.link).contains(_eventToEdit.verticalPreview!.link)) {
        _photos.add(_eventToEdit.verticalPreview!);
      }
      _videos.addAll(_eventToEdit.media.where((element) => element.type == UiKitMediaType.video));
      _bookingUiModel = widget.eventToEdit?.bookingUiModel;
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

    final tagTextStyle = context.uiKitTheme?.boldTextTheme.caption2Bold.copyWith(
      color: ColorsFoundation.darkNeutral500,
    );

    return Form(
      key: _formKey,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: BlurredAppBarPage(
        title: S.of(context).Event,
        onIWidgetInfoString: S.current.ContentQualityNotice,
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
            hintText: 'Event name',
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
            listPhotosKey: _reordablePhotokey,
            listVideosKey: _reordableVideokey
          ),
          SpacingFoundation.verticalSpace24,
          IntrinsicHeight(
            child: UiKitInputFieldNoFill(
              label: S.of(context).Description,
              hintText: 'Something amazing about your event',
              controller: _descriptionController,
              textInputAction: TextInputAction.newline,
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
            prefixText: 'https://',
            keyboardType: TextInputType.url,
            hintText: 'coolevent.com',
            label: S.of(context).Website,
            controller: _websiteController,
            validator: websiteValidator,
          ).paddingSymmetric(horizontal: horizontalPadding),
          SpacingFoundation.verticalSpace24,
          UiKitInputFieldNoFill(
            prefixText: '+',
            keyboardType: TextInputType.phone,
            inputFormatters: [americanInputFormatter],
            label: S.of(context).Phone,
            controller: _phoneController,
            validator: phoneNumberValidator,
          ).paddingSymmetric(horizontal: horizontalPadding),
          SpacingFoundation.verticalSpace24,
          UiKitFieldWithTagList(
            listUiKitTags: [
              UiKitTag(
                updateTitle: false,
                title:
                    _priceController.text.isNotEmpty ? '${_eventToEdit.currency ?? ''} ${_priceController.text}' : '0',
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
                    initialCurrency: _eventToEdit.currency,
                    onSubmit: (averagePrice, rangePrice1, rangePrice2, currency, averageSelected) {
                      setState(() {
                        if (averageSelected) {
                          _priceController.text = averagePrice;
                        } else {
                          if (rangePrice2.isNotEmpty && rangePrice1.isNotEmpty) {
                            _priceController.text = '$rangePrice1-$rangePrice2';
                          } else {
                            _priceController.text = rangePrice1;
                          }
                        }
                        _eventToEdit.currency = currency;
                      });
                    },
                  ),
                ),
              );
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
                group: _tabsGroup,
              ),
              UiKitCustomTab(
                height: 20.h,
                title: S.of(context).Leisure,
                customValue: 'leisure',
                group: _tabsGroup,
              ),
              UiKitCustomTab(
                height: 20.h,
                title: S.of(context).Business,
                customValue: 'business',
                group: _tabsGroup,
              ),
            ],
          ),
          SpacingFoundation.verticalSpace24,
          UiKitFieldWithTagList(
            title: S.of(context).EventType,
            listUiKitTags: [_eventToEdit.eventType ?? UiKitTag(title: '', icon: '')],
            onTap: () {
              widget.onCategoryChanged?.call(_eventToEdit.contentType).then((value) {
                setState(() {
                  _eventToEdit.eventType = value;
                });
              });
            },
          ).paddingSymmetric(horizontal: horizontalPadding),
          SpacingFoundation.verticalSpace24,
          if (_eventToEdit.contentType == 'business') ...[
            UiKitFieldWithTagList(
              listUiKitTags: _eventToEdit.niche != null ? [_eventToEdit.niche ?? UiKitTag(title: '', icon: '')] : null,
              title: S.of(context).PleaseSelectANiche,
              onTap: () {
                widget.onNicheChanged?.call().then((value) {
                  setState(() {
                    _eventToEdit.niche = value;
                  });
                });
              },
            ).paddingSymmetric(horizontal: horizontalPadding),
            SpacingFoundation.verticalSpace24
          ],
          UiKitFieldWithTagList(
              listUiKitTags: _eventToEdit.baseTags.isNotEmpty ? _eventToEdit.baseTags : null,
              title: S.of(context).BaseProperties,
              onTap: () async {
                final newTags = await context.push(TagsSelectionComponent(
                  positionModel: model.positionModel,
                  selectedTags: _eventToEdit.baseTags,
                  title: S.of(context).BaseProperties,
                  allTags: widget.propertiesOptions('base'),
                ));
                if (newTags != null) {
                  setState(() {
                    _eventToEdit.baseTags.clear();
                    _eventToEdit.baseTags.addAll(newTags);
                  });
                }
              }).paddingSymmetric(horizontal: horizontalPadding),
          SpacingFoundation.verticalSpace24,
          if (_eventToEdit.eventType != null && _eventToEdit.eventType!.title.isNotEmpty) ...[
            UiKitFieldWithTagList(
              listUiKitTags: _eventToEdit.tags.isNotEmpty ? _eventToEdit.tags : null,
              title: S.of(context).UniqueProperties,
              onTap: () async {
                final newTags = await context.push(TagsSelectionComponent(
                  positionModel: model.positionModel,
                  selectedTags: _eventToEdit.tags,
                  title: S.of(context).UniqueProperties,
                  allTags: widget.propertiesOptions('unique'),
                ));
                if (newTags != null) {
                  setState(() {
                    _eventToEdit.tags.clear();
                    _eventToEdit.tags.addAll(newTags);
                  });
                }
              },
            ).paddingSymmetric(horizontal: horizontalPadding),
            SpacingFoundation.verticalSpace24,
          ],
          Row(
            children: [
              Expanded(
                child: Text(
                  S.of(context).UpsalesAvailable,
                  style: theme?.regularTextTheme.labelSmall,
                ),
              ),
              const Spacer(),
              UiKitGradientSwitch(
                onChanged: (value) {
                  setState(() {
                    _upsalesSwitcher = !_upsalesSwitcher;
                  });
                },
                switchedOn: _upsalesSwitcher,
              ),
            ],
          ).paddingSymmetric(horizontal: horizontalPadding),
          if (_upsalesSwitcher) ...[
            SpacingFoundation.verticalSpace24,
            UiKitInputFieldNoFill(
              label: S.of(context).Upsales,
              maxSymbols: 25,
              validator: upsalesValidator,
              controller: _upsalesController,
              hintText: S.of(context).UpsalesAvailableHint,
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
          context
              .button(
                data: BaseUiKitButtonData(
                  fit: ButtonFit.fitWidth,
                  autoSizeGroup: AutoSizeGroup(),
                  text: _bookingUiModel == null && (_eventToEdit.bookingUrl ?? '').isEmpty
                      ? S.of(context).CreateBooking
                      : '${S.of(context).Edit} ${S.of(context).Booking}',
                  onPressed: () {
                    _bookingUiModel ??= BookingUiModel(id: -1);

                    showUiKitGeneralFullScreenDialog(
                      context,
                      GeneralDialogData(
                        isWidgetScrollable: true,
                        topPadding: 1.sw <= 380 ? 0.40.sh : 0.59.sh,
                        child: SelectBookingLinkComponent(
                          onExternalTap: () {
                            context.pop();
                            showUiKitGeneralFullScreenDialog(
                              context,
                              GeneralDialogData(
                                isWidgetScrollable: true,
                                topPadding: 1.sw <= 380 ? 0.50.sh : 0.65.sh,
                                child: AddLinkComponent(
                                  onSave: () {
                                    _eventToEdit.bookingUrl = _bookingUrlController.text;
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
                              CreateBookingComponent(
                                bookingUiModel: _bookingUiModel,
                                onBookingCreated: (bookingUiModel) {
                                  if (widget.onBookingTap?.call(bookingUiModel) ?? false) {
                                    _bookingUiModel = bookingUiModel;
                                    setState(() {
                                      _eventToEdit.bookingUrl = null;
                                    });
                                  }
                                },
                              ),
                            );
                          },
                        ),
                      ),
                    );
                  },
                ),
              )
              .paddingSymmetric(horizontal: horizontalPadding),
          if (_eventToEdit.bookingUrl != null && _eventToEdit.bookingUrl!.isNotEmpty) ...[
            SpacingFoundation.verticalSpace10,
            Text(
              _eventToEdit.bookingUrl!,
              style: tagTextStyle,
            )
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
                  _eventToEdit.price = _priceController.text.replaceAll(' ', '');
                  _eventToEdit.bookingUiModel = _bookingUiModel;
                  _eventToEdit.upsalesItems = _upsalesSwitcher
                      ? (_upsalesController.text.isNotEmpty
                          ? _upsalesController.text.split(',').map((e) => e.trim()).toList()
                          : null)
                      : null;
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

AutoSizeGroup _tabsGroup = AutoSizeGroup();
