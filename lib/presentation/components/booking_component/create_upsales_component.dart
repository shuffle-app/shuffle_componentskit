import 'package:flutter/material.dart';
import 'package:shuffle_components_kit/presentation/components/booking_component/booking_ui_model/upsale_ui_model.dart';
import 'package:shuffle_components_kit/presentation/presentation.dart';
import 'package:shuffle_uikit/shuffle_uikit.dart';
import 'package:image_picker/image_picker.dart';
import 'package:auto_size_text/auto_size_text.dart';

class CreateUpsalesComponent extends StatefulWidget {
  final UpsaleUiModel? upsaleUiModel;
  final Function(UpsaleUiModel upsaleUiModel) onSave;

  const CreateUpsalesComponent({
    super.key,
    this.upsaleUiModel,
    required this.onSave,
  });

  @override
  State<CreateUpsalesComponent> createState() => _CreateUpsalesComponentState();
}

class _CreateUpsalesComponentState extends State<CreateUpsalesComponent> {
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _limitController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late UpsaleUiModel _upsaleUiModel;

  BaseUiKitMedia _photo = UiKitMediaPhoto(link: '');

  @override
  void initState() {
    super.initState();
    _upsaleUiModel = widget.upsaleUiModel ?? UpsaleUiModel(id: -1);
    _priceController.text = widget.upsaleUiModel?.price ?? '';
    _limitController.text = widget.upsaleUiModel?.limit ?? '';
    _descriptionController.text = widget.upsaleUiModel?.description ?? '';
    _photo = widget.upsaleUiModel?.photo ?? UiKitMediaPhoto(link: '');
  }

  @override
  void didUpdateWidget(covariant CreateUpsalesComponent oldWidget) {
    if (oldWidget.upsaleUiModel != oldWidget.upsaleUiModel) {
      _upsaleUiModel = widget.upsaleUiModel ?? UpsaleUiModel(id: -1);
      _priceController.text = widget.upsaleUiModel?.price ?? '';
      _limitController.text = widget.upsaleUiModel?.limit ?? '';
      _descriptionController.text = widget.upsaleUiModel?.description ?? '';
      _photo = widget.upsaleUiModel?.photo ?? UiKitMediaPhoto(link: '');
    }
    super.didUpdateWidget(oldWidget);
  }

  _onAddPhoto() async {
    final file = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (file != null) {
      setState(() {
        _photo = UiKitMediaPhoto(link: file.path);
      });
    }
  }

  _onPhotoDeleted() {
    setState(() {
      _photo = UiKitMediaPhoto(link: '');
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.uiKitTheme;

    return Scaffold(
      body: BlurredAppBarPage(
        customTitle: Expanded(
          child: AutoSizeText(
            S.of(context).Upsales,
            style: theme?.boldTextTheme.title1,
            textAlign: TextAlign.center,
            wrapWords: false,
          ),
        ),
        customToolbarBaseHeight: 1.sw <= 380 ? 0.17.sh : 0.12.sh,
        centerTitle: true,
        autoImplyLeading: true,
        childrenPadding: EdgeInsets.symmetric(horizontal: SpacingFoundation.horizontalSpacing16),
        children: [
          SpacingFoundation.verticalSpace16,
          RowWithAddPhoto(
            onPhotoDeleted: _onPhotoDeleted,
            onAddPhoto: _onAddPhoto,
            link: _photo.link,
          ),
          SpacingFoundation.verticalSpace24,
          IntrinsicHeight(
            child: Form(
              key: _formKey,
              child: UiKitInputFieldNoFill(
                label: S.of(context).Description,
                expands: true,
                maxSymbols: 150,
                validator: descriptionValidator,
                controller: _descriptionController,
                inputFormatters: [MaxLengthTextInputFormatter(150)],
                onChanged: (value) {
                  _formKey.currentState!.validate();
                },
              ),
            ),
          ),
          SpacingFoundation.verticalSpace24,
          UiKitInputFieldNoFill(
            label: S.of(context).Limit,
            controller: _limitController,
            inputFormatters: [OnlyNumbersFormatter()],
            keyboardType: TextInputType.number,
            onChanged: (value) {
              setState(() {
                _limitController.text = stringWithSpace(int.parse(value));
              });
            },
          ),
          SpacingFoundation.verticalSpace24,
          UiKitInputFieldNoFill(
            label: S.of(context).Price,
            readOnly: true,
            controller: _priceController,
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
                  initialCurrency: _upsaleUiModel.currency,
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
                      _upsaleUiModel.currency = currency;
                    });
                  },
                ),
              ),
            ),
          ),
          SpacingFoundation.verticalSpace24,
        ],
      ),
      bottomNavigationBar: context
          .gradientButton(
            data: BaseUiKitButtonData(
              text: S.of(context).Save.toUpperCase(),
              onPressed: () {
                if (_formKey.currentState!.validate() && _photo.link.isNotEmpty) {
                  _upsaleUiModel.description = _descriptionController.text;
                  _upsaleUiModel.limit = _limitController.text;
                  _upsaleUiModel.price = _priceController.text;
                  _upsaleUiModel.photo = _photo;
                  widget.onSave(_upsaleUiModel);
                  context.pop();
                }
              },
            ),
          )
          .paddingOnly(
            left: EdgeInsetsFoundation.all16,
            right: EdgeInsetsFoundation.all16,
            bottom: EdgeInsetsFoundation.vertical24,
          ),
    );
  }
}
