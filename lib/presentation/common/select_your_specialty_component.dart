import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:shuffle_uikit/shuffle_uikit.dart';

class SelectYourSpecialtyComponent extends StatelessWidget {
  final List<UiSpecialtyModel> specialtyList;
  final ValueChanged<String> onTabChange;
  final UiSpecialtyModel? selectedSpecialty;
  final ValueChanged<UiSpecialtyModel> onSpecialtyChange;

  const SelectYourSpecialtyComponent({
    super.key,
    required this.specialtyList,
    required this.onTabChange,
    this.selectedSpecialty,
    required this.onSpecialtyChange,
  });

  @override
  Widget build(BuildContext context) {
    final theme = context.uiKitTheme;
    final colorScheme = theme?.colorScheme;

    return BlurredAppBarPage(
      customToolbarBaseHeight: 100,
      // customToolbarBaseHeight: 1.sw <= 380 ? 0.18.sh : 0.13.sh,
      customTitle: Expanded(
        child: AutoSizeText(
          S.of(context).SelectYourSpecialty,
          style: theme?.boldTextTheme.title1,
          textAlign: TextAlign.center,
          maxLines: 2,
        ),
      ),
      autoImplyLeading: true,
      centerTitle: true,
      children: [
        SpacingFoundation.verticalSpace16,
        UiKitCustomTabBar(
          onTappedTab: (index) => onTabChange.call([
            'leisure',
            'business',
          ][index]),
          tabs: [
            UiKitCustomTab(
              title: S.of(context).Leisure,
              customValue: 'leisure',
              group: _tabSizeGroup,
            ),
            UiKitCustomTab(
              title: S.of(context).Business,
              customValue: 'business',
              group: _tabSizeGroup,
            ),
          ],
        ).paddingSymmetric(horizontal: SpacingFoundation.horizontalSpacing16),
        Text(
          selectedSpecialty != null
              ? selectedSpecialty!.description
              : S.of(context).ContentThatIsAvailableForYouToViewWillAppearHere,
          style: theme?.regularTextTheme.caption1,
        ).paddingSymmetric(
            horizontal: SpacingFoundation.horizontalSpacing16, vertical: SpacingFoundation.verticalSpacing16),
        SizedBox(
            height: 0.65.sh,
            child: GridView.builder(
              padding: EdgeInsets.zero,
              shrinkWrap: true,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: SpacingFoundation.horizontalSpacing8,
                mainAxisSpacing: SpacingFoundation.verticalSpacing8,
              ),
              itemCount: specialtyList.length,
              itemBuilder: (context, index) {
                final item = specialtyList[index];
                return GestureDetector(
                  onTap: () => onSpecialtyChange(item),
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: selectedSpecialty == item ? GradientFoundation.defaultLinearGradient : null,
                      color: selectedSpecialty == item ? null : colorScheme?.surface2,
                      borderRadius: BorderRadiusFoundation.all24,
                    ),
                    child: Center(
                      child: Text(
                        item.name,
                        textAlign: TextAlign.center,
                        style: theme?.boldTextTheme.caption3Medium.copyWith(
                            color: selectedSpecialty == item ? colorScheme?.surface : colorScheme?.darkNeutral900),
                      ).paddingSymmetric(
                          horizontal: SpacingFoundation.horizontalSpacing8,
                          vertical: SpacingFoundation.verticalSpacing8),
                    ),
                  ),
                );
              },
            ).paddingSymmetric(horizontal: SpacingFoundation.horizontalSpacing16))
      ],
    );
  }
}

final AutoSizeGroup _tabSizeGroup = AutoSizeGroup();

class UiSpecialtyModel {
  final int id;
  final String name;
  final String description;

  UiSpecialtyModel({
    required this.id,
    required this.name,
    required this.description,
  });

  @override
  bool operator ==(Object other) => other is UiSpecialtyModel && id == other.id;

  @override
  int get hashCode => id.hashCode;
}
