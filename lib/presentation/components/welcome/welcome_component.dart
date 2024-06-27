import 'package:flutter/material.dart';
import 'package:shuffle_components_kit/shuffle_components_kit.dart';
import 'package:shuffle_uikit/shuffle_uikit.dart';

part 'first_body.dart';
part 'last_body.dart';

class WelcomeComponent extends StatefulWidget {
  late final OnBoardingPageItem firstBodyItem;
  late final OnBoardingPageItem lastBodyItem;
  late final ComponentModel model;
  final VoidCallback? onFinished;

  WelcomeComponent({
    super.key,
    this.onFinished,
  }) {
    model = ComponentModel.fromJson(GlobalConfiguration().appConfig.content['welcome']);
    final rawItems =
        model.content.body?.entries.firstWhere((element) => element.key == ContentItemType.onboardingCard).value.properties;
    firstBodyItem = OnBoardingPageItem(
      title: '',
      imageLink: (rawItems?.isNotEmpty ?? false)
          ? rawItems?.entries.first.value.imageLink ?? GraphicsFoundation.instance.png.welcomeSlide1.path
          : GraphicsFoundation.instance.png.welcomeSlide1.path,
      autoSwitchDuration: (rawItems?.isNotEmpty ?? false)
          ? rawItems?.entries.first.value.duration ?? const Duration(milliseconds: 5000)
          : const Duration(milliseconds: 5000),
    );
    lastBodyItem = OnBoardingPageItem(
      title: '',
      imageLink: (rawItems?.isNotEmpty ?? false)
          ? rawItems?.entries.last.value.imageLink ?? GraphicsFoundation.instance.png.welcomeSlide2.path
          : GraphicsFoundation.instance.png.welcomeSlide2.path,
      autoSwitchDuration: (rawItems?.isNotEmpty ?? false)
          ? rawItems?.entries.last.value.duration ?? const Duration(milliseconds: 5000)
          : const Duration(milliseconds: 5000),
    );
  }

  @override
  State<WelcomeComponent> createState() => _WelcomeComponentState();
}

class _WelcomeComponentState extends State<WelcomeComponent> with SingleTickerProviderStateMixin {
  late final animationController = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 10000),
  );
  CrossFadeState crossFadeState = CrossFadeState.showFirst;
  bool loading = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      animationController.forward(from: 0);
      animationController.addListener(() {
        if (animationController.isCompleted) setState(() => crossFadeState = CrossFadeState.showSecond);
      });
    });
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bigHeight = 1.sh > 568;

    return SizedBox(
      height: 1.sh,
      width: 1.sw,
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 500),
        transitionBuilder: (child, animation) => FadeTransition(
          opacity: animation,
          child: child,
        ),
        child: crossFadeState == CrossFadeState.showFirst
            ? _FirstBody(
                bigScreen: bigHeight,
                animationController: animationController,
                onNextPressed: () => setState(() => crossFadeState = CrossFadeState.showSecond),
                backgroundImage: widget.firstBodyItem.imageLink,
              )
            : _LastBody(
                loading: loading,
                bigScreen: bigHeight,
                onFinished: () {
                  widget.onFinished?.call();
                  setState(() => loading = true);
                },
                backgroundImage: widget.lastBodyItem.imageLink,
              ),
      ),
    );
  }
}
