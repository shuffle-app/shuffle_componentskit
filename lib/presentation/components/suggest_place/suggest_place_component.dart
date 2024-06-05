import 'package:flutter/material.dart';
import 'package:shuffle_components_kit/presentation/components/suggest_place/ui_suggest_place_model.dart';
import 'package:shuffle_uikit/shuffle_uikit.dart';

class SuggestPlaceComponent extends StatefulWidget {
  const SuggestPlaceComponent(
      {super.key,
      this.uiSuggestPlaceModel,
      required this.locationController,
      required this.titleController,
      required this.descriptionController,
      required this.onLocationTap,
      required this.onConfirm});

  final UiSuggestPlaceModel? uiSuggestPlaceModel;
  final TextEditingController locationController;
  final TextEditingController titleController;
  final TextEditingController descriptionController;
  final VoidCallback onLocationTap;
  final ValueChanged<UiSuggestPlaceModel> onConfirm;

  @override
  State<SuggestPlaceComponent> createState() => _SuggestPlaceComponentState();
}

class _SuggestPlaceComponentState extends State<SuggestPlaceComponent> {
  late TextEditingController locationController;
  late TextEditingController titleController;
  late TextEditingController descriptionController;

  @override
  void initState() {
    locationController = widget.locationController;
    titleController = widget.titleController;
    descriptionController = widget.descriptionController;
    if (widget.uiSuggestPlaceModel != null) {
      locationController.text = widget.uiSuggestPlaceModel?.location ?? '';
      titleController.text = widget.uiSuggestPlaceModel?.title ?? '';
      descriptionController.text =
          widget.uiSuggestPlaceModel?.description ?? '';
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SpacingFoundation.verticalSpace16,
          Text(
            'Submit Content',
            style: context.uiKitTheme?.boldTextTheme.title1,
          ),
          SpacingFoundation.verticalSpace16,
          UiKitInputFieldNoFill(
            controller: locationController,
            label: S.current.Location,
            hintText: S.current.EnterLocation,
            onChanged: (value) {
              setState(() {});
            },
            icon: InkWell(
              onTap: widget.onLocationTap,
              child: const Icon(
                ShuffleUiKitIcons.landmark,
                color: ColorsFoundation.darkBodyTypographyColor,
              ),
            ),
            customEnabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                color: context.uiKitTheme?.colorScheme.darkNeutral400 ??
                    Colors.transparent,
              ),
            ),
            customFocusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                color: context.uiKitTheme?.colorScheme.darkNeutral400 ??
                    Colors.transparent,
              ),
            ),
          ),
          SpacingFoundation.verticalSpace24,
          UiKitInputFieldNoFill(
            controller: titleController,
            label: S.current.Title,
            onChanged: (value) {
              setState(() {});
            },
            hintText: S.current.EnterTitle,
            customEnabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                color: context.uiKitTheme?.colorScheme.darkNeutral400 ??
                    Colors.transparent,
              ),
            ),
            customFocusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                color: context.uiKitTheme?.colorScheme.darkNeutral400 ??
                    Colors.transparent,
              ),
            ),
          ),
          SpacingFoundation.verticalSpace24,
          UiKitInputFieldNoFill(
            controller: descriptionController,
            label: S.current.WhyDoYouLoveIt,
            hintText: S.current.WhyDoYouLoveIt,
            onChanged: (value) {
              setState(() {});
            },
            maxLines: 10,
            minLines: 1,
            customEnabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                color: context.uiKitTheme?.colorScheme.darkNeutral400 ??
                    Colors.transparent,
              ),
            ),
            customFocusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                color: context.uiKitTheme?.colorScheme.darkNeutral400 ??
                    Colors.transparent,
              ),
            ),
          ),
          SpacingFoundation.verticalSpace24,
          context.gradientButton(
            data: BaseUiKitButtonData(
              onPressed: (titleController.text.isNotEmpty &&
                      locationController.text.isNotEmpty &&
                      descriptionController.text.isNotEmpty)
                  ? () {
                      widget.onConfirm.call(
                        UiSuggestPlaceModel(
                            title: titleController.text,
                            location: locationController.text,
                            description: descriptionController.text,
                            dateTime: DateTime.now()),
                      );
                      context.pop();
                    }
                  : null,
              text: S.current.Submit,
            ),
          )
        ],
      ).paddingAll(EdgeInsetsFoundation.all16),
    );
  }
}
