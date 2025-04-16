import 'package:flutter/material.dart';
import 'package:shuffle_components_kit/domain/data_uimodels/point_history_universal_model.dart';
import 'package:shuffle_components_kit/presentation/presentation.dart';
import 'package:shuffle_uikit/shuffle_uikit.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:auto_size_text/auto_size_text.dart';

class ViewHistoryPointComponent extends StatefulWidget {
  const ViewHistoryPointComponent({
    super.key,
    this.onTapBarCode,
    required this.pagingController,
    this.onTabChange,
  });

  final ValueChanged<String>? onTabChange;
  final ValueChanged<PointHistoryUniversalModel>? onTapBarCode;
  final PagingController<int, PointHistoryUniversalModel> pagingController;

  @override
  State<ViewHistoryPointComponent> createState() => _ViewHistoryPointComponentState();
}

class _ViewHistoryPointComponentState extends State<ViewHistoryPointComponent> {
  String selectedTab = 'accrual';
  final AutoSizeGroup _group = AutoSizeGroup();
  UniqueKey pagingKey = UniqueKey();

  @override
  void didUpdateWidget(covariant ViewHistoryPointComponent oldWidget) {
    setState(() {
      pagingKey = UniqueKey();
    });
    print('we got new paging controller');
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: BlurredAppBarPage(
      autoImplyLeading: true,
      centerTitle: true,
      expandTitle: false,
      title: S.current.ViewHistory,
      childrenPadding: EdgeInsets.symmetric(horizontal: EdgeInsetsFoundation.horizontal16),
      children: [
        UiKitCustomTabBar(
          selectedTab: selectedTab,
          onTappedTab: (index) {
            widget.onTabChange?.call(index == 0 ? 'activation' : 'accrual');
            setState(() {
              selectedTab = index == 0 ? 'activation' : 'accrual';
            });
          },
          tabs: [
            UiKitCustomTab(
              title: S.current.Activation,
              customValue: 'activation',
              group: _group,
            ),
            UiKitCustomTab(
              title: S.current.Accrual,
              customValue: 'accrual',
              group: _group,
            ),
          ],
        ).paddingOnly(top: EdgeInsetsFoundation.vertical16),
        SizedBox(
          height: 0.75.sh,
          child: PagingListener(
              key: pagingKey,
              controller: widget.pagingController,
              builder: (context, state, fetchNextPage) => PagedListView<int, PointHistoryUniversalModel>(
                    padding: EdgeInsets.symmetric(vertical: EdgeInsetsFoundation.vertical8),
                    state: state,
                    fetchNextPage: fetchNextPage,
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
                                onTap: () => widget.onTapBarCode?.call(item),
                                activationModel: item.contentShortUiModel,
                              )
                            : UiKitPointsHistoryTile(
                                isLast: index == widget.pagingController.items!.length - 1,
                                title: item.uiModelViewHistoryAccrual?.title ?? '',
                                points: item.uiModelViewHistoryAccrual?.points ?? 0,
                                dateTime: item.uiModelViewHistoryAccrual?.date ?? DateTime.now(),
                              );
                      },
                    ),
                  )),
        )
      ],
    ));
  }
}
