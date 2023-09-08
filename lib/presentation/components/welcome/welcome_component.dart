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
    Key? key,
    this.onFinished,
  }) : super(key: key) {
    model = ComponentModel.fromJson(GlobalConfiguration().appConfig.content['welcome']);
    final rawItems =
        model.content.body?.entries.firstWhere((element) => element.key == ContentItemType.onboardingCard).value.properties;
    firstBodyItem = OnBoardingPageItem(
      imageLink: rawItems?.entries.first.value.imageLink ?? '',
      title: rawItems?.entries.first.key ?? '',
      autoSwitchDuration: rawItems?.entries.first.value.duration ?? const Duration(milliseconds: 5000),
    );
    lastBodyItem = OnBoardingPageItem(
      imageLink: rawItems?.entries.last.value.imageLink ?? '',
      title: rawItems?.entries.last.key ?? '',
      autoSwitchDuration: rawItems?.entries.last.value.duration ?? const Duration(milliseconds: 5000),
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

    return Scaffold(
      body: AnimatedCrossFade(
        duration: const Duration(milliseconds: 500),
        crossFadeState: crossFadeState,
        firstChild: _FirstBody(
          bigScreen: bigHeight,
          animationController: animationController,
          onNextPressed: () => setState(() => crossFadeState = CrossFadeState.showSecond),
          backgroundImage: widget.firstBodyItem.imageLink,
        ),
        secondChild: _LastBody(
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