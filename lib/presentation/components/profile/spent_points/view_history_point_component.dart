import 'package:flutter/material.dart';
import 'package:shuffle_components_kit/domain/data_uimodels/point_history_universal_model.dart';
import 'package:shuffle_components_kit/presentation/presentation.dart';
import 'package:shuffle_uikit/shuffle_uikit.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class ViewHistoryPointComponent extends StatefulWidget {
  const ViewHistoryPointComponent({
    super.key,
    this.onTapBarCode,
    required this.pagingController,
    this.onTabChange,
  });

  final ValueChanged<int>? onTabChange;
  final VoidCallback? onTapBarCode;
  final PagingController<int, PointHistoryUniversalModel> pagingController;

  @override
  State<ViewHistoryPointComponent> createState() => _ViewHistoryPointComponentState();
}

class _ViewHistoryPointComponentState extends State<ViewHistoryPointComponent> {
  int tabValue = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: BlurredAppBarPage(
      autoImplyLeading: true,
      centerTitle: true,
      title: S.current.ViewHistory,
      childrenPadding: EdgeInsets.symmetric(horizontal: EdgeInsetsFoundation.horizontal16),
      children: [
        UiKitCustomTabBar(
          onTappedTab: (value) {
            // widget.onTabChange?.call(value);
            setState(() {
              tabValue = value;
            });
          },
          tabs: [
            UiKitCustomTab(
              title: S.current.Activation,
            ),
            UiKitCustomTab(
              title: S.current.Accrual,
            ),
          ],
        ).paddingOnly(top: EdgeInsetsFoundation.vertical16),
        SizedBox(
          height: 0.75.sh,
          child: PagedListView<int, PointHistoryUniversalModel>(
            padding: EdgeInsets.symmetric(vertical: EdgeInsetsFoundation.vertical8),
            pagingController: widget.pagingController,
            builderDelegate: PagedChildBuilderDelegate(
              noItemsFoundIndicatorBuilder: (_) => const UnderDevelopment(),
              itemBuilder: (context, item, index) {
                if (item.contentShortUiModel != null && tabValue == 0) {
                  return ViewHistoryActivationWidget(
                    onTap: widget.onTapBarCode,
                    activationModel: item.contentShortUiModel,
                  );
                } else if (item.uiModelViewHistoryAccrual != null && tabValue == 1) {
                  return UiKitPointsHistoryTile(
                    isLast: index == widget.pagingController.itemList!.length - 1,
                    title: item.uiModelViewHistoryAccrual?.title ?? '',
                    points: item.uiModelViewHistoryAccrual?.points ?? 0,
                    dateTime: item.uiModelViewHistoryAccrual?.date ?? DateTime.now(),
                  );
                }
                if (index == 0) {
                  return const UnderDevelopment();
                } else {
                  return SpacingFoundation.none;
                }
                // return item.contentShortUiModel != null
                //     ? ViewHistoryActivationWidget(
                //         onTap: onTapBarCode,
                //         activationModel: item.contentShortUiModel,
                //       )
                //     : UiKitPointsHistoryTile(
                //         isLast: index == pagingController.itemList!.length - 1,
                //         title: item.uiModelViewHistoryAccrual?.title ?? '',
                //         points: item.uiModelViewHistoryAccrual?.points ?? 0,
                //         dateTime: item.uiModelViewHistoryAccrual?.date ?? DateTime.now(),
                //       );
              },
            ),
          ),
        )
      ],
    ));
  }
}
