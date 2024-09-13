import 'package:flutter/material.dart';
import 'package:shuffle_uikit/shuffle_uikit.dart';
import 'package:image_picker/image_picker.dart';

import 'booking_ui_model/subs_ui_model.dart';

class CreateSubsComponent extends StatefulWidget {
  final SubsUiModel? subsUiModel;
  final Function(SubsUiModel subsUiModel) onSave;

  const CreateSubsComponent({
    super.key,
    this.subsUiModel,
    required this.onSave,
  });

  @override
  State<CreateSubsComponent> createState() => _CreateSubsComponentState();
}

class _CreateSubsComponentState extends State<CreateSubsComponent> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _limitController = TextEditingController();
  late XFile? file;
  late SubsUiModel _subsUiModel;

  String? _validateText;

  String _photoPath = '';

  @override
  void initState() {
    super.initState();
    _subsUiModel = widget.subsUiModel ?? SubsUiModel(id: -1);
    _titleController.text = widget.subsUiModel?.title ?? '';
    _limitController.text = widget.subsUiModel?.bookingLimit ?? '';
    _descriptionController.text = widget.subsUiModel?.description ?? '';
    _photoPath = widget.subsUiModel?.photoPath ?? '';
  }

  @override
  void didUpdateWidget(covariant CreateSubsComponent oldWidget) {
    if (oldWidget.subsUiModel != oldWidget.subsUiModel) {
      _subsUiModel = widget.subsUiModel ?? SubsUiModel(id: -1);
      _titleController.text = widget.subsUiModel?.title ?? '';
      _limitController.text = widget.subsUiModel?.bookingLimit ?? '';
      _descriptionController.text = widget.subsUiModel?.description ?? '';
      _photoPath = widget.subsUiModel?.photoPath ?? '';
    }
    super.didUpdateWidget(oldWidget);
  }

  _validateCreation() {
    setState(() {
      _validateText = _subsUiModel.validateCreation();
    });
  }

  _onAddPhoto() async {
    file = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (file != null) {
      setState(() {
        _photoPath = file!.path;
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
    return Scaffold(
      body: BlurredAppBarPage(
        title: S.of(context).Subs,
        centerTitle: true,
        autoImplyLeading: true,
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        childrenPadding: EdgeInsets.symmetric(horizontal: SpacingFoundation.horizontalSpacing16),
        children: [
          SpacingFoundation.verticalSpace16,
          RowWithAddPhoto(
            onPhotoDeleted: _onPhotoDeleted,
            onAddPhoto: _onAddPhoto,
            link: _photoPath,
          ),
          SpacingFoundation.verticalSpace24,
          IntrinsicHeight(
            child: UiKitInputFieldNoFill(
              label: S.of(context).Title,
              expands: true,
              maxSymbols: 45,
              controller: _titleController,
            ),
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
            label: S.of(context).BookingLimit,
            controller: _limitController,
            keyboardType: TextInputType.number,
            inputFormatters: [PriceWithSpacesFormatter(allowDecimal: false)],
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
                            _subsUiModel.title = _titleController.text.trim();
                            _subsUiModel.bookingLimit = _limitController.text;
                            _subsUiModel.description = _descriptionController.text.trim();
                            _subsUiModel.photoPath = _photoPath;
                            _validateCreation();

                            if (_validateText == null) {
                              widget.onSave(_subsUiModel);
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
