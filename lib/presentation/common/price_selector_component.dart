import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shuffle_components_kit/services/navigation_service/navigation_key.dart';
import 'package:shuffle_uikit/shuffle_uikit.dart';

class PriceSelectorComponent extends StatefulWidget {
  final bool isPriceRangeSelected;
  final String? initialPriceRange1;
  final String? initialPriceRange2;
  final String? initialCurrency;
  final Function(
    String averagePrice,
    String rangePrice1,
    String rangePrice2,
    String currency,
    bool averageSelected,
  ) onSubmit;

  PriceSelectorComponent({
    super.key,
    required this.onSubmit,
    required this.isPriceRangeSelected,
    this.initialPriceRange1,
    this.initialPriceRange2,
    this.initialCurrency,
  }) {
    priceAverageController = TextEditingController(text: initialPriceRange1);
    priceRangeController1 = TextEditingController(text: initialPriceRange1);
    priceRangeController2 = TextEditingController(text: initialPriceRange2);
  }

  late final TextEditingController priceAverageController;
  late final TextEditingController priceRangeController1;
  late final TextEditingController priceRangeController2;

  @override
  State<PriceSelectorComponent> createState() => _PriceSelectorComponentState();
}

class _PriceSelectorComponentState extends State<PriceSelectorComponent> {
  late final ValueNotifier<String> _currency = ValueNotifier('AED');

  final _currencies = {
    'RUB': GraphicsFoundation.instance.svg.russia.path,
    'USD': GraphicsFoundation.instance.svg.unitedKingdom.path,
    // 'hi' : GraphicsFoundation.instance.svg.india.path,
    'AED': GraphicsFoundation.instance.svg.arabic.path,
  };

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  late bool _averageIsSelected;

  final _textInputFormaterPriceSelector = FilteringTextInputFormatter.allow(RegExp(r'^\d*([.,]?\d*)$'));

  @override
  void initState() {
    super.initState();
    _currency.value = widget.initialCurrency ?? 'AED';
    _averageIsSelected = widget.isPriceRangeSelected;
  }

  void _submit() {
    widget.onSubmit(
      widget.priceAverageController.text,
      widget.priceRangeController1.text,
      widget.priceRangeController2.text,
      _currency.value,
      !_averageIsSelected,
    );
  }

  Color? _inputTextColor(
    bool isSelected,
    UiKitThemeData? theme,
  ) {
    return isSelected ? theme?.boldTextTheme.caption1Medium.color : ColorsFoundation.darkNeutral900.withOpacity(0.16);
  }

  void _priceRangeController2IsLess() {
    if (_formKey.currentState != null) {
      if (!_formKey.currentState!.validate()) {
        widget.priceRangeController2.text = '';
      }
    }
    _submit();
  }

  bool _priceRangeController2IsLessBool() {
    if (_formKey.currentState != null) {
      return !_formKey.currentState!.validate();
    } else {
      return false;
    }
  }

  String _getHintText(String? initialPriceRange) {
    if (initialPriceRange != null) {
      return initialPriceRange.isNotEmpty ? widget.initialPriceRange1! : '100';
    }
    return '100';
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.uiKitTheme;
    return Form(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: SpacingFoundation.horizontalSpacing16),
        child: Column(
          children: [
            SpacingFoundation.verticalSpace16,
            Text(
              S.of(context).EnterPrice,
              style: theme?.boldTextTheme.title2,
            ),
            SpacingFoundation.verticalSpace16,
            Row(
              children: [
                GestureDetector(
                  child: UiKitRadio(selected: !_averageIsSelected),
                  onTap: () {
                    _priceRangeController2IsLess();

                    setState(() {
                      _averageIsSelected = false;
                    });
                    _submit();
                  },
                ),
                SpacingFoundation.horizontalSpace12,
                Text(
                  S.of(context).AverageBill,
                  style: theme?.boldTextTheme.subHeadline,
                ),
              ],
            ),
            SpacingFoundation.verticalSpace16,
            Row(
              children: [
                Expanded(
                  child: UiKitInputFieldNoIcon(
                    enabled: !_averageIsSelected,
                    textColor: _inputTextColor(!_averageIsSelected, theme),
                    hintText: _getHintText(widget.initialPriceRange1),
                    controller: widget.priceAverageController,
                    fillColor: theme?.colorScheme.surface3,
                    inputFormatters: [_textInputFormaterPriceSelector],
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    onTapOutside: (_) => _priceRangeController2IsLess(),
                    onChanged: (value) => _submit(),
                  ),
                ),
              ],
            ),
            SpacingFoundation.verticalSpace24,
            Row(
              children: [
                GestureDetector(
                  child: UiKitRadio(selected: _averageIsSelected),
                  onTap: () {
                    setState(() {
                      _averageIsSelected = true;
                    });
                    _submit();
                  },
                ),
                SpacingFoundation.horizontalSpace12,
                Text(
                  S.of(context).PriceRange,
                  style: theme?.boldTextTheme.subHeadline,
                ),
              ],
            ),
            SpacingFoundation.verticalSpace16,
            Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: UiKitInputFieldNoIcon(
                        textColor: _inputTextColor(_averageIsSelected, theme),
                        enabled: _averageIsSelected,
                        hintText: _getHintText(widget.initialPriceRange2),
                        controller: widget.priceRangeController1,
                        fillColor: theme?.colorScheme.surface3,
                        inputFormatters: [_textInputFormaterPriceSelector],
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        onTapOutside: (_) => _priceRangeController2IsLess(),
                        onSubmitted: (_) => _priceRangeController2IsLess(),
                        onTap: () => _priceRangeController2IsLess(),
                        onChanged: (value) {
                          _priceRangeController2IsLess();
                          _submit();
                        },
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: SpacingFoundation.verticalSpacing20,
                        horizontal: SpacingFoundation.horizontalSpacing8,
                      ),
                      child: ImageWidget(
                        iconData: ShuffleUiKitIcons.minus,
                        width: 20.w,
                        color: theme?.colorScheme.inversePrimary,
                      ),
                    ),
                    Expanded(
                      child: Form(
                        key: _formKey,
                        child: UiKitInputFieldNoIcon(
                          textColor: _inputTextColor(_averageIsSelected, theme),
                          enabled: _averageIsSelected,
                          hintText: widget.initialPriceRange2 ?? '500',
                          controller: widget.priceRangeController2,
                          inputFormatters: [_textInputFormaterPriceSelector],
                          fillColor: theme?.colorScheme.surface3,
                          keyboardType: const TextInputType.numberWithOptions(decimal: true),
                          onTapOutside: (_) => _priceRangeController2IsLess(),
                          onSubmitted: (_) => _priceRangeController2IsLess(),
                          validator: (value) {
                            if ((value != null && value.isNotEmpty) && (widget.priceRangeController1.text != '')) {
                              if (int.parse(value) < int.parse(widget.priceRangeController1.text)) {
                                return '';
                              }
                              return null;
                            } else {
                              return null;
                            }
                          },
                          onChanged: (value) {
                            setState(() {
                              _priceRangeController2IsLessBool();
                            });
                            _formKey.currentState!.validate();
                          },
                        ),
                      ),
                    ),
                  ],
                ),
                _priceRangeController2IsLessBool()
                    ? Text(
                        S.of(context).RangeEndValueIsLessThanBeginingOne,
                        style: theme?.regularTextTheme.caption1.copyWith(color: ColorsFoundation.error),
                      )
                    : SpacingFoundation.none
              ],
            ),
            SpacingFoundation.verticalSpace24,
            Row(
              children: [
                Text(
                  S.of(context).SelectCurrency,
                  style: theme?.boldTextTheme.subHeadline,
                ),
              ],
            ),
            SpacingFoundation.verticalSpace16,
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
                      _submit();
                    }
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
