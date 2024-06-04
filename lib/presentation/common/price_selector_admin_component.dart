import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shuffle_components_kit/services/navigation_service/navigation_key.dart';
import 'package:shuffle_uikit/shuffle_uikit.dart';

class PriceSelectorAdminComponent extends StatefulWidget {
  PriceSelectorAdminComponent({super.key}) {
    priceAverageController = TextEditingController();
    priceRangeController1 = TextEditingController();
    priceRangeController2 = TextEditingController();
  }

  late final TextEditingController priceAverageController;
  late final TextEditingController priceRangeController1;
  late final TextEditingController priceRangeController2;

  @override
  State<PriceSelectorAdminComponent> createState() => _PriceSelectorAdminComponentState();
}

class _PriceSelectorAdminComponentState extends State<PriceSelectorAdminComponent> {
  bool _averageIsSelected = true;

  final _textInputFormaterPriceSelector = FilteringTextInputFormatter.allow(RegExp(r'^\d*([.,]?\d*)$'));

  final ValueNotifier<String> _currency = ValueNotifier('AED');

  final _currencies = {
    'RUB': GraphicsFoundation.instance.svg.russia.path,
    'USD': GraphicsFoundation.instance.svg.unitedKingdom.path,
    // 'hi' : GraphicsFoundation.instance.svg.india.path,
    'AED': GraphicsFoundation.instance.svg.arabic.path,
  };

  @override
  Widget build(BuildContext context) {
    final theme = context.uiKitTheme;
    return Padding(
      padding: EdgeInsets.all(SpacingFoundation.horizontalSpacing40),
      child: Column(
        children: [
          //TODO SpacingFoundation.verticalSpace32
          SizedBox(height: SpacingFoundation.verticalSpacing32),
          Row(
            children: [
              GestureDetector(
                child: UiKitRadio(selected: _averageIsSelected),
                onTap: () {
                  setState(() {
                    _averageIsSelected = true;
                  });
                  // _submit();
                },
              ),
              SpacingFoundation.horizontalSpace12,
              Text(
                S.of(context).AverageBill,
                style: theme?.regularTextTheme.labelLarge,
              ),
            ],
          ),
          SpacingFoundation.verticalSpace16,
          Row(
            children: [
              Expanded(
                child: UiKitInputFieldNoIcon(
                  enabled: _averageIsSelected,
                  hintText: '100',
                  controller: widget.priceAverageController,
                  fillColor: theme?.colorScheme.surface3,
                  inputFormatters: [_textInputFormaterPriceSelector],
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  //_submit(),
                  onChanged: (value) {},
                ),
              ),
            ],
          ),
          SpacingFoundation.verticalSpace24,
          Row(
            children: [
              GestureDetector(
                child: UiKitRadio(selected: !_averageIsSelected),
                onTap: () {
                  setState(() {
                    _averageIsSelected = false;
                  });
                  // _submit();
                },
              ),
              SpacingFoundation.horizontalSpace12,
              Text(
                'Price range',
                style: theme?.regularTextTheme.labelLarge,
              ),
            ],
          ),
          SpacingFoundation.verticalSpace16,
          Row(
            children: [
              Expanded(
                child: UiKitInputFieldNoIcon(
                  // textColor: _inputTextColor(!_averageIsSelected, theme),
                  enabled: !_averageIsSelected,
                  hintText: '100',
                  controller: widget.priceRangeController1,
                  fillColor: theme?.colorScheme.surface3,
                  inputFormatters: [_textInputFormaterPriceSelector],
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  // onChanged: (value) => _submit(),
                ),
              ),
              SpacingFoundation.horizontalSpace8,
              ImageWidget(
                iconData: ShuffleUiKitIcons.minus,
                width: 20.w,
                color: theme?.colorScheme.inversePrimary,
              ),
              SpacingFoundation.horizontalSpace8,
              Expanded(
                child: UiKitInputFieldNoIcon(
                  // textColor: _inputTextColor(!_averageIsSelected, theme),
                  enabled: !_averageIsSelected,
                  hintText: '500',
                  controller: widget.priceRangeController2,
                  inputFormatters: [_textInputFormaterPriceSelector],
                  fillColor: theme?.colorScheme.surface3,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  // onChanged: (value) => _submit(),
                ),
              ),
            ],
          ),
          SpacingFoundation.verticalSpace24,
          Text(
            'Select currency',
            style: theme?.regularTextTheme.labelLarge,
          ),
          ListenableBuilder(
            listenable: _currency,
            builder: (context, _) {
              return UiKitMenu<String>(
                useCustomTiles: true,
                separator: SpacingFoundation.verticalSpace16,
                title: S.of(context).SelectCurrency,
                borderRadius: BorderRadiusFoundation.max,
                tilesColor: context.uiKitTheme?.colorScheme.surface1,
                selectedItem: UiKitMenuItem<String>(
                  title: _currency.value,
                  value: _currency.value,
                  iconLink: _currencies[_currency.value],
                ),
                customTopPadding: 0.3.sh,
                items: List.generate(
                  _currencies.length,
                  (index) => UiKitMenuItem(
                    title: _currencies.keys.toList()[index],
                    value: _currencies.keys.toList()[index],
                    iconLink: _currencies.values.toList()[index],
                  ),
                ),
                onSelected: (menuItem) {
                  if (menuItem.value != null) {
                    _currency.value = menuItem.value!;
                    navigatorKey.currentState?.pop();
                  }
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
