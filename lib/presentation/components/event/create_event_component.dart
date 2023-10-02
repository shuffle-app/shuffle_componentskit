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

  const CreateEventComponent({super.key, this.eventToEdit, this.onEventDeleted, required this.onEventCreated});

  @override
  State<CreateEventComponent> createState() => _CreateEventComponentState();
}

class _CreateEventComponentState extends State<CreateEventComponent> {
  late final TextEditingController _titleController = TextEditingController();
  late final TextEditingController _descriptionController = TextEditingController();
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
    _photos.addAll(_eventToEdit.media?.where((element) => element.type == UiKitMediaType.image) ?? []);
    _videos.addAll(_eventToEdit.media?.where((element) => element.type == UiKitMediaType.video) ?? []);
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
    final files = await ImagePicker().pickMultiImage();
    if (files.isNotEmpty) {
      setState(() {
        _photos.addAll(files.map((file) => UiKitMediaPhoto(link: file.path)));
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
    final horizontalPadding = model.positionModel?.horizontalMargin?.toDouble() ?? 0;

    final theme = context.uiKitTheme;

    return BlurredAppBarPage(
        title: 'Event',
        centerTitle: true,
        autoImplyLeading: true,
        appBarTrailing: widget.eventToEdit != null
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
                child: Column(
                    mainAxisAlignment: (model.positionModel?.bodyAlignment).mainAxisAlignment,
                    crossAxisAlignment: (model.positionModel?.bodyAlignment).crossAxisAlignment,
                    children: [
                      UiKitInputFieldNoFill(label: 'Title', controller: _titleController)
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
                          constraints: BoxConstraints(maxHeight: descriptionHeightConstraint),
                          child: UiKitInputFieldNoFill(
                            label: 'Description',
                            controller: _descriptionController,
                            expands: true,
                          )).paddingSymmetric(horizontal: horizontalPadding),
                      SpacingFoundation.verticalSpace24,

                      Text('Base properties', style: theme?.regularTextTheme.labelSmall)
                          .paddingSymmetric(horizontal: horizontalPadding),
                      SpacingFoundation.verticalSpace4,
                      UiKitTagSelector(
                              onNotFoundTagCallback: (value) => setState(() => _eventToEdit.baseTags = [
                                    ..._eventToEdit.baseTags,
                                    UiKitTag(title: value, iconPath: '')
                                  ]),
                              tags: _eventToEdit.baseTags.map((tag) => tag.title).toList(),
                              onRemoveTagCallback: (value) => setState(
                                  () => _eventToEdit.baseTags.removeWhere((element) => element.title == value)))
                          .paddingSymmetric(horizontal: horizontalPadding),
                      // UiKitTagsWidget(baseTags: _eventToEdit.baseTags ?? []),
                      SpacingFoundation.verticalSpace24,

                      Text('Unique properties', style: theme?.regularTextTheme.labelSmall)
                          .paddingSymmetric(horizontal: horizontalPadding),
                      SpacingFoundation.verticalSpace4,
                      UiKitTagSelector(
                              onNotFoundTagCallback: (value) => setState(() =>
                                  _eventToEdit.tags = [..._eventToEdit.tags, UiKitTag(title: value, iconPath: '')]),
                              tags: _eventToEdit.tags.map((tag) => tag.title).toList(),
                              onRemoveTagCallback: (value) =>
                                  setState(() => _eventToEdit.tags.removeWhere((element) => element.title == value)))
                          .paddingSymmetric(horizontal: horizontalPadding),
                      // UiKitTagsWidget(
                      //     baseTags: [], uniqueTags: _eventToEdit.tags ?? []),
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
                          }).paddingSymmetric(horizontal: horizontalPadding),
                      SpacingFoundation.verticalSpace24,
                      Row(children: [
                        Text('Time', style: theme?.regularTextTheme.labelSmall),
                        const Spacer(),
                        Text(
                            '${_eventToEdit.time == null ? 'select time' : '${normalizedTi(_eventToEdit.time,showDateName: false)}'} ${_eventToEdit.timeTo == null ? '' : '- ${normalizedTi(_eventToEdit.timeTo,showDateName: false)} '}',
                            style: theme?.boldTextTheme.body),
                        context.outlinedButton(
                            data: BaseUiKitButtonData(
                                onPressed: () async {
                                   await showUiKitTimeFromToDialog(context,(from,to){
                                    setState(() {
                                      _eventToEdit.time = from;
                                      _eventToEdit.timeTo = to;
                                    });
                                  });
                                },
                                icon: ImageWidget(
                                  svgAsset: GraphicsFoundation.instance.svg.clock,
                                  color: Colors.white,
                                ))),
                      ]).paddingSymmetric(horizontal: horizontalPadding),
                      SpacingFoundation.verticalSpace24,
                      Row(children: [
                        Text(_eventToEdit.isRecurrent ? 'Days of week' : 'Dates',
                            style: theme?.regularTextTheme.labelSmall),
                        const Spacer(),
                        Expanded(
                            child: Text(
                                _eventToEdit.isRecurrent
                                    ? _eventToEdit.weekdays.join(', ')
                                    : '${_eventToEdit.date == null ? 'select day' : DateFormat('MM/dd').format(_eventToEdit.date!)} ${_eventToEdit.dateTo == null ? '' : '- ${DateFormat('MM/dd').format(_eventToEdit.dateTo!) }'}',
                                style: theme?.boldTextTheme.body)),
                        context.outlinedButton(
                            data: BaseUiKitButtonData(
                                onPressed: _eventToEdit.isRecurrent
                                    ? () async {
                                        final maybeDaysOfWeek = await showUiKitWeekdaySelector(context);
                                        if (maybeDaysOfWeek != null) {
                                          setState(() {
                                            _eventToEdit.weekdays = maybeDaysOfWeek;
                                          });
                                        }
                                      }
                                    : () async {
                                         await showUiKitCalendarFromToDialog(context, (from, to) => {
                                           setState(() {
                                             _eventToEdit.date = from;
                                             _eventToEdit.dateTo = to;
                                           })
                                         });

                                      },
                                icon: ImageWidget(
                                  svgAsset: GraphicsFoundation.instance.svg.calendar,
                                  color: Colors.white,
                                ))),
                      ]).paddingSymmetric(horizontal: horizontalPadding),
                      SpacingFoundation.verticalSpace24,
                      SafeArea(
                          top: false,
                          child: context.gradientButton(
                              data: BaseUiKitButtonData(
                                  text: 'save'.toUpperCase(),
                                  fit: ButtonFit.fitWidth,
                                  onPressed: () {
                                    _eventToEdit.title = _titleController.text;
                                    _eventToEdit.description = _descriptionController.text;
                                    _eventToEdit.media = [..._photos, ..._videos];
                                    widget.onEventCreated.call(_eventToEdit);
                                  }))).paddingSymmetric(horizontal: horizontalPadding)
                    ]))));
  }
}
