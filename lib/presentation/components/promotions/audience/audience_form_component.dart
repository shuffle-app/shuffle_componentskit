import 'package:flutter/material.dart';
import 'package:shuffle_components_kit/presentation/components/promotions/audience/audience_ui_model.dart';
import 'package:shuffle_uikit/shuffle_uikit.dart';

class AudienceFormComponent extends StatefulWidget {
  final List<AudienceUiModel>? preSavedAudience;
  final ValueChanged<AudienceUiModel>? onSaveTemplate;
  final ValueChanged<AudienceUiModel>? onAudienceDrafted;

  final List<UiKitTag> allGenders;
  final List<UiKitTag> allCategories;
  final List<UiKitTag> allMindsets;
  final List<UiKitTag> allDevices;

  final List<String> allLanguages;
  final List<String> allBirthdayTypes;

  const AudienceFormComponent(
      {super.key,
      this.preSavedAudience,
      this.onSaveTemplate,
      this.onAudienceDrafted,
      this.allGenders = const [],
      this.allCategories = const [],
      this.allMindsets = const [],
      this.allDevices = const [],
      this.allLanguages = const [],
      this.allBirthdayTypes = const []});

  @override
  State<AudienceFormComponent> createState() => _AudienceFormComponentState();
}

class _AudienceFormComponentState extends State<AudienceFormComponent> {
  AudienceUiModel? selectedAudience;

  List<UiKitTag> selectedGenders = [];
  List<UiKitTag> selectedCategories = [];
  List<UiKitTag> selectedMindsets = [];
  List<UiKitTag> selectedDevices = [];
  List<UiKitTag> selectedPrefs = [];

  final TextEditingController _languageController = TextEditingController();

  int? selectedAgeFrom;
  int? selectedAgeTo;

  @override
  void initState() {
    FocusManager.instance.addListener(_sendDraftUpdatedAudience);
    super.initState();
  }

  onSelectSavedAudience(AudienceUiModel audience) {
    selectedAudience = audience;
    selectedGenders = audience.genders ?? [];
    selectedCategories = audience.selectedCategories ?? [];
    selectedMindsets = audience.selectedMindsets ?? [];
    selectedDevices = audience.devices ?? [];
    selectedPrefs = audience.selectedPrefs ?? [];
    _languageController.text = audience.languages?.join(', ') ?? '';
    selectedAgeFrom = audience.fromAge;
    selectedAgeTo = audience.toAge;
    setState(() {});
  }

  _sendDraftUpdatedAudience() {
    if (!mounted) return;
    // if (widget.onAudienceDrafted!= null) {
    //   widget.onAudienceDrafted!(selectedAudience!);
    // }
  }

  @override
  void dispose() {
    FocusManager.instance.removeListener(_sendDraftUpdatedAudience);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.uiKitTheme;

    return BlurredAppBarPage(
      // title: S.current.Au,
      centerTitle: true,
      autoImplyLeading: true,
      children: [],
    );
  }
}
