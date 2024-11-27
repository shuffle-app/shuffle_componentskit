import 'package:flutter/material.dart';
import 'package:shuffle_components_kit/presentation/common/web_form_field.dart';
import 'package:shuffle_uikit/shuffle_uikit.dart';

class CreatePublicationWebComponent extends StatefulWidget {
  final Size itemsSize;
  final List<UiKitMediaPhoto> photos;
  final TextEditingController descriptionController;
  final VoidCallback? onDescriptionTapped;
  final VoidCallback onPhotoAddRequested;
  final VoidCallback? onCreateTap;
  final ValueChanged<int> onPhotoDeleted;
  final Function(int oldIndex, int newIndex) onPhotoReorderRequested;

  const CreatePublicationWebComponent({
    super.key,
    this.itemsSize = const Size(75, 75),
    this.onDescriptionTapped,
    required this.descriptionController,
    required this.onPhotoAddRequested,
    required this.onPhotoReorderRequested,
    required this.onPhotoDeleted,
    required this.photos,
    this.onCreateTap,
  });

  @override
  State<CreatePublicationWebComponent> createState() => _CreatePublicationWebComponentState();
}

class _CreatePublicationWebComponentState extends State<CreatePublicationWebComponent> {
  final GlobalKey<ReorderableListState> listPhotosKey = GlobalKey<ReorderableListState>();

  final List<BaseUiKitMedia> _photos = [];

  @override
  void initState() {
    _photos.addAll(widget.photos);
    super.initState();
  }

  @override
  void didUpdateWidget(covariant CreatePublicationWebComponent oldWidget) {
    super.didUpdateWidget(oldWidget);
    _photos.clear();
    _photos.addAll(widget.photos);
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.uiKitTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: widget.onDescriptionTapped,
          child: WebFormField(
            title: S.of(context).Description,
            isRequired: true,
            child: IgnorePointer(
              child: UiKitInputFieldNoIcon(
                controller: widget.descriptionController,
                readOnly: true,
                textInputAction: TextInputAction.newline,
                hintText: 'Description for new Shuffle content',
                fillColor: theme?.colorScheme.surface1,
                borderRadius: BorderRadiusFoundation.all12,
                onTap: widget.onDescriptionTapped,
              ),
            ),
          ),
        ),
        SpacingFoundation.verticalSpace16,
        WebFormField(
          title: S.of(context).PhotoUploadFiles,
          isRequired: true,
          child: SizedBox(
            height: widget.itemsSize.height * 1.2,
            width: double.infinity,
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: theme?.colorScheme.surface1,
                borderRadius: BorderRadiusFoundation.all12,
                border: Border.fromBorderSide(
                  BorderSide(width: 1, color: theme?.colorScheme.surface5 ?? Colors.black),
                ),
              ),
              child: Stack(
                alignment: Alignment.centerRight,
                children: [
                  ReorderableListView.builder(
                    key: listPhotosKey,
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (BuildContext context, int index) => Stack(
                      key: ValueKey(_photos[index].link),
                      alignment: Alignment.topRight,
                      children: [
                        ClipPath(
                          clipper: ShapeBorderClipper(
                            shape: RoundedRectangleBorder(borderRadius: BorderRadiusFoundation.all8),
                          ),
                          child: _photos[index].widget(widget.itemsSize),
                        ).paddingAll(4),
                        context.outlinedButton(
                          hideBorder: true,
                          data: BaseUiKitButtonData(
                            onPressed: () => widget.onPhotoDeleted.call(index),
                            iconInfo: BaseUiKitButtonIconData(
                              iconData: ShuffleUiKitIcons.x,
                              size: 8,
                            ),
                          ),
                        ),
                      ],
                    ),
                    itemCount: _photos.length,
                    onReorder: widget.onPhotoReorderRequested,
                  ),
                  Positioned(
                    left: 0,
                    child: context
                        .badgeButtonNoValue(
                          data: BaseUiKitButtonData(
                            onPressed: widget.onPhotoAddRequested,
                            iconWidget: DecoratedBox(
                                decoration: BoxDecoration(
                                  shape: BoxShape.rectangle,
                                  border: Border.fromBorderSide(
                                    BorderSide(color: context.uiKitTheme!.colorScheme.darkNeutral500, width: 1),
                                  ),
                                  borderRadius: BorderRadiusFoundation.all12,
                                ),
                                child: ImageWidget(
                                  svgAsset: GraphicsFoundation.instance.svg.gradientPlus,
                                  color: theme?.colorScheme.inversePrimary,
                                  height: 18,
                                  width: 18,
                                ).paddingAll(EdgeInsetsFoundation.all12)),
                          ),
                        )
                        .paddingOnly(left: EdgeInsetsFoundation.horizontal16),
                  ),
                  if (_photos.isEmpty)
                    Positioned(
                      right: EdgeInsetsFoundation.vertical16,
                      child: Text(
                        S.of(context).OrDragFilesHere.toLowerCase(),
                        style: theme?.boldTextTheme.caption1Medium.copyWith(
                          color: theme.colorScheme.darkNeutral900,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
        SpacingFoundation.verticalSpace16,
        context.gradientButton(
          data: BaseUiKitButtonData(
            onPressed: widget.onCreateTap,
            text: S.of(context).Create,
          ),
        )
      ],
    );
  }
}
