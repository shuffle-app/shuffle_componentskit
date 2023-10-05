import 'package:flutter/material.dart';
import 'package:shuffle_components_kit/shuffle_components_kit.dart';
import 'package:shuffle_uikit/shuffle_uikit.dart';

class EditProfileDefaultComponent extends StatefulWidget {
  final List<String> selectedPreferences;
  final VoidCallback? onProfileEditSubmitted;
  final GlobalKey? formKey;
  final VoidCallback? onPreferencesChangeRequested;
  final VoidCallback? onPhotoChangeRequested;
  final VoidCallback? onPremiumAccountRequested;
  final VoidCallback? onProAccountRequested;
  final String? avatarUrl;

  final ValueChanged<List<String>>? onPreferencesChanged;
  final String? Function(String?)? nameValidator;
  final String? Function(String?)? emailValidator;
  final String? Function(String?)? phoneValidator;
  final String? Function(String?)? dateOfBirthValidator;

  final TextEditingController nameController;

  final TextEditingController nickNameController;

  final TextEditingController emailController;

  final TextEditingController dateOfBirthController;
  final TextEditingController phoneController;
  final bool beInSearch;
  final bool isLoading;

  const EditProfileDefaultComponent({
    Key? key,
    required this.selectedPreferences,
    this.onProfileEditSubmitted,
    this.onPremiumAccountRequested,
    this.onProAccountRequested,
    this.formKey,
    this.onPhotoChangeRequested,
    this.onPreferencesChanged,
    this.nameValidator,
    this.emailValidator,
    this.avatarUrl,
    this.phoneValidator,
    this.dateOfBirthValidator,
    required this.nameController,
    required this.nickNameController,
    required this.emailController,
    required this.dateOfBirthController,
    required this.phoneController,
    required this.beInSearch,
    this.onPreferencesChangeRequested,
    this.isLoading = false,
  }) : super(key: key);

  @override
  State<EditProfileDefaultComponent> createState() => _EditProfileDefaultComponentState();
}

class _EditProfileDefaultComponentState extends State<EditProfileDefaultComponent> {
  late bool _beInSearch;

  @override
  void initState() {
    super.initState();
    _beInSearch = widget.beInSearch;
  }

  @override
  void didUpdateWidget(covariant EditProfileDefaultComponent oldWidget) {
    super.didUpdateWidget(oldWidget);
    _beInSearch = widget.beInSearch;
  }

  @override
  Widget build(BuildContext context) {
    final config =
        GlobalComponent.of(context)?.globalConfiguration.appConfig.content ?? GlobalConfiguration().appConfig.content;
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
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        appBarBody: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            InkWell(
              onTap: widget.onPhotoChangeRequested,
              child: Ink(
                child: CircularAvatar(
                  avatarUrl: widget.avatarUrl ?? '',
                  name: widget.nameController.text,
                  height: 0.15.sw,
                ),
              ),
            ),
            InkWell(
              onTap: widget.onPhotoChangeRequested,
              child: Text(
                'Change Photo',
                style: textTheme?.caption2Bold,
              ),
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Form(
            key: widget.formKey,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SpacingFoundation.verticalSpace16,
                Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Expanded(
                      child: context.smallButton(
                        blurred: false,
                        data: BaseUiKitButtonData(
                          fit: ButtonFit.fitWidth,
                          text: 'PREMIUM',
                          icon: ImageWidget(
                            svgAsset: GraphicsFoundation.instance.svg.star2,
                            color: Colors.black,
                            height: 18,
                            fit: BoxFit.fitHeight,
                          ),
                          onPressed: widget.onPremiumAccountRequested,
                        ),
                      ),
                    ),
                    SpacingFoundation.horizontalSpace16,
                    Expanded(
                      child: context.smallButton(
                        blurred: false,
                        data: BaseUiKitButtonData(
                          fit: ButtonFit.fitWidth,
                          text: 'PRO',
                          onPressed: widget.onProAccountRequested,
                        ),
                      ),
                    ),
                  ],
                ),
                SpacingFoundation.verticalSpace16,
                Row(
                  children: [
                    Text(
                      'Be in search',
                      style: context.uiKitTheme?.regularTextTheme.labelSmall,
                    ),
                    SpacingFoundation.horizontalSpace16,
                    ImageWidget(
                      svgAsset: GraphicsFoundation.instance.svg.info,
                      width: 16.w,
                      color: context.uiKitTheme?.colorScheme.darkNeutral900,
                    ),
                    const Spacer(),
                    UiKitGradientSwitch(
                      switchedOn: _beInSearch,
                      onChanged: (value) => setState(() => _beInSearch = value),
                    )
                  ],
                ),
                SpacingFoundation.verticalSpace16,
                UiKitInputFieldNoFill(
                  controller: widget.nameController,
                  label: 'Name',
                  hintText: 'Name',
                  validator: widget.nameValidator,
                  keyboardType: TextInputType.name,
                ),
                SpacingFoundation.verticalSpace16,
                UiKitInputFieldNoFill(
                  controller: widget.nickNameController,
                  label: 'Nickname',
                  hintText: 'Nickname',
                  validator: widget.nameValidator,
                ),
                SpacingFoundation.verticalSpace16,
                GestureDetector(
                  onTap: () => showUiKitCalendarDialog(context, firstDate: DateTime(1960, 1, 1)).then((d) {
                    if (d != null) {
                      widget.dateOfBirthController.text = '${leadingZeros(d.day)}.${leadingZeros(d.month)}.${d.year}';
                    }
                  }),
                  child: AbsorbPointer(
                    child: UiKitInputFieldNoFill(
                      controller: widget.dateOfBirthController,
                      label: 'Date of birth',
                      hintText: 'Date of birth',
                      validator: widget.dateOfBirthValidator,
                      inputFormatters: [dateInputFormatter],
                    ),
                  ),
                ),
                SpacingFoundation.verticalSpace16,
                UiKitInputFieldNoFill(
                  prefixText: '+',
                  controller: widget.phoneController,
                  label: 'Phone',
                  hintText: 'Phone',
                  validator: widget.phoneValidator,
                  keyboardType: TextInputType.phone,
                  inputFormatters: [americanInputFormatter],
                ),
                SpacingFoundation.verticalSpace16,
                UiKitInputFieldNoFill(
                  controller: widget.emailController,
                  label: 'Email',
                  hintText: 'Email',
                  validator: widget.emailValidator,
                  keyboardType: TextInputType.emailAddress,
                ),
                SpacingFoundation.verticalSpace16,
                UiKitTitledSelectionTile(
                  onSelectionChanged: widget.onPreferencesChangeRequested,
                  selectedItems: widget.selectedPreferences,
                  title: 'Preferences',
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
                loading: widget.isLoading,
                onPressed: widget.onProfileEditSubmitted?.call,
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
