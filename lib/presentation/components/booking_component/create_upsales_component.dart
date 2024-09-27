import 'package:flutter/material.dart';
import 'package:shuffle_components_kit/presentation/presentation.dart';
import 'package:shuffle_uikit/shuffle_uikit.dart';
import 'package:image_picker/image_picker.dart';
import 'package:auto_size_text/auto_size_text.dart';

class CreateUpsalesComponent extends StatefulWidget {
  final UpsaleUiModel? upsaleUiModel;
  final Function(UpsaleUiModel upsaleUiModel) onSave;
  final String? currency;

  const CreateUpsalesComponent({
    super.key,
    this.upsaleUiModel,
    this.currency,
    required this.onSave,
  });

  @override
  State<CreateUpsalesComponent> createState() => _CreateUpsalesComponentState();
}

class _CreateUpsalesComponentState extends State<CreateUpsalesComponent> {
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _limitController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  late XFile? file;
  late UpsaleUiModel _upsaleUiModel;

  String? _validateText;

  String? _photoPath;

  @override
  void initState() {
    super.initState();
    _upsaleUiModel = widget.upsaleUiModel ?? UpsaleUiModel(id: -1);
    _priceController.text = widget.upsaleUiModel?.price ?? '';
    _limitController.text = widget.upsaleUiModel?.limit ?? '';
    _descriptionController.text = widget.upsaleUiModel?.description ?? '';
    _photoPath = widget.upsaleUiModel?.photoPath ?? '';
  }

  @override
  void didUpdateWidget(covariant CreateUpsalesComponent oldWidget) {
    if (oldWidget.upsaleUiModel != oldWidget.upsaleUiModel) {
      _upsaleUiModel = widget.upsaleUiModel ?? UpsaleUiModel(id: -1);
      _priceController.text = widget.upsaleUiModel?.price ?? '';
      _limitController.text = widget.upsaleUiModel?.limit ?? '';
      _descriptionController.text = widget.upsaleUiModel?.description ?? '';
      _photoPath = widget.upsaleUiModel?.photoPath ?? '';
    }
    super.didUpdateWidget(oldWidget);
  }

  _validateCreation() {
    setState(() {
      _validateText = _upsaleUiModel.validateCreation();
    });
  }

  _onAddPhoto() async {
    final file = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (file != null) {
      setState(() {
        _photoPath = file.path;
      });
    }
  }

  _onPhotoDeleted() {
    setState(() {
      _photoPath = '';
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
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        childrenPadding: EdgeInsets.symmetric(horizontal: SpacingFoundation.horizontalSpacing16),
        children: [
          SpacingFoundation.verticalSpace16,
          RowWithAddPhoto(
            onPhotoDeleted: _onPhotoDeleted,
            onAddPhoto: _onAddPhoto,
            link: _photoPath ?? '',
          ),
          SpacingFoundation.verticalSpace24,
          IntrinsicHeight(
            child: UiKitInputFieldNoFill(
              label: S.of(context).Description,
              expands: true,
              maxSymbols: 150,
              controller: _descriptionController,
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
            controller: _priceController,
            keyboardType: TextInputType.number,
            inputFormatters: [PriceWithSpacesFormatter()],
            onTap: () {
              final list = _priceController.text.split(' ');
              list.removeLast();
              _priceController.text = list.join(' ');
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
        ],
      ),
      bottomNavigationBar: SizedBox(
        height: 1.sw <= 380 ? 80.h : 65.h,
        width: double.infinity,
        child: Column(
          children: [
            if (_validateText != null)
              Text(
                _validateText!,
                style: context.uiKitTheme?.boldTextTheme.body.copyWith(color: ColorsFoundation.error),
              ),
            SpacingFoundation.verticalSpace10,
            Row(
              children: [
                Expanded(
                  child: context
                      .gradientButton(
                        data: BaseUiKitButtonData(
                          text: S.of(context).Save.toUpperCase(),
                          onPressed: () {
                            _upsaleUiModel.description = _descriptionController.text.trim();
                            _upsaleUiModel.limit = _limitController.text;
                            _upsaleUiModel.price = _priceController.text;
                            _upsaleUiModel.photoPath = _photoPath;

                            _validateCreation();
                            if (_validateText == null) {
                              widget.onSave(_upsaleUiModel);
                              context.pop();
                            }
                          },
                        ),
                      )
                      .paddingOnly(
                        left: EdgeInsetsFoundation.all16,
                        right: EdgeInsetsFoundation.all16,
                      ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
