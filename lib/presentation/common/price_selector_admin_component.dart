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
    bool priceRangeSelected,
  ) onSubmit;

  PriceSelectorAdminComponent({
    super.key,
    required this.onSubmit,
    required this.isPriceRangeSelected,
    this.initialPriceRange1,
    this.initialPriceRange2,
    this.initialCurrency,
  }) {
    priceAverageController = TextEditingController(
        text: initialPriceRange1 != null
            ? PriceWithSpacesFormatter().formatStringUpdate(initialPriceRange1!)
            : initialPriceRange1);
    priceRangeController1 = TextEditingController(
        text: initialPriceRange1 != null
            ? PriceWithSpacesFormatter().formatStringUpdate(initialPriceRange1!)
            : initialPriceRange1);
    priceRangeController2 = TextEditingController(
        text: initialPriceRange2 != null
            ? PriceWithSpacesFormatter().formatStringUpdate(initialPriceRange2!)
            : initialPriceRange2);
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

  late bool _priceRageIsSelected;
  bool _selectOptionIsOpen = false;

  double? _wightItemSelecetOption;

  late final List<Color?>? listColor;

  final ValueNotifier<String?> _currency = ValueNotifier(null);

  final _currencies = {
    'RUB': GraphicsFoundation.instance.svg.russia.path,
    'USD': GraphicsFoundation.instance.svg.usFlag.path,
    // 'hi' : GraphicsFoundation.instance.svg.india.path,
    'AED': GraphicsFoundation.instance.svg.arabic.path,
  };

  @override
  void initState() {
    super.initState();
    _priceRageIsSelected = widget.isPriceRangeSelected;
  }

  void _getWightSelecetOption() {
    final renderObject = _keySelectoption.currentContext?.findRenderObject() as RenderBox;
    _wightItemSelecetOption = renderObject.size.width;
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
      return BorderRadiusFoundation.onlyTopt12;
    }
    if (index == _currencies.length - 1) {
      return BorderRadiusFoundation.onlyBottom12;
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
      widget.priceAverageController.text.removeTrailingDecimal(),
      widget.priceRangeController1.text.removeTrailingDecimal(),
      widget.priceRangeController2.text.removeTrailingDecimal(),
      _currency.value ?? 'AED',
      _priceRageIsSelected,
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
              child: UiKitRadio(selected: !_priceRageIsSelected),
              onTap: () {
                setState(() {
                  _priceRageIsSelected = false;
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
                textColor: _inputTextColor(!_priceRageIsSelected, theme),
                enabled: !_priceRageIsSelected,
                fillColor: theme?.colorScheme.surface,
                hintText: _getHintText(widget.initialPriceRange1),
                controller: widget.priceAverageController,
                inputFormatters: [PriceWithSpacesFormatter()],
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
              child: UiKitRadio(selected: _priceRageIsSelected),
              onTap: () {
                setState(() {
                  _priceRageIsSelected = true;
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
                    textColor: _inputTextColor(_priceRageIsSelected, theme),
                    enabled: _priceRageIsSelected,
                    fillColor: theme?.colorScheme.surface,
                    hintText: _getHintText(widget.initialPriceRange1),
                    controller: widget.priceRangeController1,
                    inputFormatters: [PriceWithSpacesFormatter()],
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
                ImageWidget(
                  iconData: ShuffleUiKitIcons.minus,
                  width: 20.w,
                  color: theme?.colorScheme.inversePrimary,
                ).paddingSymmetric(
                  vertical: SpacingFoundation.verticalSpacing20,
                  horizontal: SpacingFoundation.horizontalSpacing8,
                ),
                Expanded(
                  child: Form(
                    key: _formKey,
                    child: UiKitInputFieldNoIcon(
                      borderRadius: BorderRadiusFoundation.all12,
                      textColor: _inputTextColor(_priceRageIsSelected, theme),
                      enabled: _priceRageIsSelected,
                      fillColor: theme?.colorScheme.surface,
                      hintText: widget.initialPriceRange2 ?? '500',
                      controller: widget.priceRangeController2,
                      inputFormatters: [PriceWithSpacesFormatter()],
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      onTapOutside: (_) => _priceRangeController2IsLess(),
                      onSubmitted: (_) => _priceRangeController2IsLess(),
                      validator: (value) {
                        if ((value != null && value.isNotEmpty) && (widget.priceRangeController1.text != '')) {
                          final newValue = double.parse(value.replaceAll(' ', ''));

                          if (newValue < double.parse(widget.priceRangeController1.text.replaceAll(' ', ''))) {
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
                      width: _wightItemSelecetOption,
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
