import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shuffle_uikit/shuffle_uikit.dart';
import 'package:auto_size_text/auto_size_text.dart';
import '../../../shuffle_components_kit.dart';
import '../../common/photolist_editing_component.dart';
import '../../common/tags_selection_component.dart';

class CreateEventComponent extends StatefulWidget {
  final UiEventModel? eventToEdit;
  final VoidCallback? onEventDeleted;
  final Future Function(UiEventModel) onEventCreated;
  final Future<String?> Function()? getLocation;
  final Future<String?> Function()? onCategoryChanged;
  final Future<List<String>> Function(String, String) propertiesOptions;

  const CreateEventComponent({super.key, this.eventToEdit, this.getLocation, this.onEventDeleted, required this.onEventCreated, this.onCategoryChanged, required this.propertiesOptions});

  @override
  State<CreateEventComponent> createState() => _CreateEventComponentState();
}

class _CreateEventComponentState extends State<CreateEventComponent> {
  late final TextEditingController _titleController = TextEditingController();
  late final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _typeController = TextEditingController();
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
    final config = GlobalComponent.of(context)?.globalConfiguration.appConfig.content ?? GlobalConfiguration().appConfig.content;
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
            hideVideosSelection:true,
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
          //TODO restore editing schedules
          // Row(
          //   children: [
          //     Text(S.of(context).Time, style: theme?.regularTextTheme.labelSmall),
          //     const Spacer(),
          //     Text(
          //       '${_eventToEdit.time == null ? S.of(context).SelectType(S.of(context).Time.toLowerCase()).toLowerCase() : normalizedTi(_eventToEdit.time, showDateName: false)} ${_eventToEdit.timeTo == null ? '' : '- ${normalizedTi(_eventToEdit.timeTo, showDateName: false)} '}',
          //       style: theme?.boldTextTheme.body,
          //     ),
          //     context.outlinedButton(
          //       data: BaseUiKitButtonData(
          //         onPressed: () async {
          //           await showUiKitTimeFromToDialog(context, (from, to) {
          //             setState(() {
          //               _eventToEdit.time = from;
          //               _eventToEdit.timeTo = to;
          //             });
          //           });
          //         },
          //         iconInfo: BaseUiKitButtonIconData(
          //           iconData: ShuffleUiKitIcons.clock,
          //         ),
          //       ),
          //     ),
          //   ],
          // ).paddingSymmetric(horizontal: horizontalPadding),
          SpacingFoundation.verticalSpace24,
          //TODO restore editing schedules
          // Row(
          //   children: [
          //     Text(_eventToEdit.isRecurrent ? S.of(context).DaysOfWeek : S.of(context).Dates,
          //         style: theme?.regularTextTheme.labelSmall),
          //     const Spacer(),
          //     Expanded(
          //         child: Text(
          //             _eventToEdit.isRecurrent
          //                 ? _eventToEdit.weekdays.join(', ')
          //                 : '${_eventToEdit.date == null ? S.of(context).SelectType(S.of(context).Day.toLowerCase()) : DateFormat('MM/dd').format(_eventToEdit.date!)} ${_eventToEdit.dateTo == null ? '' : '- ${DateFormat('MM/dd').format(_eventToEdit.dateTo!)}'}',
          //             style: theme?.boldTextTheme.body)),
          //     context.outlinedButton(
          //       data: BaseUiKitButtonData(
          //         onPressed: _eventToEdit.isRecurrent
          //             ? () async {
          //                 final maybeDaysOfWeek = await showUiKitWeekdaySelector(context);
          //                 if (maybeDaysOfWeek != null) {
          //                   setState(() {
          //                     _eventToEdit.weekdays = maybeDaysOfWeek;
          //                   });
          //                 }
          //               }
          //             : () async {
          //                 await showUiKitCalendarFromToDialog(
          //                     context,
          //                     (from, to) => {
          //                           setState(() {
          //                             _eventToEdit.date = from;
          //                             _eventToEdit.dateTo = to;
          //                           })
          //                         });
          //               },
          //         iconInfo: BaseUiKitButtonIconData(
          //           iconData: ShuffleUiKitIcons.calendar,
          //         ),
          //       ),
          //     ),
          //   ],
          // ).paddingSymmetric(horizontal: horizontalPadding),
          SpacingFoundation.verticalSpace24,
          InkWell(
            onTap: () async {
              // SnackBarUtils.show(
              //     message: 'in development', context: context);

              _locationController.text = await widget.getLocation?.call() ?? '';
              _eventToEdit.location = _locationController.text;
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
          SpacingFoundation.verticalSpace24,
          UiKitInputFieldNoFill(
            keyboardType: TextInputType.text,
            label: S.of(context).Price,
            controller: _priceController,
          ).paddingSymmetric(horizontal: horizontalPadding),
          SpacingFoundation.verticalSpace24,
          UiKitInputFieldNoFill(
            keyboardType: TextInputType.text,
            label: S.of(context).Category,
            controller: _typeController,
            onTap: () {
              widget.onCategoryChanged?.call().then((value) {
                _typeController.text = value ?? '';
                setState(() {
                  _eventToEdit.eventType = value?? '';
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
          // if (_eventToEdit.contentType != 'leisure') ...[
          //   SpacingFoundation.verticalSpace24,
          //   Text(
          //     S.of(context).PleaseSelectANiche,
          //     style: theme?.regularTextTheme.labelSmall,
          //   ).paddingSymmetric(horizontal: horizontalPadding),
          //   SpacingFoundation.verticalSpace4,
          //   UiKitInputFieldNoFill(
          //     keyboardType: TextInputType.text,
          //     label: S.of(context).Niche,
          //     controller: _nicheController,
          //     onTap: () {
          //       widget.onNicheChanged?.call().then((value) {
          //         _nicheController.text = value ?? '';
          //         _placeToEdit.niche = value ?? '';
          //       });
          //     },
          //   ).paddingSymmetric(horizontal: horizontalPadding),
          // ],
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
