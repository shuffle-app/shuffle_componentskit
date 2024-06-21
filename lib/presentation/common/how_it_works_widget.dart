import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:shuffle_uikit/shuffle_uikit.dart';
import 'dart:developer' as developer;

import '../../domain/data_uimodels/hint_card_ui_model.dart';

class HowItWorksWidget extends StatelessWidget {
  final String title;
  final String subtitle;
  final List<HintCardUiModel> hintTiles;
  final Offset? customOffset;

  // final
  final VoidCallback? onPop;

  const HowItWorksWidget({
    super.key,
    required this.subtitle,
    required this.title,
    required this.hintTiles,
    this.onPop,
    this.customOffset,
  });

  _howItWorksDialog(_, textStyle) => UiKitHintDialog(
        title: title,
        subtitle: subtitle,
        textStyle: textStyle,
        dismissText: S.current.OkayCool.toUpperCase(),
        onDismiss: () {
          onPop?.call();

          return Navigator.pop(_);
        },
        hintTiles: hintTiles
            .map<UiKitIconHintCard>(
              (e) => UiKitIconHintCard(
                hint: e.title,
                icon: ImageWidget(
                  link: e.imageUrl,
                  height: 74.h,
                  fit: BoxFit.fitHeight,
                ),
              ),
            )
            .toList(),
      );

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    // final model

    // final

    return Transform.rotate(
      angle: pi * -20 / 180,
      child: RotatableWidget(
        animDuration: const Duration(milliseconds: 150),
        endAngle: pi * 20 / 180,
        alignment: Alignment.center,
        applyReverseOnEnd: true,
        startDelay: Duration(seconds: Random().nextInt(8) + 2),
        child: UiKitBlurredQuestionChip(
          label: S.of(context).HowItWorks,
          onTap: () => showUiKitFullScreenAlertDialog(
            context,
            child: _howItWorksDialog,
            paddingAll: EdgeInsetsFoundation.all12,
          ),
          // onTap: () {
          //   developer.log('ON TAP');
          // },
        ),
      ),
    );
  }
}

class CustomTextWithWidget extends MultiChildRenderObjectWidget {
  final Text text;

  CustomTextWithWidget({required this.text, required Widget widget})
      : super(children: [text, widget]);

  @override
  RenderObject createRenderObject(BuildContext context) {
    return RenderCustomTextWithWidget(
        textDirection: Directionality.of(context));
  }

  @override
  void updateRenderObject(
      BuildContext context, covariant RenderCustomTextWithWidget renderObject) {
    renderObject.textDirection = Directionality.of(context);
  }
}

class RenderCustomTextWithWidget extends RenderBox
    with
        ContainerRenderObjectMixin<RenderBox, CustomTextWithWidgetParentData>,
        RenderBoxContainerDefaultsMixin<RenderBox,
            CustomTextWithWidgetParentData> {
  RenderCustomTextWithWidget({
    required TextDirection textDirection,
  })  : _textDirection = textDirection,
        _textPainter = TextPainter(textDirection: textDirection);

  final TextPainter _textPainter;
  TextDirection _textDirection;

  TextDirection get textDirection => _textDirection;
  set textDirection(TextDirection value) {
    if (_textDirection != value) {
      _textDirection = value;
      _textPainter.textDirection = value;
      markNeedsLayout();
    }
  }

  @override
  void setupParentData(RenderBox child) {
    if (child.parentData is! CustomTextWithWidgetParentData) {
      child.parentData = CustomTextWithWidgetParentData();
    }
  }

  @override
  void performLayout() {
    RenderBox? textBox = firstChild;
    RenderBox? widgetBox = childAfter(textBox!);

    textBox.layout(constraints, parentUsesSize: true);
    final textParentData = textBox.parentData as CustomTextWithWidgetParentData;
    textParentData.offset = Offset.zero;

    //TODO KOSTL
    if (widgetBox != null) {
      developer.log('textBox.size.heinght!!! ${textBox.size.height}');
      developer.log('heinght ${54.h}');

      developer.log('textBox.size.width ${textBox.size.width}');
      developer.log('1.sw ${1.sw - SpacingFoundation.horizontalSpacing32}');

      widgetBox.layout(constraints.loosen(), parentUsesSize: true);
      final widgetParentData =
          widgetBox.parentData as CustomTextWithWidgetParentData;
      //TODO KOSTL
      widgetParentData.offset = Offset(
          textBox.size.width != (1.sw - SpacingFoundation.horizontalSpacing32)
              ? textBox.size.width
              : textBox.size.width - 45.w,
          textBox.size.height != 54.h ? 0 : 20);
    }

    size = constraints.constrain(Size(
      textBox.size.width + (widgetBox?.size.width ?? 0),
      max(textBox.size.height, widgetBox?.size.height ?? 0),
    ));
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    RenderBox? textBox = firstChild;
    RenderBox? widgetBox = childAfter(textBox!);

    final textParentData = textBox.parentData as CustomTextWithWidgetParentData;
    context.paintChild(textBox, offset + textParentData.offset);

    if (widgetBox != null) {
      final widgetParentData =
          widgetBox.parentData as CustomTextWithWidgetParentData;
      context.paintChild(widgetBox, offset + widgetParentData.offset);
    }
  }

  @override
  bool hitTestChildren(BoxHitTestResult result, {required Offset position}) {
    RenderBox? child = lastChild;
    while (child != null) {
      final CustomTextWithWidgetParentData childParentData =
          child.parentData as CustomTextWithWidgetParentData;
      if (result.addWithPaintOffset(
        offset: childParentData.offset,
        position: position,
        hitTest: (BoxHitTestResult result, Offset transformed) {
          assert(transformed == position - childParentData.offset);
          return child!.hitTest(result, position: transformed);
        },
      )) {
        return true;
      }
      child = childParentData.previousSibling;
    }

    return false;
  }
}

class CustomTextWithWidgetParentData
    extends ContainerBoxParentData<RenderBox> {}
