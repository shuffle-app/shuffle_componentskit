import 'package:flutter/material.dart';
import 'package:shuffle_components_kit/presentation/components/components.dart';
import 'package:shuffle_uikit/shuffle_uikit.dart';

class PromoBudgetCreationComponent extends StatefulWidget {
  final ValueChanged<BudgetUiModel> onBudgetDrafted;

  const PromoBudgetCreationComponent({super.key, required this.onBudgetDrafted});

  @override
  State<PromoBudgetCreationComponent> createState() => _PromoBudgetCreationComponentState();
}

class _PromoBudgetCreationComponentState extends State<PromoBudgetCreationComponent> {
  final TextEditingController _dailyBudgetController = TextEditingController();
  final TextEditingController _cpcBudgetController = TextEditingController();
  final TextEditingController _totalBudgetController = TextEditingController();

  @override
  void initState() {
    FocusManager.instance.addListener(_updateBudget);
    super.initState();
  }

  _updateBudget() {
    widget.onBudgetDrafted.call(BudgetUiModel(
        dailyBudget: _dailyBudgetController.text.isEmpty
            ? null
            : int.tryParse(_dailyBudgetController.text.replaceAll('\$', '').replaceAll(' ', '').trim()),
        averageCpc: _cpcBudgetController.text.isEmpty
            ? null
            : double.tryParse(
                _cpcBudgetController.text.replaceAll(',', '.').replaceAll('\$', '').replaceAll(' ', '').trim()),
        generalBudget: _totalBudgetController.text.isEmpty
            ? null
            : int.tryParse(_totalBudgetController.text.replaceAll('\$', '').replaceAll(' ', '').trim())));
  }

  @override
  void dispose() {
    FocusManager.instance.removeListener(_updateBudget);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.uiKitTheme;
    final colorScheme = theme?.colorScheme;
    final labelStyle = theme?.regularTextTheme.labelLarge;
    final captionStyle = theme?.regularTextTheme.caption2.copyWith(color: ColorsFoundation.mutedText);
    return BlurredAppBarPage(
      autoImplyLeading: true,
      centerTitle: true,
      title: S.current.BudgetLabel,
      childrenPadding: EdgeInsets.symmetric(
          horizontal: SpacingFoundation.horizontalSpacing12, vertical: SpacingFoundation.verticalSpacing4),
      children: [
        SpacingFoundation.verticalSpace2,
        UiKitWrappedInputField.uiKitInputFieldNoIcon(
          enabled: true,
          label: Text(
            S.current.DailyBudget,
            style: labelStyle,
          ),
          hintText: '50 \$',
          controller: _dailyBudgetController,
          fillColor: colorScheme?.surface3,
          // validator: widget.credentialsValidator,
          keyboardType: TextInputType.number,
          textInputAction: TextInputAction.next,
          inputFormatters: [PriceWithSpacesFormatter(currency: '\$')],
        ),
        SpacingFoundation.verticalSpace2,
        UiKitWrappedInputField.uiKitInputFieldNoIcon(
          enabled: true,
          label: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                S.current.AverageCPC,
                style: labelStyle,
              ),
              Builder(
                builder: (context) => GestureDetector(
                  onTap: () => showUiKitPopover(
                    context,
                    customMinHeight: 30.h,
                    showButton: false,
                    title: Text(
                      S.of(context).SupportedFormatsVideo,
                      style: theme?.regularTextTheme.body.copyWith(color: Colors.black87),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  child: ImageWidget(
                    iconData: ShuffleUiKitIcons.info,
                    width: 16.w,
                    color: theme?.colorScheme.darkNeutral900,
                  ),
                ),
              ),
              Text(
                '${S.current.Recommended}\n0.20\$',
                style: captionStyle,
                textAlign: TextAlign.end,
              ),
            ],
          ),
          hintText: '0.20 \$',
          controller: _cpcBudgetController,
          fillColor: colorScheme?.surface3,
          inputFormatters: [PriceWithSpacesFormatter(currency: '\$')],
          // validator: widget.credentialsValidator,
          keyboardType: TextInputType.numberWithOptions(decimal: true),
          textInputAction: TextInputAction.next,
        ),
        SpacingFoundation.verticalSpace2,
        UiKitWrappedInputField.uiKitInputFieldNoIcon(
          enabled: true,
          label: Text(
            S.current.GeneralBudget,
            style: labelStyle,
          ),
          hintText: '1000 \$',
          controller: _totalBudgetController,
          fillColor: colorScheme?.surface3,
          // validator: widget.credentialsValidator,
          keyboardType: TextInputType.number,
          textInputAction: TextInputAction.next,
          inputFormatters: [PriceWithSpacesFormatter(currency: '\$')],
        ),
      ],
    );
  }
}
