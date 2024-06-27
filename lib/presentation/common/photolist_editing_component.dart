// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shuffle_uikit/shuffle_uikit.dart';

import '../../data/position/position_model.dart';

class PhotoListEditingComponent extends StatefulWidget {
  final List<BaseUiKitMedia> photos;
  final PositionModel? positionModel;

  const PhotoListEditingComponent({super.key, required this.photos, this.positionModel});

  @override
  State<PhotoListEditingComponent> createState() => _PhotoListEditingComponentState();
}

class _PhotoListEditingComponentState extends State<PhotoListEditingComponent> {
  final List<BaseUiKitMedia> _photos = [];
  late final Directory tempDir;

  List<BaseUiKitMedia> get mediaWithoutPreviews => _photos.where((element) => element.previewType == null).toList();

  @override
  void initState() {
    _photos.addAll(widget.photos);
    getTemporaryDirectory().then((value) => tempDir = value);
    super.initState();
    if (_photos.isEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        onPhotoAddRequested();
      });
    }
  }

  onPhotoAddRequested() async {
    final files = await ImagePicker().pickMultiImage();
    if (files.isNotEmpty) {
      setState(() {
        _photos.addAll(files.map((file) => UiKitMediaPhoto(link: file.path)));
      });
    }
  }

  onPhotoDeleted(int index) {
    setState(() {
      _photos.removeAt(index);
    });
  }

  selectHorizontalFormat([preselected]) async {
    final horizontal = preselected ?? await _getPhoto();
    if (horizontal == null) return;
    unawaited(showDialog(
        context: context,
        builder: (context) => _ImageViewFinderDialog(
              title: 'Crop to horizontal',
              imageBytes: File(horizontal).readAsBytesSync(),
              viewFinderOrientation: Axis.horizontal,
              onCropCompleted: (data) {
                final file = File('${tempDir.path}/shuffle-photos-editing/${data.filename ?? 'horizontal'}');
                file.createSync(recursive: true);
                file.writeAsBytesSync(data.croppedFileBytes);
                setState(() {
                  _photos.add(UiKitMediaPhoto(link: file.path, previewType: UiKitPreviewType.horizontal));
                });
              },
            )).then((_) {
      if (_photos.firstWhereOrNull((element) => element.previewType == UiKitPreviewType.horizontal) != null &&
          _photos.firstWhereOrNull((element) => element.previewType == UiKitPreviewType.vertical) == null) {
        selectVerticalFormat(horizontal);
      }
    }));
  }

  selectVerticalFormat([preselected]) async {
    final vertical = preselected ?? await _getPhoto();
    if (vertical == null) return;
    unawaited(showDialog(
        context: context,
        builder: (context) => _ImageViewFinderDialog(
              viewFinderOrientation: Axis.vertical,
              title: 'Crop to vertical',
              imageBytes: File(vertical).readAsBytesSync(),
              onCropCompleted: (data) {
                final file = File('${tempDir.path}/shuffle-photos-editing/${data.filename ?? 'vertical'}');
                file.createSync(recursive: true);
                file.writeAsBytesSync(data.croppedFileBytes);
                setState(() {
                  _photos.add(UiKitMediaPhoto(link: file.path, previewType: UiKitPreviewType.vertical));
                });
              },
            )).then((_) {
      if (_photos.firstWhereOrNull((element) => element.previewType == UiKitPreviewType.vertical) != null &&
          _photos.firstWhereOrNull((element) => element.previewType == UiKitPreviewType.horizontal) == null) {
        selectHorizontalFormat(vertical);
      }
    }));
  }

  _getPhoto() async {
    final selected = await showDialog(
        context: context,
        builder: (context) {
          return Dialog(
              backgroundColor: context.uiKitTheme?.colorScheme.surface3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadiusFoundation.all24,
              ),
              child: Column(mainAxisSize: MainAxisSize.min, children: [
                Text(
                  'Select a photo to set preview',
                  textAlign: TextAlign.center,
                  style: context.uiKitTheme?.boldTextTheme.title2,
                ),
                16.h.heightBox,
                SizedBox(
                  height: 100.h,
                  child: ListView.builder(
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      itemCount: mediaWithoutPreviews.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            context.pop(result: mediaWithoutPreviews[index].link);
                          },
                          child: ImageWidget(
                            link: mediaWithoutPreviews[index].link,
                            height: 100.h,
                            fit: BoxFit.fitHeight,
                          ).paddingSymmetric(horizontal: SpacingFoundation.horizontalSpacing4),
                        );
                      }),
                ),
                16.h.heightBox,
                context.button(
                  data: BaseUiKitButtonData(
                      text: 'From gallery',
                      onPressed: () async {
                        final res = await ImagePicker().pickImage(source: ImageSource.gallery);
                        if (res != null) {
                          context.pop(result: res.path);
                        }
                      }),
                )
              ]).paddingSymmetric(
                  horizontal: SpacingFoundation.horizontalSpacing8, vertical: SpacingFoundation.verticalSpacing16));
        });

    return selected;
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.uiKitTheme;
    final horizontalPadding = widget.positionModel?.horizontalMargin?.toDouble() ?? 0;

    final Widget errorWidget = Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ImageWidget(
            rasterAsset: GraphicsFoundation.instance.png.noPhoto,
            height: 50.h,
            fit: BoxFit.fitHeight,
          ),
          SpacingFoundation.verticalSpace16,
          Text(
            'Add photo here',
            style: theme?.boldTextTheme.body,
          )
        ],
      ),
    );

    return Scaffold(
        bottomNavigationBar: _photos.isNotEmpty
            ? SafeArea(
                child: context.gradientButton(
                    data: BaseUiKitButtonData(
                        text: S.of(context).Save,
                        onPressed: () {
                          context.pop(result: _photos);
                        })),
              )
            : null,
        body: PopScope(
          // onPopInvoked: (didPop) async {
            // context.pop(result: _photos);
            // return true;
          // },
          child: BlurredAppBarPage(
            autoImplyLeading: true,
            centerTitle: true,
            title: 'Add Image',
            childrenPadding: EdgeInsets.symmetric(horizontal: horizontalPadding),
            children: [
              SpacingFoundation.verticalSpace16,
              Row(children: [
                Text(
                  S.of(context).Photo,
                  style: theme?.boldTextTheme.title1,
                ),
                const Spacer(),
                context.outlinedButton(
                  data: BaseUiKitButtonData(
                    onPressed: onPhotoAddRequested,
                    iconInfo: BaseUiKitButtonIconData(
                      iconData: ShuffleUiKitIcons.cameraplus,
                      size: 16.h,
                    ),
                  ),
                )
              ]).paddingSymmetric(horizontal: horizontalPadding),
              SpacingFoundation.verticalSpace8,
              SizedBox(
                  height: 0.48.sw,
                  child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      shrinkWrap: true,
                      itemCount: mediaWithoutPreviews.length,
                      itemBuilder: (context, index) {
                        return Stack(
                          key: ValueKey(mediaWithoutPreviews[index].link),
                          alignment: Alignment.topRight,
                          children: [
                            ClipPath(
                              clipper: ShapeBorderClipper(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadiusFoundation.all8,
                                ),
                              ),
                              child: mediaWithoutPreviews[index].widget(Size(1.sw - horizontalPadding * 6, 0.48.sw)),
                            ).paddingAll(4),
                            context.outlinedButton(
                              hideBorder: true,
                              data: BaseUiKitButtonData(
                                onPressed: () => onPhotoDeleted(index),
                                iconInfo: BaseUiKitButtonIconData(
                                  iconData: ShuffleUiKitIcons.x,
                                  size: 20,
                                ),
                              ),
                            ),
                          ],
                        ).paddingSymmetric(horizontal: horizontalPadding / 2);
                      })),
              SpacingFoundation.verticalSpace8,
              if (_photos.isNotEmpty) ...[
                Row(children: [
                  Text(
                    'Cover',
                    style: theme?.boldTextTheme.title1,
                  ),
                  const Spacer(),
                ]).paddingSymmetric(horizontal: horizontalPadding),
                SpacingFoundation.verticalSpace8,
                Text(
                  'Horizontal format',
                  style: theme?.regularTextTheme.labelSmall,
                ),
                SpacingFoundation.verticalSpace8,
                InkWell(
                    borderRadius: BorderRadiusFoundation.all8,
                    onTap: selectHorizontalFormat,
                    child: ClipPath(
                      clipper: ShapeBorderClipper(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadiusFoundation.all8,
                        ),
                      ),
                      child: _photos
                              .firstWhereOrNull((element) => element.previewType == UiKitPreviewType.horizontal)
                              ?.widget(Size(1.sw - horizontalPadding * 6, 0.48.sw)) ??
                          ImageWidget(
                            height: 0.48.sw,
                            width: 1.sw - horizontalPadding * 6,
                            errorWidget: errorWidget,
                          ),
                    ).paddingAll(horizontalPadding)),
                SpacingFoundation.verticalSpace16,
                Text(
                  'Vertical format',
                  style: theme?.regularTextTheme.labelSmall,
                ),
                SpacingFoundation.verticalSpace8,
                InkWell(
                    borderRadius: BorderRadiusFoundation.all8,
                    onTap: selectVerticalFormat,
                    child: ClipPath(
                      clipper: ShapeBorderClipper(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadiusFoundation.all8,
                        ),
                      ),
                      child: _photos
                              .firstWhereOrNull((element) => element.previewType == UiKitPreviewType.vertical)
                              ?.widget(Size(0.48.sw, 1.sw - horizontalPadding * 6)) ??
                          ImageWidget(
                            height: 1.sw - horizontalPadding * 6,
                            width: 0.48.sw,
                            errorWidget: errorWidget,
                          ),
                    ).paddingAll(horizontalPadding)),
                SpacingFoundation.verticalSpace24
              ]
            ],
          ),
        ));
  }
}

class _ImageViewFinderDialog extends StatefulWidget {
  final Uint8List? imageBytes;
  final ValueChanged<CroppedImageData> onCropCompleted;
  final String title;
  final Axis? viewFinderOrientation;

  const _ImageViewFinderDialog({
    required this.onCropCompleted,
    required this.title,
    this.viewFinderOrientation,
    this.imageBytes,
  });

  @override
  State<_ImageViewFinderDialog> createState() => _ImageViewFinderDialogState();
}

class _ImageViewFinderDialogState extends State<_ImageViewFinderDialog> {
  Uint8List? originalImageBytes;
  final UiKitPictureViewFinderController controller = UiKitPictureViewFinderController();
  String? filename;
  String? mimeType;

  Size get availableSize => Size(0.9.sw, 0.6.sh);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      originalImageBytes = widget.imageBytes;
      controller.addListener(_imageViewFinderListener);
      setState(() {});
    });
  }

  void onAddPhoto() async {
    final file = await ImagePicker().pickImage(source: ImageSource.gallery);
    originalImageBytes = await file?.readAsBytes();
    setState(() {});
  }

  void _imageViewFinderListener() {
    setState(() {});
  }

  @override
  void dispose() {
    controller.removeListener(_imageViewFinderListener);
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.uiKitTheme;
    final boldTextTheme = theme?.boldTextTheme;

    return Dialog(
      insetPadding: EdgeInsets.zero,
      backgroundColor: theme?.colorScheme.surface3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadiusFoundation.all24),
      child: SizedBox(
        height: 0.8.sh,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                Text(
                  widget.title,
                  style: boldTextTheme?.title2,
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.close, color: Colors.white),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
            SpacingFoundation.verticalSpace16,
            if (originalImageBytes != null)
              Center(
                child: UiKitPictureViewFinder(
                  key: ValueKey(originalImageBytes.hashCode),
                  viewFinderOrientation: widget.viewFinderOrientation,
                  imageBytes: originalImageBytes!,
                  viewPortAvailableSize: availableSize,
                  controller: controller,
                  onCropCompleted: (bytes) {
                    widget.onCropCompleted(CroppedImageData(
                      originalFileBytes: originalImageBytes!,
                      croppedFileBytes: bytes,
                      mimeType: mimeType,
                      filename: filename,
                    ));
                    Navigator.pop(context);
                  },
                ),
              ),
            SpacingFoundation.verticalSpace16,
            context.gradientButton(
              data: BaseUiKitButtonData(
                text: 'CONFIRM',
                fit: ButtonFit.fitWidth,
                onPressed: () => controller.cropImage(),
                loading: controller.state == UiKitViewFinderState.cropping,
              ),
            ),
          ],
        ).paddingAll(EdgeInsetsFoundation.all24),
      ),
    );
  }
}
