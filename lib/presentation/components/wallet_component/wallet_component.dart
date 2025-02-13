import 'package:flutter/material.dart';
import 'package:shuffle_uikit/shuffle_uikit.dart';

/// Test variant, when implement really wallet refactor code first
class WalletComponent extends StatefulWidget {
  const WalletComponent({super.key});

  @override
  State<WalletComponent> createState() => _WalletComponentState();
}

class _WalletComponentState extends State<WalletComponent> with SingleTickerProviderStateMixin {
  double scrollOffset = 0.0;
  int selectedIndex = -1;
  double selectedCardOffset = 0.0;
  late AnimationController _controller;
  late Animation<double> _animation;
  late double firstCardTop;

  final List<WalletUiModel> cards = [
    WalletUiModel(backgroundLink: GraphicsFoundation.instance.png.wallet.card3.path),
    WalletUiModel(
      backgroundLink: GraphicsFoundation.instance.png.wallet.craiyon2.path,
      topLink: GraphicsFoundation.instance.png.wallet.sW1.path,
      withOpacity: true,
    ),
    WalletUiModel(backgroundLink: GraphicsFoundation.instance.png.wallet.card4.path),
  ];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 100),
    )..addListener(() {
        setState(() {
          scrollOffset = _animation.value;
        });
      });
  }

  void _animateBack() {
    _animation = Tween<double>(begin: scrollOffset, end: 0.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
    _controller.forward(from: 0);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.uiKitTheme;
    final isSmallDevice = 1.sw <= 380;

    return BlurredAppBarPage(
      centerTitle: true,
      autoImplyLeading: true,
      crossAxisAlignment: CrossAxisAlignment.start,
      customToolbarBaseHeight: isSmallDevice ? 125.h : 110.h,
      customTitle: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            S.of(context).Wallet,
            style: theme?.boldTextTheme.title1,
          ),
          18.h.heightBox,
          Text(
            '\$ 934.00',
            style: theme?.boldTextTheme.title1,
          ),
          SpacingFoundation.verticalSpace2,
          Text(
            S.of(context).AvailableBalance,
            style: theme?.boldTextTheme.caption2Medium.copyWith(
              color: ColorsFoundation.mutedText,
            ),
          ),
        ],
      ),
      children: [
        SizedBox(
          height: 0.7.sh,
          child: LayoutBuilder(
            builder: (context, constraints) {
              final totalHeight = constraints.maxHeight;
              final double cardHeight = totalHeight * (isSmallDevice ? 0.45 : 0.35);
              final double visiblePart = cardHeight * (isSmallDevice ? 0.5 : 0.55);
              firstCardTop = SpacingFoundation.verticalSpacing16;

              return GestureDetector(
                onVerticalDragUpdate: (details) {
                  setState(() {
                    if (selectedIndex == -1) {
                      scrollOffset = (scrollOffset - (details.primaryDelta ?? 1) * 2.0)
                          .clamp(-cardHeight * 2.5, (cardHeight + 10) * (cards.length - 1));
                    } else {
                      selectedCardOffset = (selectedCardOffset + (details.primaryDelta ?? 1) * 1.5);
                    }
                  });
                },
                onVerticalDragEnd: (details) {
                  if (selectedIndex == -1) {
                    _animateBack();
                  } else {
                    setState(() {
                      selectedCardOffset = 0.0;
                    });
                  }
                },
                child: Stack(
                  fit: StackFit.expand,
                  alignment: Alignment.topCenter,
                  children: [
                    Stack(
                      children: cards.map((card) {
                        final index = cards.indexOf(card);
                        double dynamicOffset = scrollOffset * 0.3;
                        double top = firstCardTop + index * visiblePart;

                        if (selectedIndex == -1) {
                          if (index == 0) {
                            top = firstCardTop + (scrollOffset < 0 ? -scrollOffset * 0.1 : 0);
                          } else {
                            top = firstCardTop + index * visiblePart - dynamicOffset * (index * 0.8);
                          }
                        } else {
                          if (index == selectedIndex) {
                            top = firstCardTop + selectedCardOffset;
                          } else {
                            top = totalHeight - (cards.length - index) * 10;
                          }
                        }

                        return AnimatedPositioned(
                          duration: Duration(milliseconds: 600),
                          curve: Curves.easeOut,
                          top: top,
                          left: 0,
                          right: 0,
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                selectedIndex = selectedIndex == index ? -1 : index;
                                if (selectedIndex == -1) {
                                  _animateBack(); // При повторном тапе возвращаем всё назад
                                }
                              });
                            },
                            child: _WalletCard(
                              height: cardHeight,
                              isSelected: index == selectedIndex,
                              backgroundLink: card.backgroundLink,
                              topLink: card.topLink,
                              withOpacity: card.withOpacity,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _WalletCard extends StatelessWidget {
  final String? backgroundLink;
  final String? topLink;
  final bool withOpacity;
  final double height;
  final bool isSelected;

  const _WalletCard({
    this.backgroundLink,
    this.topLink,
    this.withOpacity = false,
    required this.height,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = context.uiKitTheme;
    final isSmallDevice = 1.sw <= 380;

    return SizedBox(
      height: height,
      child: UiKitCardWrapper(
        borderRadius: BorderRadiusFoundation.all24,
        border: BorderSide(
          color: ColorsFoundation.neutral32,
          width: 2.w,
        ),
        gradient: withOpacity ? null : GradientFoundation.walletCardGradient,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Opacity(
              opacity: withOpacity ? 0.15 : 1.0,
              child: ImageWidget(
                height: isSmallDevice ? 0.6.sw : 0.7.sw,
                width: 1.sw,
                link: backgroundLink,
                fit: BoxFit.cover,
              ),
            ),
            if (topLink != null && topLink!.isNotEmpty)
              Align(
                alignment: Alignment.topLeft,
                child: ImageWidget(
                  height: isSmallDevice ? 0.4.sw : 0.35.sw,
                  width: 0.75.sw,
                  link: topLink,
                  fit: BoxFit.contain,
                ),
              ).paddingAll(EdgeInsetsFoundation.all12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Spacer(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      'Corey Westervelt',
                      style: theme?.boldTextTheme.caption3Medium.copyWith(
                        color: ColorsFoundation.mutedText,
                      ),
                    ),
                  ],
                ).paddingAll(EdgeInsetsFoundation.all16),
              ],
            ),
          ],
        ),
      ),
    ).paddingSymmetric(horizontal: SpacingFoundation.horizontalSpacing16);
  }
}

class WalletUiModel {
  final String? backgroundLink;
  final String? topLink;
  final bool withOpacity;

  WalletUiModel({
    this.backgroundLink,
    this.topLink,
    this.withOpacity = false,
  });
}
