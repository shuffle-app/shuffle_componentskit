import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shuffle_uikit/shuffle_uikit.dart';

class PriceSelectorAdminComponent extends StatefulWidget {
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

  PriceSelectorAdminComponent({
    super.key,
    required this.onSubmit,
    required this.isPriceRangeSelected,
    this.initialPriceRange1,
    this.initialPriceRange2,
    this.initialCurrency,
  }) {
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
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey _keySelectoption = GlobalKey();
  final MenuController _menuController = MenuController();

  late bool _averageIsSelected;
  bool _selectOptionIsOpen = false;

  double? _wightSelecetOption;

  late final List<Color?>? listColor;

  final _textInputFormaterPriceSelector = FilteringTextInputFormatter.allow(RegExp(r'^\d*([.,]?\d*)$'));

  final ValueNotifier<String?> _currency = ValueNotifier(null);

  final _currencies = {
    'RUB': GraphicsFoundation.instance.svg.russia.path,
    'USD': GraphicsFoundation.instance.svg.unitedKingdom.path,
    // 'hi' : GraphicsFoundation.instance.svg.india.path,
    'AED': GraphicsFoundation.instance.svg.arabic.path,
  };

  @override
  void initState() {
    super.initState();
    _averageIsSelected = widget.isPriceRangeSelected;
  }

  void _getWightSelecetOption() {
    final renderObject = _keySelectoption.currentContext?.findRenderObject() as RenderBox;
    _wightSelecetOption = renderObject.size.width;
  }

  void _generateListColorItemCurrencies(UiKitThemeData? theme) {
    listColor = List.generate(_currencies.length, (index) => theme?.colorScheme.surface3);
  }

  void _setListColorCurrencies(Color? color, int index) {
    setState(() {
      listColor?[index] = color;
    });
  }

  BorderRadius? _getBorderRadiusSelectedItem(int index) {
    if (_currencies.length == 1) {
      return BorderRadiusFoundation.all12;
    }
    if (index == 0) {
      //TODO onlyTopt12
      return const BorderRadius.only(
        topLeft: Radius.circular(12.0),
        topRight: Radius.circular(12.0),
      );
    }
    if (index == _currencies.length - 1) {
      //TODO onlyBottom12
      return const BorderRadius.only(
        bottomLeft: Radius.circular(12.0),
        bottomRight: Radius.circular(12.0),
      );
    }

    return null;
  }

  void _openOrCloseMenu() {
    if (!_selectOptionIsOpen) {
      _menuController.close();
    } else {
      _menuController.open();
    }
  }

  BoxBorder? _getBorderColorForSelcetOption(UiKitThemeData? theme) {
    if (theme != null) {
      return Border.all(color: _selectOptionIsOpen ? theme.colorScheme.inversePrimary : theme.colorScheme.surface);
    }
    return null;
  }

  Color? _inputTextColor(
    bool isSelected,
    UiKitThemeData? theme,
  ) {
    return isSelected
        ? theme?.boldTextTheme.caption1Medium.color
        : ColorsFoundation.lightBodyTypographyColor.withOpacity(0.48);
  }

  void _submit() {
    widget.onSubmit(
      widget.priceAverageController.text,
      widget.priceRangeController1.text,
      widget.priceRangeController2.text,
      _currency.value ?? 'AED',
      !_averageIsSelected,
    );
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: SpacingFoundation.verticalSpacing32),
        Row(
          children: [
            GestureDetector(
              child: UiKitRadio(selected: !_averageIsSelected),
              onTap: () {
                setState(() {
                  _averageIsSelected = false;
                });
                _submit();
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
                borderRadius: BorderRadiusFoundation.all12,
                textColor: _inputTextColor(!_averageIsSelected, theme),
                enabled: !_averageIsSelected,
                hintText: '100',
                controller: widget.priceAverageController,
                fillColor: theme?.colorScheme.surface,
                inputFormatters: [_textInputFormaterPriceSelector],
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
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
              style: theme?.regularTextTheme.labelLarge,
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
                    borderRadius: BorderRadiusFoundation.all12,
                    textColor: _inputTextColor(_averageIsSelected, theme),
                    enabled: _averageIsSelected,
                    fillColor: theme?.colorScheme.surface,
                    hintText: _getHintText(widget.initialPriceRange2),
                    controller: widget.priceRangeController1,
                    inputFormatters: [_textInputFormaterPriceSelector],
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
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
                      borderRadius: BorderRadiusFoundation.all12,
                      textColor: _inputTextColor(_averageIsSelected, theme),
                      enabled: _averageIsSelected,
                      hintText: widget.initialPriceRange2 ?? '500',
                      controller: widget.priceRangeController2,
                      inputFormatters: [_textInputFormaterPriceSelector],
                      fillColor: theme?.colorScheme.surface,
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
        Text(
          S.of(context).SelectCurrency,
          style: theme?.regularTextTheme.labelLarge,
        ),
        SpacingFoundation.verticalSpace16,
        MenuAnchor(
          onClose: () {
            setState(() {
              _selectOptionIsOpen = false;
            });
          },
          controller: _menuController,
          //TODO style
          style: MenuStyle(backgroundColor: WidgetStatePropertyAll<Color?>(theme?.colorScheme.surface3.withOpacity(1))),
          menuChildren: List.generate(
            _currencies.length,
            (index) {
              return MouseRegion(
                onEnter: (event) => _setListColorCurrencies(theme?.colorScheme.surface4, index),
                onExit: (event) => _setListColorCurrencies(theme?.colorScheme.surface3, index),
                child: ListenableBuilder(
                  listenable: _currency,
                  builder: (context, child) => GestureDetector(
                    onTap: () {
                      _currency.value = _currencies.keys.toList()[index];
                      setState(() {
                        _selectOptionIsOpen = false;
                      });
                      _openOrCloseMenu();
                      _submit();
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: listColor?[index],
                        borderRadius: _getBorderRadiusSelectedItem(index),
                      ),
                      width: _wightSelecetOption,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _currencies.keys.toList()[index],
                            style: theme?.regularTextTheme.body,
                          ).paddingSymmetric(
                            vertical: SpacingFoundation.verticalSpacing12,
                            horizontal: SpacingFoundation.horizontalSpacing12,
                          ),
                          index < _currencies.length - 1
                              ? Divider(
                                  height: 1.0,
                                  color: theme?.colorScheme.darkNeutral100.withOpacity(0.24),
                                )
                              : SpacingFoundation.none,
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
          builder: (context, _, child) {
            return GestureDetector(
              onTap: () {
                setState(() {
                  _selectOptionIsOpen = !_selectOptionIsOpen;
                });

                _openOrCloseMenu();
                _getWightSelecetOption();
                _generateListColorItemCurrencies(theme);
              },
              child: Container(
                key: _keySelectoption,
                decoration: BoxDecoration(
                  color: theme?.colorScheme.surface,
                  borderRadius: BorderRadiusFoundation.all12,
                  border: _getBorderColorForSelcetOption(theme),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      _currency.value ?? S.of(context).SelectOption,
                      style: theme?.regularTextTheme.body,
                    ),
                    const Spacer(),
                    ImageWidget(
                      iconData: _selectOptionIsOpen ? ShuffleUiKitIcons.chevronup : ShuffleUiKitIcons.chevrondown,
                      width: 12.w,
                      color: theme?.colorScheme.inversePrimary,
                    )
                  ],
                ).paddingAll(SpacingFoundation.horizontalSpacing16),
              ),
            );
          },
        ),
      ],
    );
  }
}
