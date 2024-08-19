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
  String selectedTab = 'Accrual';

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
          selectedTab: selectedTab,
          onTappedTab: (value) {
            setState(() {
              widget.onTabChange?.call(value);
              selectedTab = ['Activation', 'Accrual'][value];
            });
          },
          tabs: [
            UiKitCustomTab(
              title: S.current.Activation,
              customValue: 'Activation',
            ),
            UiKitCustomTab(
              title: S.current.Accrual,
              customValue: 'Accrual',
            ),
          ],
        ).paddingOnly(top: EdgeInsetsFoundation.vertical16),
        SizedBox(
          height: 0.75.sh,
          child: PagedListView<int, PointHistoryUniversalModel>(
            padding: EdgeInsets.symmetric(vertical: EdgeInsetsFoundation.vertical8),
            pagingController: widget.pagingController,
            builderDelegate: PagedChildBuilderDelegate(
              noItemsFoundIndicatorBuilder: (_) => Center(
                child: Text(
                  S.of(context).NothingFound,
                  style: context.uiKitTheme?.boldTextTheme.body,
                ),
              ),
              itemBuilder: (context, item, index) {
                return item.contentShortUiModel != null
                    ? ViewHistoryActivationWidget(
                        onTap: widget.onTapBarCode,
                        activationModel: item.contentShortUiModel,
                      )
                    : UiKitPointsHistoryTile(
                        isLast: index == widget.pagingController.itemList!.length - 1,
                        title: item.uiModelViewHistoryAccrual?.title ?? '',
                        points: item.uiModelViewHistoryAccrual?.points ?? 0,
                        dateTime: item.uiModelViewHistoryAccrual?.date ?? DateTime.now(),
                      );
              },
            ),
          ),
        )
      ],
    ));
  }
}
