import 'package:flutter/material.dart';
import 'package:shuffle_components_kit/presentation/common/price_selector_component.dart';
import 'package:shuffle_components_kit/presentation/components/booking_component/booking_ui_model/booking_ui_model.dart';
import 'package:shuffle_components_kit/presentation/components/booking_component/booking_ui_model/subs_or_upsale_ui_model.dart';
import 'package:shuffle_components_kit/presentation/components/booking_component/booking_ui_model/upsale_ui_model.dart';
import 'package:shuffle_components_kit/presentation/components/booking_component/cereat_subs_component.dart';
import 'package:shuffle_components_kit/presentation/components/booking_component/create_upsales_component.dart';
import 'package:shuffle_uikit/shuffle_uikit.dart';

class CreateBookingComponent extends StatefulWidget {
  final Function(BookingUiModel) onBookingCreated;

  final BookingUiModel? bookingUiModel;

  const CreateBookingComponent({
    super.key,
    this.bookingUiModel,
    required this.onBookingCreated,
  });

  @override
  State<CreateBookingComponent> createState() => _CreateBookingComponentState();
}

class _CreateBookingComponentState extends State<CreateBookingComponent> {
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _bookingLimitController = TextEditingController();
  final TextEditingController _bookingLimitPerOneController = TextEditingController();
  late BookingUiModel _bookingUiModel;

  final List<SubsUiModel> _subsUiMoldels = [];
  final List<UpsaleUiModel> _upsaleUiModels = [];

  @override
  void initState() {
    super.initState();
    _bookingUiModel = widget.bookingUiModel ?? BookingUiModel(id: -1);
    _priceController.text = widget.bookingUiModel?.price ?? '';
    _bookingLimitController.text = widget.bookingUiModel?.bookingLimit ?? '';
    _bookingLimitPerOneController.text = widget.bookingUiModel?.bookingLimitPerOne ?? '';
    _subsUiMoldels.addAll(_bookingUiModel.subsUiModel != null ? _bookingUiModel.subsUiModel! : []);
    _upsaleUiModels.addAll(_bookingUiModel.upsaleUiModel != null ? _bookingUiModel.upsaleUiModel! : []);
  }

  _removeSubsItem(int index) {
    setState(() {
      _subsUiMoldels.removeAt(index);
    });
  }

  _removeUpsaleItem(int index) {
    setState(() {
      _upsaleUiModels.removeAt(index);
    });
  }

  @override
  void didUpdateWidget(covariant CreateBookingComponent oldWidget) {
    if (oldWidget.bookingUiModel != widget.bookingUiModel) {
      _bookingUiModel = widget.bookingUiModel ?? BookingUiModel(id: -1);
      _priceController.text = widget.bookingUiModel?.price ?? '';
      _bookingLimitController.text = widget.bookingUiModel?.bookingLimit ?? '';
      _bookingLimitPerOneController.text = widget.bookingUiModel?.bookingLimitPerOne ?? '';
      _subsUiMoldels.clear();
      _upsaleUiModels.clear();
      _subsUiMoldels.addAll(_bookingUiModel.subsUiModel != null ? _bookingUiModel.subsUiModel! : []);
      _upsaleUiModels.addAll(_bookingUiModel.upsaleUiModel != null ? _bookingUiModel.upsaleUiModel! : []);
    }

    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.uiKitTheme;

    return Scaffold(
      body: BlurredAppBarPage(
        title: S.of(context).Booking,
        centerTitle: true,
        autoImplyLeading: true,
        childrenPadding: EdgeInsets.symmetric(horizontal: SpacingFoundation.horizontalSpacing16),
        children: [
          SpacingFoundation.verticalSpace16,
          UiKitInputFieldNoFill(
            label: S.of(context).Price,
            onTap: () => showUiKitGeneralFullScreenDialog(
              context,
              GeneralDialogData(
                topPadding: 1.sw <= 380 ? 0.12.sh : 0.37.sh,
                useRootNavigator: false,
                child: PriceSelectorComponent(
                  isPriceRangeSelected: _priceController.text.contains('-'),
                  initialPriceRangeStart: _priceController.text.split('-').first,
                  initialPriceRangeEnd:
                      _priceController.text.contains('-') ? _priceController.text.split('-').last : null,
                  initialCurrency: _bookingUiModel.currency,
                  onSubmit: (averagePrice, rangePrice1, rangePrice2, currency, averageSelected) {
                    setState(() {
                      if (averageSelected) {
                        _priceController.text = '$averagePrice $currency';
                      } else {
                        _priceController.text = rangePrice1;
                        if (rangePrice2.isNotEmpty && rangePrice1.isNotEmpty) {
                          _priceController.text += '-$rangePrice2 $currency';
                        }
                      }
                      _bookingUiModel.currency = currency;
                    });
                  },
                ),
              ),
            ),
            readOnly: true,
            controller: _priceController,
          ),
          SpacingFoundation.verticalSpace24,
          UiKitInputFieldNoFill(
            label: S.of(context).BookingLimit,
            controller: _bookingLimitController,
            keyboardType: TextInputType.number,
            onChanged: (value) {
              setState(() {
                _bookingLimitController.text = stringWithSpace(int.parse(value));
              });
            },
          ),
          SpacingFoundation.verticalSpace24,
          UiKitInputFieldNoFill(
            label: S.of(context).BookingLimitPerOne,
            controller: _bookingLimitPerOneController,
            keyboardType: TextInputType.number,
            onChanged: (value) {
              setState(() {
                _bookingLimitPerOneController.text = stringWithSpace(int.parse(value));
              });
            },
          ),
          SpacingFoundation.verticalSpace24,
          Text(
            S.of(context).CreateSubs,
            style: theme?.boldTextTheme.title2,
          ),
          SpacingFoundation.verticalSpace16,
          SizedBox(
            height: _subsUiMoldels.isNotEmpty ? (1.sw <= 380 ? 0.27.sh : 0.20.sh) : (1.sw <= 380 ? 0.21.sh : 0.13.sh),
            child: ListView.separated(
              shrinkWrap: true,
              itemCount: _subsUiMoldels.length + 1,
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              separatorBuilder: (context, index) => SpacingFoundation.horizontalSpace8,
              itemBuilder: (context, index) {
                if (index == 0) {
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      context
                          .badgeButtonNoValue(
                            data: BaseUiKitButtonData(
                              onPressed: () {
                                context.push(
                                  CereatSubsComponent(
                                    onSave: (subsUiModel) {
                                      setState(() {
                                        _subsUiMoldels.add(subsUiModel);
                                      });
                                    },
                                  ),
                                );
                              },
                              iconWidget: DecoratedBox(
                                decoration: BoxDecoration(
                                  shape: BoxShape.rectangle,
                                  border: Border.fromBorderSide(
                                    BorderSide(
                                      color: context.uiKitTheme!.colorScheme.darkNeutral400.withOpacity(0.4),
                                      width: 2,
                                    ),
                                  ),
                                  borderRadius: BorderRadiusFoundation.all12,
                                ),
                                child: GradientableWidget(
                                  gradient: GradientFoundation.defaultLinearGradient,
                                  child: const ImageWidget(
                                    iconData: ShuffleUiKitIcons.gradientPlus,
                                    height: 45,
                                    width: 45,
                                  ).paddingAll(EdgeInsetsFoundation.all32),
                                ),
                              ),
                            ),
                          )
                          .paddingOnly(top: 4),
                    ],
                  );
                } else {
                  final sabsItem = _subsUiMoldels[index - 1];

                  return SubsOrUpsaleItem(
                    limit: sabsItem.bookingLimit,
                    titleOrPrice: sabsItem.title,
                    photoLink: sabsItem.photo?.link,
                    actualLimit: sabsItem.actualbookingLimit,
                    description: sabsItem.description,
                    removeItem: () => _removeSubsItem(index - 1),
                    onEdit: () {
                      context.push(
                        CereatSubsComponent(
                          onSave: (subsUiModel) {
                            setState(() {
                              _bookingUiModel.subsUiModel?[index - 1] = subsUiModel;
                            });
                          },
                          subsUiModel: sabsItem,
                        ),
                      );
                    },
                  );
                }
              },
            ),
          ),
          SpacingFoundation.verticalSpace24,
          Text(
            S.of(context).CreateUpsales,
            style: theme?.boldTextTheme.title2,
          ),
          SpacingFoundation.verticalSpace16,
          SizedBox(
            height: _upsaleUiModels.isNotEmpty ? (1.sw <= 380 ? 0.27.sh : 0.20.sh) : (1.sw <= 380 ? 0.21.sh : 0.13.sh),
            child: ListView.separated(
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemCount: _upsaleUiModels.length + 1,
              separatorBuilder: (context, index) => SpacingFoundation.horizontalSpace8,
              itemBuilder: (context, index) {
                if (index == 0) {
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      context
                          .badgeButtonNoValue(
                            data: BaseUiKitButtonData(
                              onPressed: () {
                                context.push(
                                  CreateUpsalesComponent(
                                    onSave: (upsaleUiModel) {
                                      setState(() {
                                        _upsaleUiModels.add(upsaleUiModel);
                                      });
                                    },
                                  ),
                                );
                              },
                              iconWidget: DecoratedBox(
                                decoration: BoxDecoration(
                                  shape: BoxShape.rectangle,
                                  border: Border.fromBorderSide(
                                    BorderSide(
                                      color: context.uiKitTheme!.colorScheme.darkNeutral400.withOpacity(0.4),
                                      width: 2,
                                    ),
                                  ),
                                  borderRadius: BorderRadiusFoundation.all12,
                                ),
                                child: GradientableWidget(
                                  gradient: GradientFoundation.defaultLinearGradient,
                                  child: const ImageWidget(
                                    iconData: ShuffleUiKitIcons.gradientPlus,
                                    height: 45,
                                    width: 45,
                                  ).paddingAll(EdgeInsetsFoundation.all32),
                                ),
                              ),
                            ),
                          )
                          .paddingOnly(top: 4),
                    ],
                  );
                } else {
                  final upsaleItem = _upsaleUiModels[index - 1];

                  return SubsOrUpsaleItem(
                    description: upsaleItem.description,
                    limit: upsaleItem.limit,
                    isSubs: false,
                    actualLimit: upsaleItem.actualLimit,
                    photoLink: upsaleItem.photo?.link,
                    titleOrPrice: (upsaleItem.price != null && upsaleItem.price!.isNotEmpty)
                        ? upsaleItem.price
                        : S.of(context).Free,
                    removeItem: () => _removeUpsaleItem(index - 1),
                    onEdit: () {
                      context.push(
                        CreateUpsalesComponent(
                          onSave: (upsaleUiModel) {
                            setState(() {
                              _bookingUiModel.upsaleUiModel?[index - 1] = upsaleUiModel;
                            });
                          },
                          upsaleUiModel: upsaleItem,
                        ),
                      );
                    },
                  );
                }
              },
            ),
          ),
          SafeArea(
            child: context.gradientButton(
              data: BaseUiKitButtonData(
                text: S.of(context).Save.toUpperCase(),
                onPressed: () {
                  _bookingUiModel.price = _priceController.text;
                  _bookingUiModel.bookingLimit = _bookingLimitController.text;
                  _bookingUiModel.bookingLimitPerOne = _bookingLimitPerOneController.text;
                  _bookingUiModel.subsUiModel = _subsUiMoldels;
                  _bookingUiModel.upsaleUiModel = _upsaleUiModels;
                  widget.onBookingCreated(_bookingUiModel);
                  context.pop();
                },
              ),
            ),
          ),
          SpacingFoundation.verticalSpace24,
        ],
      ),
    );
  }
}