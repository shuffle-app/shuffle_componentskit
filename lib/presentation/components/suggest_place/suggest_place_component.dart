import 'package:flutter/material.dart';
import 'package:shuffle_components_kit/presentation/components/suggest_place/ui_suggest_place_model.dart';
import 'package:shuffle_uikit/shuffle_uikit.dart';

class SuggestPlaceComponent extends StatelessWidget {
  const SuggestPlaceComponent(
      {super.key,
      required this.locationController,
      required this.titleController,
      required this.descriptionController,
      required this.onLocationTap,
      required this.onConfirm});

  final TextEditingController locationController;
  final TextEditingController titleController;
  final TextEditingController descriptionController;
  final VoidCallback onLocationTap;
  final ValueChanged<UiSuggestPlaceModel> onConfirm;

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
            icon: InkWell(
              onTap: onLocationTap,
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
          ListenableBuilder(
            builder: (context, child) {
              if (titleController.text.isNotEmpty &&
                  locationController.text.isNotEmpty &&
                  descriptionController.text.isNotEmpty) {
                return context.gradientButton(
                  data: BaseUiKitButtonData(
                    onPressed: () {
                      onConfirm.call(
                        UiSuggestPlaceModel(
                            title: titleController.text,
                            location: locationController.text,
                            description: descriptionController.text,
                            dateTime: DateTime.now()),
                      );
                      context.pop();
                    },
                    text: S.current.Submit,
                  ),
                );
              } else {
               return context.gradientButton(
                  data: BaseUiKitButtonData(
                    onPressed: null,
                    text: S.current.Submit,
                  ),
                );
              }
            },
            listenable: Listenable.merge([
              titleController,
              locationController,
              descriptionController,
            ]),
          )
        ],
      ).paddingAll(EdgeInsetsFoundation.all16),
    );
  }
}
