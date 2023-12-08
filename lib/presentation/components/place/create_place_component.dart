import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shuffle_uikit/shuffle_uikit.dart';

import '../../../shuffle_components_kit.dart';

class CreatePlaceComponent extends StatefulWidget {
  final UiPlaceModel? placeToEdit;
  final VoidCallback? onPlaceDeleted;
  final Future Function(UiPlaceModel) onPlaceCreated;
  final Future<String?> Function()? getLocation;

  const CreatePlaceComponent({super.key, this.placeToEdit, this.getLocation, this.onPlaceDeleted, required this.onPlaceCreated});

  @override
  State<CreatePlaceComponent> createState() => _CreatePlaceComponentState();
}

class _CreatePlaceComponentState extends State<CreatePlaceComponent> {
  late final TextEditingController _titleController = TextEditingController();
  late final TextEditingController _phoneController = TextEditingController();
  late final TextEditingController _websiteController = TextEditingController();
  late final TextEditingController _locationController = TextEditingController();
  late final TextEditingController _descriptionController = TextEditingController();
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
    _websiteController.text = widget.placeToEdit?.website ?? '';
    _phoneController.text = widget.placeToEdit?.phone ?? '';
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
    final config = GlobalComponent.of(context)?.globalConfiguration.appConfig.content ?? GlobalConfiguration().appConfig.content;
    final ComponentEventModel model = kIsWeb
        ? ComponentEventModel(version: '1', pageBuilderType: PageBuilderType.page)
        : ComponentEventModel.fromJson(config['event_edit']);
    final horizontalPadding = model.positionModel?.horizontalMargin?.toDouble() ?? 0;

    final theme = context.uiKitTheme;

    return Form(
      key: _formKey,
      child: BlurredAppBarPage(
        title: S.of(context).Place,
        centerTitle: true,
        autoImplyLeading: true,
        appBarTrailing: widget.placeToEdit != null
            ? IconButton(
                icon: ImageWidget(
                    iconData: ShuffleUiKitIcons.trash,
                    color: theme?.colorScheme.inversePrimary,
                    height: 20.h,
                    fit: BoxFit.fitHeight),
                onPressed: widget.onPlaceDeleted)
            : null,
        children: [
          UiKitInputFieldNoFill(label: S.of(context).Title, controller: _titleController)
              .paddingSymmetric(horizontal: horizontalPadding),
          SpacingFoundation.verticalSpace24,

          Row(mainAxisAlignment: MainAxisAlignment.end, children: [
            Text(
              S.of(context).Logo,
              style: theme?.regularTextTheme.labelSmall,
            ).paddingOnly(right: horizontalPadding),
            if (_placeToEdit.logo != null) CircularAvatar(height: kIsWeb ? 40 : 40.h, avatarUrl: _placeToEdit.logo!),
            const Spacer(),
            context.outlinedButton(
              data: BaseUiKitButtonData(
                  onPressed: _onLogoAddRequested,
                  icon: ImageWidget(
                    iconData: ShuffleUiKitIcons.cameraplus,
                    color: theme?.colorScheme.inversePrimary,
                    height: 16.h,
                    width: 16.h,
                  )),
            )
          ]).paddingSymmetric(horizontal: horizontalPadding),
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
                label: S.of(context).Description,
                controller: _descriptionController,
                expands: true,
              )).paddingSymmetric(horizontal: horizontalPadding),
          SpacingFoundation.verticalSpace24,
          Row(children: [
            Text(S.of(context).OpenFrom, style: theme?.regularTextTheme.labelSmall),
            const Spacer(),
            Text(
              _placeToEdit.openFrom == null
                  ? S.of(context).SelectType(S.of(context).Time.toLowerCase()).toLowerCase()
                  : normalizedTi(_placeToEdit.openFrom),
              style: theme?.boldTextTheme.body,
            ),
            context.outlinedButton(
              data: BaseUiKitButtonData(
                onPressed: () async {
                  final maybeTime = await showUiKitTimeDialog(context);
                  if (maybeTime != null) {
                    setState(() {
                      _placeToEdit.openFrom = maybeTime;
                    });
                  }
                },
                icon: ImageWidget(
                  iconData: ShuffleUiKitIcons.clock,
                  color: theme?.colorScheme.inversePrimary,
                  height: 16.h,
                  width: 16.h,
                ),
              ),
            ),
          ]).paddingSymmetric(horizontal: horizontalPadding),
          SpacingFoundation.verticalSpace24,
          Row(children: [
            Text(S.of(context).OpenTo, style: theme?.regularTextTheme.labelSmall),
            const Spacer(),
            Text(
              _placeToEdit.openTo == null
                  ? S.of(context).SelectType(S.of(context).Time.toLowerCase()).toLowerCase()
                  : normalizedTi(_placeToEdit.openTo),
              style: theme?.boldTextTheme.body,
            ),
            context.outlinedButton(
              data: BaseUiKitButtonData(
                onPressed: () async {
                  final maybeTime = await showUiKitTimeDialog(context);
                  if (maybeTime != null) {
                    setState(() {
                      _placeToEdit.openTo = maybeTime;
                    });
                  }
                },
                icon: ImageWidget(
                  iconData: ShuffleUiKitIcons.clock,
                  color: theme?.colorScheme.inversePrimary,
                  height: 16.h,
                  width: 16.h,
                ),
              ),
            ),
          ]).paddingSymmetric(horizontal: horizontalPadding),
          SpacingFoundation.verticalSpace24,
          Row(children: [
            Text(S.of(context).DaysOfWeek, style: theme?.regularTextTheme.labelSmall),
            const Spacer(),
            Expanded(
              child: Text(
                _placeToEdit.weekdays.isEmpty
                    ? S.of(context).SelectDays.toLowerCase()
                    : _placeToEdit.weekdays.length == 7
                        ? S.of(context).Daily
                        : _placeToEdit.weekdays.join(', '),
                style: theme?.boldTextTheme.body,
              ),
            ),
            context.outlinedButton(
              data: BaseUiKitButtonData(
                onPressed: () async {
                  final maybeDaysOfWeek = await showUiKitWeekdaySelector(context);
                  if (maybeDaysOfWeek != null) {
                    setState(() {
                      _placeToEdit.weekdays = maybeDaysOfWeek;
                    });
                  }
                },
                icon: ImageWidget(
                  iconData: ShuffleUiKitIcons.calendar,
                  color: theme?.colorScheme.inversePrimary,
                  height: 16.h,
                  width: 16.h,
                ),
              ),
            ),
          ]).paddingSymmetric(horizontal: horizontalPadding),
          SpacingFoundation.verticalSpace24,
          InkWell(
            onTap: () async {
              // SnackBarUtils.show(
              //     message: 'in development', context: context);

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
          SpacingFoundation.verticalSpace24,
          UiKitInputFieldNoFill(keyboardType: TextInputType.url, label: S.of(context).Website, controller: _websiteController)
              .paddingSymmetric(horizontal: horizontalPadding),
          SpacingFoundation.verticalSpace24,
          UiKitInputFieldNoFill(keyboardType: TextInputType.phone, label: S.of(context).Phone, controller: _phoneController)
              .paddingSymmetric(horizontal: horizontalPadding),
          SpacingFoundation.verticalSpace24,
          Text(S.of(context).BaseProperties, style: theme?.regularTextTheme.labelSmall)
              .paddingSymmetric(horizontal: horizontalPadding),
          SpacingFoundation.verticalSpace4,
          UiKitTagSelector(
                  onNotFoundTagCallback: (value) => setState(() => _placeToEdit.baseTags = [
                        ..._placeToEdit.baseTags,
                        UiKitTag(title: value, icon: GraphicsFoundation.instance.iconFromString(''))
                      ]),
                  tags: _placeToEdit.baseTags.map((tag) => tag.title).toList(),
                  onRemoveTagCallback: (value) =>
                      setState(() => _placeToEdit.baseTags.removeWhere((element) => element.title == value)))
              .paddingSymmetric(horizontal: horizontalPadding),
          // UiKitTagsWidget(baseTags: _eventToEdit.baseTags ?? []),
          SpacingFoundation.verticalSpace24,

          Text(S.of(context).UniqueProperties, style: theme?.regularTextTheme.labelSmall)
              .paddingSymmetric(horizontal: horizontalPadding),
          SpacingFoundation.verticalSpace4,
          UiKitTagSelector(
                  onNotFoundTagCallback: (value) => setState(() => _placeToEdit.tags = [
                        ..._placeToEdit.tags,
                        UiKitTag(title: value, icon: GraphicsFoundation.instance.iconFromString(''))
                      ]),
                  tags: _placeToEdit.tags.map((tag) => tag.title).toList(),
                  onRemoveTagCallback: (value) =>
                      setState(() => _placeToEdit.tags.removeWhere((element) => element.title == value)))
              .paddingSymmetric(horizontal: horizontalPadding),
          SpacingFoundation.verticalSpace24,
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
                      }))).paddingSymmetric(horizontal: horizontalPadding)
        ],
      ),
    );
  }
}
