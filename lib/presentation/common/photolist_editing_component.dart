// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'package:auto_size_text/auto_size_text.dart';
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
    final mediaToDelete = mediaWithoutPreviews[index];
    setState(() {
      _photos.remove(mediaToDelete);
    });
  }

  onHorizontalPreviewDeleted() {
    setState(() {
      _photos.removeWhere((element) => element.previewType == UiKitPreviewType.horizontal);
    });
  }

  onVerticalPreviewDeleted() {
    setState(() {
      _photos.removeWhere((element) => element.previewType == UiKitPreviewType.vertical);
    });
  }

  selectHorizontalFormat([String? preselected]) async {
    final horizontal = preselected ?? await _getPhoto();
    Uint8List? bytes;
    if (horizontal == null) return;
    if (horizontal.startsWith('http')) {
      bytes = await getBytesFromUrl(horizontal);
    }
    unawaited(showDialog(
        context: context,
        builder: (context) => _ImageViewFinderDialog(
              title: S.current.CropHorizontal,
              imageBytes: bytes ?? File(horizontal).readAsBytesSync(),
              viewFinderOrientation: Axis.horizontal,
              onCropCompleted: (data) {
                final file = File(
                    '${tempDir.path}/shuffle-photos-editing/${horizontal}${DateTime.now().millisecondsSinceEpoch}');
                file.createSync(recursive: true);
                file.writeAsBytesSync(data.croppedFileBytes);

                setState(() {
                  _photos.removeWhere((element) => element.previewType == UiKitPreviewType.horizontal);
                  _photos.add(UiKitMediaPhoto(link: file.path, previewType: UiKitPreviewType.horizontal));
                });
              },
            )).then((_) {
      // if (_photos.firstWhereOrNull((element) => element.previewType == UiKitPreviewType.horizontal) != null &&
      //     _photos.firstWhereOrNull((element) => element.previewType == UiKitPreviewType.vertical) == null) {
      if (preselected == null) {
        selectVerticalFormat(horizontal);
      }
      setState(() {});
    }));
  }

  selectVerticalFormat([String? preselected]) async {
    final vertical = preselected ?? await _getPhoto();
    if (vertical == null) return;
    Uint8List? bytes;
    if (vertical.startsWith('http')) {
      bytes = await getBytesFromUrl(vertical);
    }
    unawaited(showDialog(
        context: context,
        builder: (context) => _ImageViewFinderDialog(
              viewFinderOrientation: Axis.vertical,
              title: S.current.CropVertical,
              imageBytes: bytes ?? File(vertical).readAsBytesSync(),
              onCropCompleted: (data) {
                final file =
                    File('${tempDir.path}/shuffle-photos-editing/${vertical}${DateTime.now().millisecondsSinceEpoch}');
                file.createSync(recursive: true);
                file.writeAsBytesSync(data.croppedFileBytes);

                setState(() {
                  _photos.removeWhere((element) => element.previewType == UiKitPreviewType.vertical);
                  _photos.add(UiKitMediaPhoto(link: file.path, previewType: UiKitPreviewType.vertical));
                });
              },
            )).then((_) {
      // if (_photos.firstWhereOrNull((element) => element.previewType == UiKitPreviewType.vertical) != null &&
      //     _photos.firstWhereOrNull((element) => element.previewType == UiKitPreviewType.horizontal) == null) {
      if (preselected == null) {
        selectHorizontalFormat(vertical);
      }
      setState(() {});
    }));
  }

  Future<String?> _getPhoto() async {
    final selected = await showDialog<String?>(
        context: context,
        builder: (context) {
          final inversedColor = context.uiKitTheme?.colorScheme.inversePrimary;
          final primaryColor = context.uiKitTheme?.colorScheme.primary;
          return Dialog(
              backgroundColor: inversedColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadiusFoundation.all24,
              ),
              child: Column(mainAxisSize: MainAxisSize.min, children: [
                Flexible(
                    child: AutoSizeText(
                  S.current.SelectToSetPreview,
                  textAlign: TextAlign.center,
                  style: context.uiKitTheme?.boldTextTheme.title2.copyWith(color: primaryColor),
                )),
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
                      text: S.current.FromGallery,
                      textColor: inversedColor,
                      backgroundColor: primaryColor,
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
          AutoSizeText(
            S.of(context).AddPhotoHere,
            style: theme?.boldTextTheme.body,
          )
        ],
      ),
    );

    final textTheme = theme?.boldTextTheme;
    TextStyle? textStyle = textTheme?.title1 ?? Theme.of(context).primaryTextTheme.titleMedium;
    textStyle = textStyle?.copyWith(color: theme?.colorScheme.inversePrimary);

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
            customTitle: Flexible(
                child: AutoSizeText(
              S.of(context).AddImage,
              style: textStyle,
              maxLines: 1,
            )),
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
                Text(
                  S.of(context).Cover,
                  style: theme?.boldTextTheme.title1,
                ).paddingSymmetric(horizontal: horizontalPadding),
                SpacingFoundation.verticalSpace8,
                Text(
                  S.of(context).HorizontalFormat,
                  style: theme?.regularTextTheme.labelSmall,
                ).paddingSymmetric(horizontal: horizontalPadding),
                SpacingFoundation.verticalSpace8,
                Stack(clipBehavior: Clip.none, alignment: Alignment.center, children: [
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
                      )),
                  if (_photos.firstWhereOrNull((element) => element.previewType == UiKitPreviewType.horizontal) != null)
                    Positioned(
                        top: -8.w,
                        right: -4.w,
                        child: context.outlinedButton(
                          hideBorder: true,
                          data: BaseUiKitButtonData(
                            onPressed: onHorizontalPreviewDeleted,
                            iconInfo: BaseUiKitButtonIconData(
                              iconData: ShuffleUiKitIcons.x,
                              size: 20,
                            ),
                          ),
                        )),
                ]).paddingAll(horizontalPadding),
                SpacingFoundation.verticalSpace16,
                Text(
                  S.of(context).VerticalFormat,
                  style: theme?.regularTextTheme.labelSmall,
                ).paddingSymmetric(horizontal: horizontalPadding),
                SpacingFoundation.verticalSpace8,
                SizedBox(
                    width: 267.w,
                    height: 267.w / 0.78125,
                    child: Stack(clipBehavior: Clip.none, alignment: Alignment.center, children: [
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
                                    ?.widget(Size(267.w, 267.w / 0.78125)) ??
                                ImageWidget(
                                  height: 267.w / 0.78125,
                                  width: 267.w,
                                  errorWidget: errorWidget,
                                ),
                          )),
                      if (_photos.firstWhereOrNull((element) => element.previewType == UiKitPreviewType.vertical) !=
                          null)
                        Positioned(
                            top: -4,
                            right: -4,
                            child: context.outlinedButton(
                              hideBorder: true,
                              data: BaseUiKitButtonData(
                                onPressed: onVerticalPreviewDeleted,
                                iconInfo: BaseUiKitButtonIconData(
                                  iconData: ShuffleUiKitIcons.x,
                                  size: 20,
                                ),
                              ),
                            )),
                    ])).paddingAll(horizontalPadding),
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
    final inversedColor = theme?.colorScheme.inversePrimary;
    final primaryColor = theme?.colorScheme.primary;
    final boldTextTheme = theme?.boldTextTheme;

    return Dialog(
      insetPadding: EdgeInsets.zero,
      backgroundColor: inversedColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadiusFoundation.all24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              Expanded(
                  child: Text(
                widget.title,
                style: boldTextTheme?.title2.copyWith(color: primaryColor),
              )),
              SpacingFoundation.horizontalSpace16,
              IconButton(
                icon: Icon(Icons.close, color: primaryColor),
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
              text: S.of(context).Confirm.toUpperCase(),
              fit: ButtonFit.fitWidth,
              onPressed: () => controller.cropImage(),
              loading: controller.state == UiKitViewFinderState.cropping,
            ),
          ),
        ],
      ).paddingAll(EdgeInsetsFoundation.all24),
    );
  }
}

Future<Uint8List?> getBytesFromUrl(String url) async {
  final image = await CustomCacheManager.imageInstance.getSingleFile(url);
  return await image.readAsBytes();
}
