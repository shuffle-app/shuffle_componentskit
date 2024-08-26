import 'package:flutter/material.dart';
import 'package:shuffle_uikit/shuffle_uikit.dart';
import 'package:image_picker/image_picker.dart';

import 'booking_ui_model/subs_or_upsale_ui_model.dart';

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
  void didUpdateWidget(covariant CreateSubsComponent oldWidget) {
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
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
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
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return S.of(context).PleaseEnterValidTitle;
                  } else if (value.length < 3) {
                    return S.of(context).PleaseEnterValidTitle;
                  }
                  return null;
                },
                onChanged: (value) {
                  setState(() {
                    _formKey.currentState!.validate();
                  });
                },
              ),
            ),
            SpacingFoundation.verticalSpace24,
            IntrinsicHeight(
              child: UiKitInputFieldNoFill(
                label: S.of(context).Description,
                expands: true,
                maxSymbols: 150,
                validator: (value) {
                  if (value == null || value.isEmpty || value.trim().isEmpty) {
                    return S.of(context).PleaseEnterValidDescription;
                  }
                  return null;
                },
                controller: _descriptionController,
                onChanged: (value) {
                  setState(() {
                    _formKey.currentState!.validate();
                  });
                },
              ),
            ),
            SpacingFoundation.verticalSpace24,
            UiKitInputFieldNoFill(
              label: S.of(context).BookingLimit,
              controller: _limitController,
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value != null && value.isEmpty) {
                  return S.of(context).PleaseEnterLimit;
                } else if (value != null && value.isNotEmpty) {
                  final newValue = int.parse(value.replaceAll(' ', ''));

                  if (newValue <= 0) {
                    return S.of(context).PleaseEnterCurrentLimit;
                  }
                  return null;
                }
                return null;
              },
              inputFormatters: [PriceWithSpacesFormatter(allowDecimal: false)],
              onChanged: (value) {
                setState(() {
                  _formKey.currentState?.validate();
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
                  _subsUiModel.title = _titleController.text.trim();
                  _subsUiModel.bookingLimit = _limitController.text;
                  _subsUiModel.description = _descriptionController.text.trim();
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