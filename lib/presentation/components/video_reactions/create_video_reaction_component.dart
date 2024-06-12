import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:shuffle_components_kit/domain/data_uimodels/video_preview_ui_model.dart';
import 'package:shuffle_uikit/shuffle_uikit.dart';

class CreateVideoReactionComponent extends StatelessWidget {
  final VoidCallback onGoPressed;
  final ValueChanged<String> onAlbumNameChanged;
  final List<String> albumNames;
  final String? initiallySelectedAlbum;
  final List<VideoPreviewUiModel> selectedVideos;
  final ValueChanged<VideoPreviewUiModel>? onVideoSelectionChanged;
  final PagingController<int, VideoPreviewUiModel> videosPagingController;
  final bool multiSelectEnabled;

  const CreateVideoReactionComponent({
    Key? key,
    required this.onGoPressed,
    required this.onAlbumNameChanged,
    required this.videosPagingController,
    required this.albumNames,
    this.selectedVideos = const [],
    this.initiallySelectedAlbum,
    this.onVideoSelectionChanged,
    this.multiSelectEnabled = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textTheme = context.uiKitTheme?.boldTextTheme;

    return BlurredAppBarPage(
      autoImplyLeading: true,
      centerTitle: true,
      title: S.current.AddReactions,
      customToolbarBaseHeight: 0.15.sh,
      children: [
        Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            UiKitDropDownList<String>(
              width: 0.3.sw,
              selectedItem: initiallySelectedAlbum,
              onChanged: (value) {
                if (value != null) onAlbumNameChanged.call(value);
              },
              items: albumNames
                  .map(
                    (e) => DropdownMenuItem<String>(
                      value: e.toLowerCase(),
                      child: Text(
                        e,
                        style: textTheme?.caption1Medium,
                      ),
                    ),
                  )
                  .toList(),
            ),
            if (multiSelectEnabled)
              context.smallButton(
                data: BaseUiKitButtonData(
                  text: S.current.GoNoExclamation,
                  onPressed: onGoPressed,
                  iconInfo: BaseUiKitButtonIconData(
                    iconData: ShuffleUiKitIcons.chevronright,
                  ),
                ),
              ),
          ],
        ).paddingAll(EdgeInsetsFoundation.all16),
        SizedBox(
          height: 1.sh - kToolbarHeight - 172,
          width: 1.sw,
          child: PagedGridView(
            pagingController: videosPagingController,
            padding: EdgeInsets.zero,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: EdgeInsetsFoundation.vertical2,
              mainAxisSpacing: EdgeInsetsFoundation.horizontal2,
              childAspectRatio: 96 / 162,
            ),
            builderDelegate: PagedChildBuilderDelegate<VideoPreviewUiModel>(
              itemBuilder: (context, item, index) {
                return GestureDetector(
                  onTap: () => onVideoSelectionChanged?.call(item),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      item.previewImage ?? const SizedBox.shrink(),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Container(
                          height: 0.075.sh,
                          decoration: const BoxDecoration(
                            gradient: GradientFoundation.blackLinearGradient,
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: EdgeInsetsFoundation.vertical4,
                        right: EdgeInsetsFoundation.horizontal4,
                        child: Text(
                          item.duration,
                          style: textTheme?.caption2Medium.copyWith(color: Colors.white),
                        ),
                      ),
                      if (multiSelectEnabled)
                        Positioned(
                          top: EdgeInsetsFoundation.vertical4,
                          right: EdgeInsetsFoundation.horizontal4,
                          child: UiKitCheckbox(
                            key: ValueKey(item.id),
                            onChanged: () => onVideoSelectionChanged?.call(item),
                            isActive: selectedVideos.contains(item),
                          ),
                        ),
                    ],
                  ),
                );
              },
            ),
          ),
        ).paddingSymmetric(horizontal: EdgeInsetsFoundation.horizontal16),
      ],
    );
  }
}
