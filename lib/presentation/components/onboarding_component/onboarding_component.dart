import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shuffle_components_kit/shuffle_components_kit.dart';
import 'package:shuffle_uikit/shuffle_uikit.dart';

class OnboardingComponent extends StatefulWidget {
  late final List<OnBoardingPageItem> items;
  late final ComponentModel model;
  final VoidCallback? onFinished;

  OnboardingComponent({super.key, this.onFinished}) {
    model = ComponentModel.fromJson(GlobalConfiguration().appConfig.content['onboarding']);
    final rawItems =
        model.content.body?.entries.firstWhere((element) => element.key == ContentItemType.onboardingCard).value.properties;
    items = rawItems?.entries
            .map((e) => OnBoardingPageItem(imageLink: e.value.imageLink!, title: e.key, autoSwitchDuration: e.value.duration!))
            .toList() ??
        [];
    items.sort((a, b) => (rawItems?[a.title]?.sortNumber ?? 0).compareTo((rawItems?[b.title]?.sortNumber ?? 0)));
  }

  Duration get transitionDuration => model.content.properties?['general']?.duration ?? const Duration(milliseconds: 500);

  @override
  State<OnboardingComponent> createState() => _OnboardingComponentState();
}

class _OnboardingComponentState extends State<OnboardingComponent> with SingleTickerProviderStateMixin {
  bool isLoading = false;

  late final AnimationController _progressAnimationController = AnimationController(
    vsync: this,
    duration: overallDuration,
    value: 0,
  )..addListener(_animationListener);

  final _firstItemFadeInDuration = const Duration(milliseconds: 500);

  double _textOpacity = 0;
  double _logoOpacity = 0;
  double _imageOpacity = 0;

  int currentIndex = 0;

  double get currentItemProgressPortion => currentIndex >= widget.items.length
      ? widget.items.length - 1
      : ((widget.items.elementAt(currentIndex).autoSwitchDuration.inMilliseconds +
                  (widget.transitionDuration * 3).inMilliseconds) /
              overallDuration.inMilliseconds) *
          (currentIndex + 1);

  double get divisionWidth => 1 / widget.items.length;

  Duration get overallDuration {
    Duration duration = Duration.zero;
    for (final item in widget.items) {
      /// add total duration for the item with fade in and fade out durations
      duration += item.autoSwitchDuration + (widget.transitionDuration * 3);
    }

    return duration;
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      unawaited(_progressAnimationController.forward(from: 0));
      await Future.delayed(_firstItemFadeInDuration);
      setState(() {
        _textOpacity = 1;
        _logoOpacity = 1;
      });
      Future.delayed(_firstItemFadeInDuration * 2, () => setState(() => _imageOpacity = 1));
    });
  }

  void _animationListener() async {
    final value = _progressAnimationController.value;

    if (value >= currentItemProgressPortion) {
      if (currentIndex != widget.items.length - 1 && _textOpacity != 0) {
        unawaited(_switchToNextPage());
      }
    }
    if (value == 1.0) {
      widget.onFinished?.call();
      setState(() {
        isLoading = true;
      });
    }
  }

  Future<void> _switchToNextPage() async {
    setState(() {
      _textOpacity = 0;
      _imageOpacity = 0;
    });

    await Future.delayed(widget.transitionDuration);

    if (!mounted) return;
    setState(() {
      _textOpacity = 1;
      currentIndex++;
    });
    await Future.delayed(widget.transitionDuration * 2);
    if (!mounted) return;
    setState(() => _imageOpacity = 1);
  }

  @override
  void dispose() {
    _progressAnimationController.removeListener(_animationListener);
    _progressAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final horizontalMargin = widget.model.positionModel?.horizontalMargin?.toDouble() ?? 0;
    final bodyAlignment = widget.model.positionModel?.bodyAlignment;

    return Stack(
      fit: StackFit.expand,
      children: [
        Positioned(
          bottom: 0,
          child: AnimatedOpacity(
            duration: widget.transitionDuration,
            opacity: _imageOpacity,
            child: AnimatedSwitcher(
              duration: widget.transitionDuration,
              child: ImageWidget(
                key: UniqueKey(),
                link: currentIndex >= widget.items.length
                    ? widget.items.last.imageLink
                    : widget.items.elementAt(currentIndex).imageLink,
                width: 1.sw,
                fit: BoxFit.fitWidth,
              ),
            ),
          ),
        ),
        Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: bodyAlignment.crossAxisAlignment,
          mainAxisAlignment: bodyAlignment.mainAxisAlignment,
          children: [
            SizedBox(
              height: MediaQuery.of(context).viewPadding.top + (widget.model.positionModel?.verticalMargin?.toDouble() ?? 0),
            ),
            SpacingFoundation.verticalSpace24,
            AnimatedOpacity(
              duration: widget.transitionDuration,
              opacity: _logoOpacity,
              child: const ImageWidget(
                iconData: ShuffleUiKitIcons.shuffleWhite,
                fit: BoxFit.fitWidth,
              ).paddingSymmetric(horizontal: 1.sw * 0.215625),
            ),
            SpacingFoundation.verticalSpace24,
            AnimatedOpacity(
              duration: widget.transitionDuration,
              opacity: _textOpacity,
              child: Text(
                key: UniqueKey(),
                currentIndex >= widget.items.length ? widget.items.last.title : widget.items.elementAt(currentIndex).title,
                style: context.uiKitTheme?.boldTextTheme.titleLarge,
                textAlign: TextAlign.center,
              ).paddingSymmetric(horizontal: EdgeInsetsFoundation.horizontal32),
            ),
            const Spacer(),
            AnimatedBuilder(
              animation: _progressAnimationController,
              builder: (context, value) {
                return context
                    .buttonWithProgress(
                      data: BaseUiKitButtonData(
                        loading: isLoading,
                        text: S.of(context).NextWithChevrons.toUpperCase(),
                        onPressed: isLoading
                            ? null
                            : () {
                                if (currentIndex != widget.items.length - 1) {
                                  unawaited(_switchToNextPage());
                                  _progressAnimationController.forward(from: currentItemProgressPortion);
                                } else {
                                  widget.onFinished?.call();
                                  setState(() {
                                    isLoading = true;
                                  });
                                }
                                // _progressAnimationController.forward(from: 0);
                                // setState(() {
                                //   currentIndex = 0;
                                // });
                              },
                      ),
                      progress: _progressAnimationController.value,
                      blurred: true,
                    )
                    .paddingSymmetric(horizontal: horizontalMargin);
              },
            ),
            SpacingFoundation.verticalSpace24,
          ],
        ),
      ],
    );
  }
}
