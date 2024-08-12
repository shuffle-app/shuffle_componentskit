import 'package:flutter/material.dart';
import 'package:shuffle_components_kit/presentation/presentation.dart';
import 'package:shuffle_uikit/shuffle_uikit.dart';
import 'package:image_picker/image_picker.dart';

import 'booking_ui_model/subs_or_upsale_ui_model.dart';

class CereatSubsComponent extends StatefulWidget {
  final SubsUiModel? subsUiModel;
  final Function(SubsUiModel subsUiModel) onSave;

  const CereatSubsComponent({
    super.key,
    this.subsUiModel,
    required this.onSave,
  });

  @override
  State<CereatSubsComponent> createState() => _CereatSubsComponentState();
}

class _CereatSubsComponentState extends State<CereatSubsComponent> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _limitController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late SubsUiModel _subsUiModel;

  BaseUiKitMedia _photo = UiKitMediaPhoto(link: '');

  @override
  void initState() {
    super.initState();
    _subsUiModel = widget.subsUiModel ?? SubsUiModel(id: -1);
    _titleController.text = widget.subsUiModel?.title ?? '';
    _limitController.text = widget.subsUiModel?.bookingLimit ?? '';
    _descriptionController.text = widget.subsUiModel?.description ?? '';
    _photo = widget.subsUiModel?.photo ?? UiKitMediaPhoto(link: '');
  }

  @override
  void didUpdateWidget(covariant CereatSubsComponent oldWidget) {
    if (oldWidget.subsUiModel != oldWidget.subsUiModel) {
      _subsUiModel = widget.subsUiModel ?? SubsUiModel(id: -1);
      _titleController.text = widget.subsUiModel?.title ?? '';
      _limitController.text = widget.subsUiModel?.bookingLimit ?? '';
      _descriptionController.text = widget.subsUiModel?.description ?? '';
      _photo = widget.subsUiModel?.photo ?? UiKitMediaPhoto(link: '');
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
    return Scaffold(
      body: Form(
        key: _formKey,
        child: BlurredAppBarPage(
          title: S.of(context).Subs,
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
              child: UiKitInputFieldNoFill(
                label: S.of(context).Title,
                expands: true,
                maxSymbols: 45,
                controller: _titleController,
                inputFormatters: [MaxLengthTextInputFormatter(45)],
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return S.of(context).PleaseEnterValidTitle;
                  } else if (value.length < 3) {
                    return S.of(context).PleaseEnterValidTitle;
                  }
                  return null;
                },
                onChanged: (value) {
                  _formKey.currentState!.validate();
                },
              ),
            ),
            SpacingFoundation.verticalSpace24,
            IntrinsicHeight(
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
            SpacingFoundation.verticalSpace24,
            UiKitInputFieldNoFill(
              label: S.of(context).BookingLimit,
              controller: _limitController,
              keyboardType: TextInputType.number,
              inputFormatters: [OnlyNumbersFormatter()],
              onChanged: (value) {
                setState(() {
                  _limitController.text = stringWithSpace(int.parse(value));
                });
              },
            ),
            SpacingFoundation.verticalSpace24,
          ],
        ),
      ),
      bottomNavigationBar: context
          .gradientButton(
            data: BaseUiKitButtonData(
              text: S.of(context).Save.toUpperCase(),
              onPressed: () {
                if (_formKey.currentState!.validate() && _photo.link.isNotEmpty) {
                  _subsUiModel.title = _titleController.text;
                  _subsUiModel.bookingLimit = _limitController.text;
                  _subsUiModel.description = _descriptionController.text;
                  _subsUiModel.photo = _photo;
                  widget.onSave(_subsUiModel);
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
