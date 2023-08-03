import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:shuffle_uikit/shuffle_uikit.dart';

import '../../../shuffle_components_kit.dart';
import '../../common/photo_video_selector.dart';

class CreateEventComponent extends StatefulWidget {
  final UiEventModel? eventToEdit;
  final VoidCallback? onEventDeleted;
  final Future Function(UiEventModel) onEventCreated;

  const CreateEventComponent(
      {super.key,
      this.eventToEdit,
      this.onEventDeleted,
      required this.onEventCreated});

  @override
  State<CreateEventComponent> createState() => _CreateEventComponentState();
}

class _CreateEventComponentState extends State<CreateEventComponent> {
  late final TextEditingController _titleController = TextEditingController();
  late final TextEditingController _descriptionController =
      TextEditingController();
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
    _photos.addAll(_eventToEdit.media
            ?.where((element) => element.type == UiKitMediaType.image) ??
        []);
    _videos.addAll(_eventToEdit.media
            ?.where((element) => element.type == UiKitMediaType.video) ??
        []);
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
    final videoFile =
        await ImagePicker().pickVideo(source: ImageSource.gallery);
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
  Widget build(BuildContext context) {
    final config =
        GlobalComponent.of(context)?.globalConfiguration.appConfig.content ??
            GlobalConfiguration().appConfig.content;
    final ComponentEventModel model = kIsWeb ? ComponentEventModel(version: '1',pageBuilderType: PageBuilderType.page):
        ComponentEventModel.fromJson(config['event_edit']);
    final horizontalPadding =
        model.positionModel?.horizontalMargin?.toDouble() ?? 0;

    final theme = context.uiKitTheme;

    return BlurredAppBarPage(
        title: 'Event',
        centerTitle: true,
        autoImplyLeading: true,
        appBarTrailing: widget.onEventDeleted != null
            ? IconButton(
                icon: ImageWidget(
                    svgAsset: GraphicsFoundation.instance.svg.trash,
                    color: Colors.white,
                    height: 20.h,
                    fit: BoxFit.fitHeight),
                onPressed: widget.onEventDeleted)
            : null,
        body: SingleChildScrollView(
            child: Form(
                key: _formKey,
                child: Column(children: [
                  UiKitInputFieldNoFill(
                          label: 'Title', controller: _titleController)
                      .paddingSymmetric(horizontal: horizontalPadding),
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
                    onVideoReorderRequested: _onVideoReorderRequested,
                  ),
                  SpacingFoundation.verticalSpace24,
                  ConstrainedBox(
                      constraints: BoxConstraints(
                          maxHeight: descriptionHeightConstraint),
                      child: UiKitInputFieldNoFill(
                        label: 'Description',
                        controller: _descriptionController,
                        expands: true,
                      )).paddingSymmetric(horizontal: horizontalPadding),
                  SpacingFoundation.verticalSpace24,
                  Theme(
                    data: ThemeData(
                        textButtonTheme: TextButtonThemeData(
                            style:
                                context.uiKitTheme?.textButtonLabelSmallStyle)),
                    child: context
                        .button(
                            reversed: true,
                            isTextButton: true,
                            data: BaseUiKitButtonData(
                                onPressed: () {},
                                text: 'Base properties',
                                icon: DecoratedBox(
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.fromBorderSide(BorderSide(
                                        width: 2, color: Colors.white)),
                                  ),
                                  child: ImageWidget(
                                    svgAsset: GraphicsFoundation
                                        .instance.svg.chevronRight,
                                    color: Colors.white,
                                  ).paddingAll(
                                      SpacingFoundation.verticalSpacing12),
                                )))
                        .paddingSymmetric(horizontal: horizontalPadding),
                  ),
                  UiKitTagsWidget(baseTags: _eventToEdit.baseTags ?? []),
                  SpacingFoundation.verticalSpace24,
                  Theme(
                    data: ThemeData(
                        textButtonTheme: TextButtonThemeData(
                            style:
                                context.uiKitTheme?.textButtonLabelSmallStyle)),
                    child: context
                        .button(
                            reversed: true,
                            isTextButton: true,
                            data: BaseUiKitButtonData(
                                onPressed: () {},
                                text: 'Unique properties',
                                icon: DecoratedBox(
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.fromBorderSide(BorderSide(
                                        width: 2, color: Colors.white)),
                                  ),
                                  child: ImageWidget(
                                    svgAsset: GraphicsFoundation
                                        .instance.svg.chevronRight,
                                    color: Colors.white,
                                  ).paddingAll(
                                      SpacingFoundation.verticalSpacing12),
                                )))
                        .paddingSymmetric(horizontal: horizontalPadding),
                  ),
                  UiKitTagsWidget(
                      baseTags: [], uniqueTags: _eventToEdit.tags ?? []),
                  SpacingFoundation.verticalSpace24,
                  UiKitCustomTabBar(
                      tabs: const [
                        UiKitCustomTab(title: 'Single'),
                        UiKitCustomTab(title: 'Cyclic')
                      ],
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
                      }).paddingSymmetric(horizontal: horizontalPadding),
                  SpacingFoundation.verticalSpace24,
                  Row(children: [
                    Text('Time', style: theme?.regularTextTheme.labelSmall),
                    const Spacer(),
                    Theme(
                      data: ThemeData(
                          textButtonTheme: TextButtonThemeData(
                              style: context.uiKitTheme?.textButtonStyle)),
                      child: context.button(
                          reversed: true,
                          isTextButton: true,
                          data: BaseUiKitButtonData(
                              onPressed: () async {
                                final maybeTime = await showUiKitTimeDialog(context);
                                if (maybeTime!= null) {
                                  setState(() {
                                    _eventToEdit.time = maybeTime;
                                  });
                                }
                              },
                              text:
                                  '${_eventToEdit.time == null ? 'select time' : _eventToEdit.time.toString()}  ',
                              icon: DecoratedBox(
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.fromBorderSide(BorderSide(
                                      width: 2, color: Colors.white)),
                                ),
                                child: ImageWidget(
                                  svgAsset:
                                      GraphicsFoundation.instance.svg.clock,
                                  color: Colors.white,
                                ).paddingAll(
                                    SpacingFoundation.verticalSpacing12),
                              ))),
                    ),
                  ]).paddingSymmetric(horizontal: horizontalPadding),
                  SpacingFoundation.verticalSpace24,
                  Row(children: [
                    Text(_eventToEdit.isRecurrent ? 'Days of week' : 'Date',
                        style: theme?.regularTextTheme.labelSmall),
                    const Spacer(),
                    Theme(
                      data: ThemeData(
                          textButtonTheme: TextButtonThemeData(
                              style: context.uiKitTheme?.textButtonStyle)),
                      child: context.button(
                          reversed: true,
                          isTextButton: true,
                          data: BaseUiKitButtonData(
                              onPressed: () async {
                                final maybeDate = await showUiKitCalendarDialog(context);
                                if (maybeDate!= null) {
                                  setState(() {
                                    _eventToEdit.date = maybeDate;
                                  });
                                }
                              },
                              text:
                                  '${_eventToEdit.date == null ? 'select day' : DateFormat('MM/dd').format(_eventToEdit.date!)}  ',
                              icon: DecoratedBox(
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.fromBorderSide(BorderSide(
                                      width: 2, color: Colors.white)),
                                ),
                                child: ImageWidget(
                                  svgAsset:
                                      GraphicsFoundation.instance.svg.calendar,
                                  color: Colors.white,
                                ).paddingAll(
                                    SpacingFoundation.verticalSpacing12),
                              ))),
                    ),
                  ]).paddingSymmetric(horizontal: horizontalPadding),
                  SpacingFoundation.verticalSpace24,
                  SafeArea(
                      top: false,
                      child: context.gradientButton(
                          data: BaseUiKitButtonData(
                              text: 'save'.toUpperCase(),
                              onPressed: () {
                                _eventToEdit.title = _titleController.text;
                                _eventToEdit.description =
                                    _descriptionController.text;
                                _eventToEdit.media = [..._photos, ..._videos];
                                widget.onEventCreated(_eventToEdit);
                              }))).paddingSymmetric(
                      horizontal: horizontalPadding)
                ]))));
  }
}
