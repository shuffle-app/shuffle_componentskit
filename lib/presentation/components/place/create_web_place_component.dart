import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shuffle_uikit/shuffle_uikit.dart';

import '../../../shuffle_components_kit.dart';

part 'web_form_field.dart';

class CreateWebPlaceComponent extends StatefulWidget {
  final UiPlaceModel? placeToEdit;
  final VoidCallback? onPlaceDeleted;
  final Future Function(UiPlaceModel) onPlaceCreated;
  final Future<String?> Function()? getLocation;

  const CreateWebPlaceComponent({
    super.key,
    this.placeToEdit,
    this.getLocation,
    this.onPlaceDeleted,
    required this.onPlaceCreated,
  });

  @override
  State<CreateWebPlaceComponent> createState() => _CreateWebPlaceComponentState();
}

class _CreateWebPlaceComponentState extends State<CreateWebPlaceComponent> {
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
    final config =
        GlobalComponent.of(context)?.globalConfiguration.appConfig.content ?? GlobalConfiguration().appConfig.content;
    final ComponentEventModel model = kIsWeb
        ? ComponentEventModel(version: '1', pageBuilderType: PageBuilderType.page)
        : ComponentEventModel.fromJson(config['event_edit']);
    final horizontalPadding = model.positionModel?.horizontalMargin?.toDouble() ?? 0;

    final theme = context.uiKitTheme;

    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(
        horizontal: EdgeInsetsFoundation.horizontal32,
        vertical: EdgeInsetsFoundation.vertical24,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Create place', style: theme?.boldTextTheme.title2),
          SpacingFoundation.verticalSpace24,
          Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 2,
                child: Column(
                  children: [
                    WebFormField(
                      title: 'Place type',
                      isRequired: true,
                      child: UiKitInputFieldNoIcon(
                        controller: TextEditingController(),
                        hintText: 'Enter name',
                        fillColor: theme?.colorScheme.surface3,
                        borderRadius: BorderRadiusFoundation.all12,
                      ),
                    ),
                    SpacingFoundation.verticalSpace24,
                    WebFormField(
                      title: 'Base properties',
                      isRequired: true,
                      child: UiKitInputFieldNoIcon(
                        controller: TextEditingController(),
                        hintText: 'Enter name',
                        fillColor: theme?.colorScheme.surface3,
                        borderRadius: BorderRadiusFoundation.all12,
                      ),
                    ),
                    SpacingFoundation.verticalSpace24,
                    WebFormField(
                      title: 'Unique properties',
                      isRequired: true,
                      child: UiKitInputFieldNoIcon(
                        controller: TextEditingController(),
                        hintText: 'Enter name',
                        fillColor: theme?.colorScheme.surface3,
                        borderRadius: BorderRadiusFoundation.all12,
                      ),
                    ),
                    SpacingFoundation.verticalSpace24,
                    WebFormField(
                      title: 'Logo (upload files)',
                      child: UiKitInputFieldNoIcon(
                        controller: TextEditingController(),
                        hintText: 'Enter name',
                        fillColor: theme?.colorScheme.surface3,
                        borderRadius: BorderRadiusFoundation.all12,
                      ),
                    ),
                    SpacingFoundation.verticalSpace24,
                  ],
                ),
              ),
              SpacingFoundation.horizontalSpace24,
              SizedBox(
                width: 1,
                height: 1500.h,
                child: ColoredBox(color: theme!.colorScheme.darkNeutral900),
              ),
              SpacingFoundation.horizontalSpace24,
              Expanded(
                flex: 3,
                child: Column(
                  children: [
                    WebFormField(
                      title: 'Name',
                      isRequired: true,
                      child: UiKitInputFieldNoIcon(
                        controller: TextEditingController(),
                        hintText: 'Enter name',
                        fillColor: theme.colorScheme.surface3,
                        borderRadius: BorderRadiusFoundation.all12,
                      ),
                    ),
                    SpacingFoundation.verticalSpace24,
                    WebFormField(
                      title: 'Opening hours',
                      isRequired: true,
                      child: UiKitTitledDescriptionWithDivider(
                        direction: Axis.horizontal,
                        title: '',
                        description: [
                          TimeOfDay.now().format(context),
                          const TimeOfDay(hour: 17, minute: 49).format(context),
                        ],
                      ),
                    ),
                    SpacingFoundation.verticalSpace24,
                    WebFormField(
                      title: 'Description',
                      child: UiKitInputFieldNoIcon(
                        controller: TextEditingController(),
                        minLines: 4,
                        hintText: 'Enter name',
                        fillColor: theme.colorScheme.surface3,
                        borderRadius: BorderRadiusFoundation.all12,
                      ),
                    ),
                    SpacingFoundation.verticalSpace24,
                    WebFormField(
                      title: 'Address',
                      isRequired: true,
                      child: UiKitInputFieldNoIcon(
                        controller: TextEditingController(),
                        hintText: 'Enter address',
                        fillColor: theme.colorScheme.surface3,
                        borderRadius: BorderRadiusFoundation.all12,
                      ),
                    ),
                    SpacingFoundation.verticalSpace24,
                    WebFormField(
                      title: 'Website',
                      child: UiKitInputFieldNoIcon(
                        controller: TextEditingController(),
                        hintText: 'Enter website',
                        fillColor: theme.colorScheme.surface3,
                        borderRadius: BorderRadiusFoundation.all12,
                      ),
                    ),
                    SpacingFoundation.verticalSpace24,
                    SizedBox(
                      height: 1,
                      width: double.infinity,
                      child: ColoredBox(color: theme.colorScheme.darkNeutral900),
                    ),
                    SpacingFoundation.verticalSpace24,
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Contact Person', style: theme.boldTextTheme.title2),
                        SpacingFoundation.verticalSpace24,
                        WebFormField(
                          title: 'Name',
                          child: UiKitInputFieldNoIcon(
                            controller: TextEditingController(),
                            hintText: 'Enter name',
                            fillColor: theme.colorScheme.surface3,
                            borderRadius: BorderRadiusFoundation.all12,
                          ),
                        ),
                        SpacingFoundation.verticalSpace24,
                        WebFormField(
                          title: 'Position',
                          child: UiKitInputFieldNoIcon(
                            controller: TextEditingController(),
                            hintText: 'Enter position',
                            fillColor: theme.colorScheme.surface3,
                            borderRadius: BorderRadiusFoundation.all12,
                          ),
                        ),
                        SpacingFoundation.verticalSpace24,
                        WebFormField(
                          title: 'Phone',
                          child: UiKitInputFieldNoIcon(
                            controller: TextEditingController(),
                            hintText: 'Enter phone',
                            fillColor: theme.colorScheme.surface3,
                            borderRadius: BorderRadiusFoundation.all12,
                          ),
                        ),
                        SpacingFoundation.verticalSpace24,
                        WebFormField(
                          title: 'Email',
                          child: UiKitInputFieldNoIcon(
                            controller: TextEditingController(),
                            hintText: 'Enter email',
                            fillColor: theme.colorScheme.surface3,
                            borderRadius: BorderRadiusFoundation.all12,
                          ),
                        ),
                        SpacingFoundation.verticalSpace24,
                        Wrap(
                          children: [
                            context.gradientButton(
                              data: BaseUiKitButtonData(text: 'save', onPressed: () {}, fit: ButtonFit.fitWidth),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
