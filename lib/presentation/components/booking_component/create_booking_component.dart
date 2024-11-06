import 'package:flutter/material.dart';
import 'package:shuffle_components_kit/presentation/components/booking_component/booking_ui_model/booking_ui_model.dart';
import 'package:shuffle_components_kit/presentation/components/booking_component/booking_ui_model/subs_ui_model.dart';
import 'package:shuffle_components_kit/presentation/components/booking_component/booking_ui_model/upsale_ui_model.dart';
import 'package:shuffle_components_kit/presentation/components/booking_component/create_subs_component.dart';
import 'package:shuffle_components_kit/presentation/components/booking_component/create_upsales_component.dart';
import 'package:shuffle_uikit/shuffle_uikit.dart';

class CreateBookingComponent extends StatefulWidget {
  final Function(BookingUiModel) onBookingCreated;
  final BookingUiModel? bookingUiModel;
  final String? currency;
  final bool isViewMode;

  const CreateBookingComponent({
    super.key,
    this.bookingUiModel,
    this.currency,
    required this.onBookingCreated,
    this.isViewMode = false,
  });

  @override
  State<CreateBookingComponent> createState() => _CreateBookingComponentState();
}

class _CreateBookingComponentState extends State<CreateBookingComponent> {
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _bookingLimitController = TextEditingController();
  final TextEditingController _bookingLimitPerOneController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late BookingUiModel _bookingUiModel;

  final List<SubsUiModel> _subsUiModels = List.empty(growable: true);
  final List<UpsaleUiModel> _upsaleUiModels = List.empty(growable: true);

  int _allSubsLimitCount = 0;

  late final _plusGradient = widget.isViewMode
      ? GradientFoundation.defaultLinearGradientWithOpacity02
      : GradientFoundation.defaultLinearGradient;

  @override
  void initState() {
    super.initState();
    _bookingUiModel = widget.bookingUiModel ?? BookingUiModel(id: -1);
    _priceController.text = '${widget.bookingUiModel?.price ?? ''} ${widget.currency ?? 'AED'}';
    _bookingLimitController.text = widget.bookingUiModel?.bookingLimit ?? '';
    _bookingLimitPerOneController.text = widget.bookingUiModel?.bookingLimitPerOne ?? '';
    _subsUiModels.addAll(_bookingUiModel.subsUiModel != null ? _bookingUiModel.subsUiModel! : []);
    _upsaleUiModels.addAll(_bookingUiModel.upsaleUiModel != null ? _bookingUiModel.upsaleUiModel! : []);
    _countSubsLimit();
  }

  _removeSubsItem(int index) {
    setState(() {
      _subsUiModels.removeAt(index);
      _countSubsLimit();
    });
  }

  _removeUpsaleItem(int index) {
    setState(() {
      _upsaleUiModels.removeAt(index);
    });
  }

  void _countSubsLimit() {
    _allSubsLimitCount = 0;
    for (var element in _subsUiModels) {
      if (element.bookingLimit != null) {
        _allSubsLimitCount += int.tryParse(element.bookingLimit!.replaceAll(' ', '')) ?? 0;
      }
    }
    _formKey.currentState?.validate();
  }

  @override
  void didUpdateWidget(covariant CreateBookingComponent oldWidget) {
    if (oldWidget.bookingUiModel != widget.bookingUiModel) {
      _bookingUiModel = widget.bookingUiModel ?? BookingUiModel(id: -1);
      _priceController.text = '${widget.bookingUiModel?.price ?? ''} ${widget.currency ?? 'AED'}';
      _bookingLimitController.text = widget.bookingUiModel?.bookingLimit ?? '';
      _bookingLimitPerOneController.text = widget.bookingUiModel?.bookingLimitPerOne ?? '';
      _subsUiModels.clear();
      _upsaleUiModels.clear();
      _subsUiModels.addAll(_bookingUiModel.subsUiModel != null ? _bookingUiModel.subsUiModel! : []);
      _upsaleUiModels.addAll(_bookingUiModel.upsaleUiModel != null ? _bookingUiModel.upsaleUiModel! : []);
      _countSubsLimit();
    }

    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.uiKitTheme;

    return Scaffold(
      body: Form(
        key: _formKey,
        child: BlurredAppBarPage(
          title: S.of(context).Booking,
          centerTitle: true,
          autoImplyLeading: true,
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          childrenPadding: EdgeInsets.symmetric(horizontal: SpacingFoundation.horizontalSpacing16),
          children: [
            SpacingFoundation.verticalSpace16,
            UiKitInputFieldNoFill(
              readOnly: widget.isViewMode,
              customInputTextColor: widget.isViewMode ? ColorsFoundation.mutedText : null,
              customLabelColor: widget.isViewMode ? ColorsFoundation.mutedText : null,
              label: S.of(context).Price,
              controller: _priceController,
              keyboardType: TextInputType.number,
              inputFormatters: [PriceWithSpacesFormatter()],
              onTap: () {
                if (!widget.isViewMode && _priceController.text.contains(widget.currency ?? 'AED')) {
                  final list = _priceController.text.split(' ');
                  list.removeLast();
                  _priceController.text = list.join(' ');
                }
              },
              onFieldSubmitted: (value) {
                if (!_priceController.text.contains(widget.currency ?? 'AED')) {
                  _priceController.text = '${_priceController.text} ${widget.currency ?? 'AED'}';
                }
              },
              onTapOutside: (value) {
                if (!_priceController.text.contains(widget.currency ?? 'AED')) {
                  _priceController.text = '${_priceController.text} ${widget.currency ?? 'AED'}';
                }
              },
            ),
            SpacingFoundation.verticalSpace24,
            UiKitInputFieldNoFill(
              readOnly: widget.isViewMode,
              customInputTextColor: widget.isViewMode ? ColorsFoundation.mutedText : null,
              customLabelColor: widget.isViewMode ? ColorsFoundation.mutedText : null,
              label: S.of(context).BookingLimit,
              controller: _bookingLimitController,
              keyboardType: TextInputType.number,
              inputFormatters: [PriceWithSpacesFormatter(allowDecimal: false)],
              validator: (value) {
                if (value != null && value.isNotEmpty) {
                  final newValue = int.parse(value.replaceAll(' ', ''));

                  if (newValue == 0) {
                    return S.of(context).LimitMustBeGreaterThanZero;
                  }

                  if (newValue < _allSubsLimitCount) {
                    return S.of(context).LimitLessSumLimitsSubs;
                  }
                }
                return null;
              },
              onChanged: (value) {
                setState(() {
                  _formKey.currentState?.validate();
                });
              },
            ),
            SpacingFoundation.verticalSpace24,
            UiKitInputFieldNoFill(
              readOnly: widget.isViewMode,
              customInputTextColor: widget.isViewMode ? ColorsFoundation.mutedText : null,
              customLabelColor: widget.isViewMode ? ColorsFoundation.mutedText : null,
              label: S.of(context).BookingLimitPerOne,
              controller: _bookingLimitPerOneController,
              keyboardType: TextInputType.number,
              inputFormatters: [PriceWithSpacesFormatter(allowDecimal: false)],
              validator: (value) {
                if ((value != null && value.isNotEmpty)) {
                  final newValue = int.parse(value.replaceAll(' ', ''));

                  if (newValue == 0) {
                    return S.of(context).LimitMustBeGreaterThanZero;
                  }

                  if ((_bookingLimitController.text != '') &&
                      newValue >= int.parse(_bookingLimitController.text.replaceAll(' ', ''))) {
                    return S.of(context).LimitLessTotalLimit;
                  } else if (_allSubsLimitCount > 0 &&
                      newValue >= _allSubsLimitCount &&
                      _bookingLimitController.text.isEmpty) {
                    return S.of(context).LimitLessTotalLimit;
                  }
                  return null;
                } else {
                  return null;
                }
              },
              onChanged: (value) {
                setState(() {
                  _formKey.currentState?.validate();
                });
              },
            ),
            SpacingFoundation.verticalSpace24,
            Text(
              S.of(context).CreateSubs,
              style: theme?.boldTextTheme.title2,
            ),
            SpacingFoundation.verticalSpace16,
            if (_subsUiModels.isNotEmpty)
              Row(
                children: [
                  Expanded(
                    child: Text(
                      S.of(context).ShowInContentCard,
                      style: theme?.regularTextTheme.labelSmall,
                    ),
                  ),
                  UiKitGradientSwitch(
                    onChanged: widget.isViewMode
                        ? null
                        : (value) {
                            setState(() {
                              _bookingUiModel.showSubsInContentCard = !_bookingUiModel.showSubsInContentCard;
                            });
                          },
                    switchedOn: _bookingUiModel.showSubsInContentCard,
                  ),
                ],
              ).paddingOnly(bottom: SpacingFoundation.verticalSpacing24),
            SizedBox(
              height: _subsUiModels.isEmpty ? (1.sw <= 380 ? 0.25.sh : 0.2.sh) : (1.sw <= 380 ? 0.3.sh : 0.23.sh),
              child: ListView.separated(
                shrinkWrap: true,
                itemCount: _subsUiModels.length + 1,
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                separatorBuilder: (context, index) => SpacingFoundation.horizontalSpace8,
                itemBuilder: (context, index) {
                  if (index == 0) {
                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 0.28.sw,
                          width: 0.28.sw,
                          child: context
                              .badgeButtonNoValue(
                                data: BaseUiKitButtonData(
                                  onPressed: () {
                                    if (!widget.isViewMode) {
                                      context.push(
                                        CreateSubsComponent(
                                          onSave: (subsUiModel) {
                                            setState(() {
                                              _subsUiModels.add(subsUiModel);
                                              _countSubsLimit();
                                            });
                                          },
                                        ),
                                      );
                                    }
                                  },
                                  iconWidget: DecoratedBox(
                                    decoration: BoxDecoration(
                                      shape: BoxShape.rectangle,
                                      border: Border.fromBorderSide(
                                        BorderSide(
                                          color: context.uiKitTheme!.colorScheme.darkNeutral400
                                              .withOpacity(widget.isViewMode ? 0.2 : 0.4),
                                          width: 2,
                                        ),
                                      ),
                                      borderRadius: BorderRadiusFoundation.all12,
                                    ),
                                    child: GradientableWidget(
                                      gradient: _plusGradient,
                                      child: ImageWidget(
                                        iconData: ShuffleUiKitIcons.plus,
                                        height: 30.w,
                                        width: 30.w,
                                      ),
                                    ),
                                  ),
                                ),
                              )
                              .paddingOnly(top: 4),
                        ),
                      ],
                    );
                  } else {
                    final sabsItem = _subsUiModels[index - 1];

                    return SubsOrUpsaleItem(
                      isViewMode: widget.isViewMode,
                      limit: sabsItem.bookingLimit,
                      titleOrPrice: sabsItem.title,
                      photoLink: sabsItem.photoPath,
                      actualLimit: sabsItem.actualbookingLimit,
                      description: sabsItem.description,
                      removeItem: () {
                        if (!widget.isViewMode) {
                          _formKey.currentState?.validate();
                          _removeSubsItem(index - 1);
                          if (_subsUiModels.isEmpty) {
                            _bookingUiModel.showSubsInContentCard = false;
                          }
                        }
                      },
                      onEdit: () {
                        if (!widget.isViewMode) {
                          return context.push(
                            CreateSubsComponent(
                              onSave: (subsUiModel) {
                                setState(() {
                                  _countSubsLimit();
                                  _bookingUiModel.subsUiModel?[index - 1] = subsUiModel;
                                });
                              },
                              subsUiModel: sabsItem,
                            ),
                          );
                        }
                      },
                    );
                  }
                },
              ),
            ),
            Text(
              S.of(context).CreateUpsales,
              style: theme?.boldTextTheme.title2,
            ),
            SpacingFoundation.verticalSpace16,
            SizedBox(
              height: _upsaleUiModels.isEmpty ? (1.sw <= 380 ? 0.25.sh : 0.2.sh) : (1.sw <= 380 ? 0.3.sh : 0.2.sh),
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
                        SizedBox(
                          height: 0.28.sw,
                          width: 0.28.sw,
                          child: context
                              .badgeButtonNoValue(
                                data: BaseUiKitButtonData(
                                  onPressed: () {
                                    if (!widget.isViewMode) {
                                      context.push(
                                        CreateUpsalesComponent(
                                          currency: widget.currency,
                                          onSave: (upsaleUiModel) {
                                            setState(() {
                                              _upsaleUiModels.add(upsaleUiModel);
                                            });
                                          },
                                        ),
                                      );
                                    }
                                  },
                                  iconWidget: DecoratedBox(
                                    decoration: BoxDecoration(
                                      shape: BoxShape.rectangle,
                                      border: Border.fromBorderSide(
                                        BorderSide(
                                          color: context.uiKitTheme!.colorScheme.darkNeutral400
                                              .withOpacity(widget.isViewMode ? 0.2 : 0.4),
                                          width: 2,
                                        ),
                                      ),
                                      borderRadius: BorderRadiusFoundation.all12,
                                    ),
                                    child: GradientableWidget(
                                      gradient: _plusGradient,
                                      child: ImageWidget(
                                        height: 30.w,
                                        width: 30.w,
                                        iconData: ShuffleUiKitIcons.plus,
                                      ),
                                    ),
                                  ),
                                ),
                              )
                              .paddingOnly(top: 4),
                        ),
                      ],
                    );
                  } else {
                    final upsaleItem = _upsaleUiModels[index - 1];

                    return SubsOrUpsaleItem(
                      isViewMode: widget.isViewMode,
                      description: upsaleItem.description,
                      limit: upsaleItem.limit,
                      isSubs: false,
                      actualLimit: upsaleItem.actualLimit,
                      photoLink: upsaleItem.photoPath,
                      titleOrPrice: (upsaleItem.price != null && upsaleItem.price!.isNotEmpty)
                          ? upsaleItem.price
                          : S.of(context).Free,
                      removeItem: () {
                        if (!widget.isViewMode) _removeUpsaleItem(index - 1);
                      },
                      onEdit: () {
                        if (!widget.isViewMode) {
                          return context.push(
                            CreateUpsalesComponent(
                              currency: widget.currency,
                              onSave: (upsaleUiModel) {
                                setState(() {
                                  _bookingUiModel.upsaleUiModel?[index - 1] = upsaleUiModel;
                                });
                              },
                              upsaleUiModel: upsaleItem,
                            ),
                          );
                        }
                      },
                    );
                  }
                },
              ),
            ),
            if (!widget.isViewMode) ...[
              SafeArea(
                child: context.gradientButton(
                  data: BaseUiKitButtonData(
                    text: S.of(context).Save.toUpperCase(),
                    onPressed: () {
                      if (_formKey.currentState != null && _formKey.currentState!.validate()) {
                        _bookingUiModel.price = _priceController.text;
                        _bookingUiModel.bookingLimit = _bookingLimitController.text.isEmpty
                            ? _allSubsLimitCount.toString()
                            : _bookingLimitController.text;
                        _bookingUiModel.bookingLimitPerOne = _bookingLimitPerOneController.text;
                        _bookingUiModel.subsUiModel = _subsUiModels;
                        _bookingUiModel.upsaleUiModel = _upsaleUiModels;
                        widget.onBookingCreated(_bookingUiModel);
                      }
                    },
                  ),
                ),
              ),
              SpacingFoundation.verticalSpace24,
            ],
          ],
        ),
      ),
    );
  }
}
