import 'package:flutter/material.dart';
import 'package:shuffle_components_kit/services/navigation_service/navigation_key.dart';
import 'package:shuffle_uikit/shuffle_uikit.dart';

class PriceSelectorComponent extends StatelessWidget {
  final String? initialPrice1;
  final String? initialPrice2;
  final String? initialCurrency;
  final Function(String price1, String price2, String currency) onSubmit;

  PriceSelectorComponent({super.key, required this.onSubmit, this.initialPrice1, this.initialPrice2, this.initialCurrency}) {
    price1 = TextEditingController(text: initialPrice1);
    price2 = TextEditingController(text: initialPrice2);
    currency.value = initialCurrency?? 'AED';
  }

  late final TextEditingController price1;
  late final TextEditingController price2;

  final ValueNotifier<String> currency = ValueNotifier('AED');

  final _currencies = {
    'RUB': GraphicsFoundation.instance.svg.russia.path,
    'USD': GraphicsFoundation.instance.svg.unitedKingdom.path,
    // 'hi' : GraphicsFoundation.instance.svg.india.path,
    'AED': GraphicsFoundation.instance.svg.arabic.path,
  };

  @override
  Widget build(BuildContext context) {
    final theme = context.uiKitTheme;
    return Scaffold(
      body: BlurredAppBarPage(
        title: S.of(context).Price,
        autoImplyLeading: true,
        centerTitle: true,
        childrenPadding: EdgeInsets.symmetric(horizontal: SpacingFoundation.horizontalSpacing16),
        children: [
          SpacingFoundation.verticalSpace24,
          Row(
            children: [
              Text(
                S.of(context).AverageBill,
                style: theme?.boldTextTheme.title2,
              ),
              SpacingFoundation.horizontalSpace16,
              Builder(
                builder: (context) {
                  return GestureDetector(
                    onTap: () => showUiKitPopover(
                      context,
                      customMinHeight: 35.h,
                      showButton: false,
                      title: Text(
                        S.of(context).HintAverageBill,
                        style: theme?.regularTextTheme.body.copyWith(
                          color: Colors.black87,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    child: ImageWidget(
                      iconData: ShuffleUiKitIcons.info,
                      width: 16.w,
                      color: theme?.colorScheme.darkNeutral900,
                    ),
                  );
                },
              ),
            ],
          ),
          SpacingFoundation.verticalSpace24,
          Row(
            children: [
              Expanded(
                  child: UiKitInputFieldNoIcon(
                controller: price1,
                fillColor: theme?.colorScheme.surface3,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
              )),
              SpacingFoundation.horizontalSpace4,
              Text(
                '–',
                style: theme?.boldTextTheme.title2,
              ),
              SpacingFoundation.horizontalSpace4,
              Expanded(
                  child: UiKitInputFieldNoIcon(
                controller: price2,
                fillColor: theme?.colorScheme.surface3,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
              )),
            ],
          ),
          SpacingFoundation.verticalSpace24,
          ListenableBuilder(
              listenable: currency,
              builder: (context, _) {
                return UiKitMenu<String>(
                    useCustomTiles: true,
                    separator: SpacingFoundation.verticalSpace16,
                    title: S.of(context).SelectLanguage,
                    borderRadius: BorderRadiusFoundation.max,
                    tilesColor: context.uiKitTheme?.colorScheme.surface1,
                    selectedItem: UiKitMenuItem<String>(
                      title: currency.value,
                      value: currency.value,
                      iconLink: _currencies[currency.value],
                    ),
                    customTopPadding: 0.3.sh,
                    items: List.generate(
                      _currencies.length,
                      (index) => UiKitMenuItem(
                        title: _currencies.keys.toList()[index],
                        value: _currencies.keys.toList()[index],
                        iconLink: _currencies.values.toList()[index],
                        // enabled: _currencies.keys.toList()[index] == currency.value,
                      ),
                    ),
                    onSelected: (menuItem) {
                      if (menuItem.value != null) {
                        currency.value = menuItem.value!;
                        navigatorKey.currentState?.pop();
                      }
                    });
              })
        ],
      ),
      bottomNavigationBar: SizedBox(
          height: 60.h,
          child: ListenableBuilder(
              listenable: Listenable.merge([price1, price2, currency]),
              builder: (context, _) {
                if (price1.text.isNotEmpty) {
                  return context
                      .gradientButton(
                          data: BaseUiKitButtonData(
                              fit: ButtonFit.fitWidth,
                              text: S.of(context).Save.toUpperCase(),
                              onPressed: () {
                                onSubmit(price1.text, price2.text, currency.value);
                                Navigator.of(context).pop();
                              }))
                      .paddingOnly(bottom: MediaQuery.viewPaddingOf(context).bottom);
                }
                return const SizedBox.shrink();
              })),
    );
  }
}
