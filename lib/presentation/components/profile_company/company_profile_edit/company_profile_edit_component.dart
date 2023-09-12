import 'package:flutter/material.dart';
import 'package:shuffle_uikit/shuffle_uikit.dart';
import 'package:shuffle_components_kit/shuffle_components_kit.dart';

class CompanyProfileEditComponent extends StatelessWidget {
  final List<String> selectedAudience;
  final List<String> selectedAgeRanges;
  final VoidCallback? onProfileEditSubmitted;
  final GlobalKey? formKey;
  final VoidCallback? onAudienceChangeRequested;
  final VoidCallback? onAgeRangesChangeRequested;
  final VoidCallback? onPhotoChangeRequested;
  final VoidCallback? onNicheChangeRequested;
  final String? avatarUrl;
  final String selectedNiche;

  final ValueChanged<List<String>>? onPreferencesChanged;
  final String? Function(String?)? titleValidator;
  final String? Function(String?)? emailValidator;
  final String? Function(String?)? phoneValidator;
  final String? Function(String?)? contactPersonValidator;

  final TextEditingController contactPersonController;

  final TextEditingController titleController;

  final TextEditingController emailController;

  final TextEditingController positionController;
  final TextEditingController phoneController;
  final bool isLoading;

  const CompanyProfileEditComponent(
      {Key? key,
        required this.selectedAudience,
        required this.selectedAgeRanges,
        required this.selectedNiche,
        this.onProfileEditSubmitted,
        this.onNicheChangeRequested,
        this.formKey,
        this.onPhotoChangeRequested,
        this.onPreferencesChanged,
        this.titleValidator,
        this.emailValidator,
        this.avatarUrl,
        this.phoneValidator,
        this.contactPersonValidator,
        required this.contactPersonController,
        required this.titleController,
        required this.emailController,
        required this.positionController,
        required this.phoneController,
        this.onAgeRangesChangeRequested,
        this.onAudienceChangeRequested,
        this.isLoading = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final config = GlobalComponent.of(context)?.globalConfiguration.appConfig.content ?? GlobalConfiguration().appConfig.content;
    final ComponentEditProfileModel model = ComponentEditProfileModel.fromJson(config['edit_profile']);
    final horizontalMargin = (model.positionModel?.horizontalMargin ?? 0).toDouble();
    final verticalMargin = (model.positionModel?.verticalMargin ?? 0).toDouble();
    final textTheme = context.uiKitTheme?.boldTextTheme;

    return Scaffold(
      body: BlurredAppBarPage(
        // wrapSliverBox: false,
        title: 'Edit Profile',
        autoImplyLeading: true,
        centerTitle: true,
        appBarBody: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircularAvatar(
              avatarUrl: avatarUrl ?? '',
              name: contactPersonController.text,
              height: 48,
            ),
            SpacingFoundation.verticalSpace4,
            InkWell(
                onTap: onPhotoChangeRequested,
                child: Text(
                  'Change Photo',
                  style: textTheme?.caption2Bold,
                )),
          ],
        ),
        body: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                UiKitInputFieldNoFill(
                  controller: titleController,
                  label: 'Title',
                  validator: titleValidator,
                ),
                SpacingFoundation.verticalSpace16,
                UiKitInputFieldNoFill(
                  controller: contactPersonController,
                  label: 'Contact Person',
                  validator: contactPersonValidator,
                  keyboardType: TextInputType.name,
                ),
                SpacingFoundation.verticalSpace16,
                UiKitInputFieldNoFill(
                  controller: positionController,
                  label: 'Position',
                  validator: contactPersonValidator,
                  inputFormatters: [dateInputFormatter],
                ),
                SpacingFoundation.verticalSpace16,
                UiKitInputFieldNoFill(
                  prefixText: '+',
                  controller: phoneController,
                  label: 'Phone',
                  validator: phoneValidator,
                  keyboardType: TextInputType.phone,
                  inputFormatters: [americanInputFormatter],
                ),
                SpacingFoundation.verticalSpace16,
                UiKitInputFieldNoFill(
                  controller: emailController,
                  label: 'Email',
                  validator: emailValidator,
                  keyboardType: TextInputType.emailAddress,
                ),
                SpacingFoundation.verticalSpace16,
                UiKitTitledSelectionTile(
                  onSelectionChanged: onNicheChangeRequested,
                  selectedItems: [selectedNiche],
                  title: 'Your niche',
                ),
                SpacingFoundation.verticalSpace16,
                UiKitTitledSelectionTile(
                  onSelectionChanged: onAudienceChangeRequested,
                  selectedItems: selectedAudience,
                  title: 'Your audience',
                ),
                SpacingFoundation.verticalSpace16,
                UiKitTitledSelectionTile(
                  onSelectionChanged: onAgeRangesChangeRequested,
                  selectedItems: selectedAgeRanges,
                  title: 'Your audience age',
                ),
              ],
            ).paddingSymmetric(
              horizontal: horizontalMargin,
              vertical: verticalMargin,
            ),
          ),
        ),
      ),
      bottomNavigationBar: AnimatedOpacity(
        duration: const Duration(milliseconds: 200),
        curve: Curves.bounceIn,
        opacity: MediaQuery.viewInsetsOf(context).bottom == 0 ? 1 : 0,
        child: context
            .gradientButton(
          data: BaseUiKitButtonData(
            text: 'SAVE',
            loading: isLoading,
            onPressed: onProfileEditSubmitted?.call,
          ),
        )
            .paddingOnly(
          left: horizontalMargin,
          right: horizontalMargin,
          bottom: EdgeInsetsFoundation.vertical24,
        ),
      ),
    );
  }
}

