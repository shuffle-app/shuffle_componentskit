import 'package:flutter/material.dart';
import 'package:shuffle_uikit/shuffle_uikit.dart';

import '../components.dart';

class ViewHistoryPointComponent extends StatefulWidget {
  const ViewHistoryPointComponent(
      {super.key,
      this.activationList,
      this.accrualList,
       this.onTapBarCode});

  final List<UiModelFavoritesMergeComponent>? activationList;
  final List<UiModelViewHistoryAccrual>? accrualList;
  final VoidCallback? onTapBarCode;

  @override
  State<ViewHistoryPointComponent> createState() =>
      _ViewHistoryPointComponentState();
}

class _ViewHistoryPointComponentState extends State<ViewHistoryPointComponent> {
  int tabBarIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlurredAppBarPage(
        autoImplyLeading: true,
        centerTitle: true,
        title: S.current.ViewHistory,
        childrenPadding:
            EdgeInsets.symmetric(horizontal: EdgeInsetsFoundation.horizontal16),
        children: [
          UiKitCustomTabBar(
            onTappedTab: (value) {
              setState(() {
                tabBarIndex = value;
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
          ).paddingSymmetric(vertical: EdgeInsetsFoundation.vertical16),
          tabBarIndex == 0
              ? ViewHistoryActivationComponent(
                  onTap: widget.onTapBarCode,
                  activationList: widget.activationList,
                )
              : ViewHistoryAccrualComponent(
                  accrualList: widget.accrualList,
                ),
        ],
      ),
    );
  }
}
