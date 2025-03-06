import 'package:flutter/material.dart';
import 'package:shuffle_components_kit/services/navigation_service/navigation_key.dart';
import 'package:shuffle_uikit/shuffle_uikit.dart';

class PriceSelectorComponent extends StatefulWidget {
  final bool isPriceRangeSelected;
  final String? initialPriceRangeStart;
  final String? initialPriceRangeEnd;
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
    this.initialPriceRangeStart,
    this.initialPriceRangeEnd,
    this.initialCurrency,
  }) {
    priceAverageController = TextEditingController(
        text: initialPriceRangeStart != null
            ? PriceWithSpacesFormatter().formatStringUpdate(initialPriceRangeStart!)
            : initialPriceRangeStart);
    priceRangeControllerStart = TextEditingController(
        text: initialPriceRangeStart != null
            ? PriceWithSpacesFormatter().formatStringUpdate(initialPriceRangeStart!)
            : initialPriceRangeStart);
    priceRangeControllerEnd = TextEditingController(
        text: initialPriceRangeEnd != null
            ? PriceWithSpacesFormatter().formatStringUpdate(initialPriceRangeEnd!)
            : initialPriceRangeEnd);
  }

  late final TextEditingController priceAverageController;
  late final TextEditingController priceRangeControllerStart;
  late final TextEditingController priceRangeControllerEnd;

  @override
  State<PriceSelectorComponent> createState() => _PriceSelectorComponentState();
}

class _PriceSelectorComponentState extends State<PriceSelectorComponent> {
  late final ValueNotifier<String> _currency = ValueNotifier('AED');

  final _currencies = {
    'RUB': GraphicsFoundation.instance.svg.russia.path,
    'BAT': GraphicsFoundation.instance.svg.thailand.path,
    'USD': GraphicsFoundation.instance.svg.usFlag.path,
    // 'hi' : GraphicsFoundation.instance.svg.india.path,
    'AED': GraphicsFoundation.instance.svg.arabic.path,
  };

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  late bool _averageIsSelected;

  @override
  void initState() {
    super.initState();
    _currency.value = widget.initialCurrency ?? 'AED';
    _averageIsSelected = widget.isPriceRangeSelected;
  }

  void _submit() {
    widget.onSubmit(
      widget.priceAverageController.text.removeTrailingDecimal(),
      widget.priceRangeControllerStart.text.removeTrailingDecimal(),
      widget.priceRangeControllerEnd.text.removeTrailingDecimal(),
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
        widget.priceRangeControllerEnd.text = '';
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
      return initialPriceRange.isNotEmpty ? PriceWithSpacesFormatter().formatStringUpdate(initialPriceRange) : '100';
    }
    return '100';
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.uiKitTheme;
    return Form(
      child: Column(
        children: [
          SpacingFoundation.verticalSpace16,
          Text(
            S.of(context).EnterPrice,
            style: theme?.boldTextTheme.title2,
          ),
          SpacingFoundation.verticalSpace16,
          GestureDetector(
              onTap: () {
                _priceRangeController2IsLess();

                setState(() {
                  _averageIsSelected = false;
                });
                _submit();
              },
              child: Row(
                children: [
                  UiKitRadio(selected: !_averageIsSelected),
                  SpacingFoundation.horizontalSpace12,
                  Text(
                    S.of(context).AverageBill,
                    style: theme?.boldTextTheme.subHeadline,
                  ),
                ],
              )),
          SpacingFoundation.verticalSpace16,
          Row(
            children: [
              Expanded(
                child: UiKitInputFieldNoIcon(
                  enabled: !_averageIsSelected,
                  textColor: _inputTextColor(!_averageIsSelected, theme),
                  hintText: _getHintText(widget.initialPriceRangeStart),
                  controller: widget.priceAverageController,
                  fillColor: theme?.colorScheme.surface3,
                  inputFormatters: [PriceWithSpacesFormatter()],
                  keyboardType: const TextInputType.numberWithOptions(),
                  onTapOutside: (_) => _priceRangeController2IsLess(),
                  onChanged: (value) => _submit(),
                ),
              ),
            ],
          ),
          SpacingFoundation.verticalSpace24,
          GestureDetector(
              onTap: () {
                setState(() {
                  _averageIsSelected = true;
                });
                _submit();
              },
              child: Row(
                children: [
                  UiKitRadio(selected: _averageIsSelected),
                  SpacingFoundation.horizontalSpace12,
                  Text(
                    S.of(context).PriceRange,
                    style: theme?.boldTextTheme.subHeadline,
                  ),
                ],
              )),
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
                      hintText: _getHintText(widget.initialPriceRangeStart),
                      controller: widget.priceRangeControllerStart,
                      fillColor: theme?.colorScheme.surface3,
                      inputFormatters: [PriceWithSpacesFormatter()],
                      keyboardType: const TextInputType.numberWithOptions(),
                      onTapOutside: (_) => _priceRangeController2IsLess(),
                      onSubmitted: (_) => _priceRangeController2IsLess(),
                      onTap: () => _priceRangeController2IsLess(),
                      onChanged: (value) {
                        setState(() {
                          _priceRangeController2IsLessBool();
                        });
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
                        hintText: widget.initialPriceRangeEnd ?? '500',
                        controller: widget.priceRangeControllerEnd,
                        inputFormatters: [PriceWithSpacesFormatter()],
                        fillColor: theme?.colorScheme.surface3,
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        onTapOutside: (_) => _priceRangeController2IsLess(),
                        onSubmitted: (_) => _priceRangeController2IsLess(),
                        validator: (value) {
                          if ((value != null && value.isNotEmpty) && (widget.priceRangeControllerStart.text != '')) {
                            final newValue = double.parse(value.replaceAll(' ', ''));

                            if (newValue < double.parse(widget.priceRangeControllerStart.text.replaceAll(' ', ''))) {
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
    ).paddingSymmetric(horizontal: SpacingFoundation.horizontalSpacing16);
  }
}
