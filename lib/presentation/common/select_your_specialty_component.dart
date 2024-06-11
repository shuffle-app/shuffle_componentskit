import 'package:flutter/material.dart';
import 'package:shuffle_uikit/shuffle_uikit.dart';

class SelectYourSpecialtyComponent extends StatefulWidget {
  final List<SelectSpecialty> leisureSpecialtyList;
  final List<SelectSpecialty> businessSpecialtyList;

  const SelectYourSpecialtyComponent({
    super.key,
    required this.leisureSpecialtyList,
    required this.businessSpecialtyList,
  });

  @override
  State<SelectYourSpecialtyComponent> createState() => _SelectYourSpecialtyComponentState();
}

class _SelectYourSpecialtyComponentState extends State<SelectYourSpecialtyComponent> {
  String selectedTab = 'leisure';
  String description = '';

  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    final theme = context.uiKitTheme;

    return Scaffold(
      body: BlurredAppBarPage(
        controller: _scrollController,
        customToolbarBaseHeight: 1.sw <= 380 ? 0.18.sh : 0.13.sh,
        customTitle: Expanded(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const AppBarBackButton().paddingAll(SpacingFoundation.zero),
              Expanded(
                child: Text(
                  S.of(context).SelectYourSpecialty,
                  style: theme?.boldTextTheme.title1,
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
        centerTitle: true,
        children: [
          SpacingFoundation.verticalSpace16,
          UiKitCustomTabBar(
            selectedTab: selectedTab,
            onTappedTab: (index) {
              setState(() {
                selectedTab = [
                  'leisure',
                  'business',
                ][index];
              });
            },
            tabs: [
              UiKitCustomTab(
                title: S.of(context).Leisure,
                customValue: 'leisure',
              ),
              UiKitCustomTab(
                title: S.of(context).Business,
                customValue: 'business',
              ),
            ],
          ).paddingSymmetric(horizontal: SpacingFoundation.horizontalSpacing16),
          Text(
            description.isNotEmpty ? description : S.of(context).ContentThatIsAvailableForYouToViewWillAppearHere,
            style: theme?.regularTextTheme.caption1,
          ).paddingSymmetric(
              horizontal: SpacingFoundation.horizontalSpacing16, vertical: SpacingFoundation.verticalSpacing16),
          if (selectedTab == 'leisure') ...[
            SpecialtyGridView(
              listSelectSpecialty: widget.leisureSpecialtyList,
              scrollController: _scrollController,
              onSubmit: (isSelected, description, index) {
                setState(() {
                  widget.leisureSpecialtyList[index].isSelected = isSelected;
                  this.description = description;
                });
              },
            ),
          ] else ...[
            SpecialtyGridView(
              listSelectSpecialty: widget.businessSpecialtyList,
              scrollController: _scrollController,
              onSubmit: (isSelected, description, index) {
                setState(() {
                  widget.businessSpecialtyList[index].isSelected = isSelected;
                  this.description = description;
                });
              },
            ),
          ],
        ],
      ),
    );
  }
}

class SelectSpecialty {
  final String name;
  final String description;
  bool isSelected;

  SelectSpecialty({
    required this.name,
    required this.description,
    required this.isSelected,
  });
}

class SpecialtyGridView extends StatefulWidget {
  final List<SelectSpecialty> listSelectSpecialty;
  final Function(bool isSelected, String description, int index) onSubmit;
  final ScrollController scrollController;

  const SpecialtyGridView({
    super.key,
    required this.onSubmit,
    required this.listSelectSpecialty,
    required this.scrollController,
  });

  @override
  State<SpecialtyGridView> createState() => _SpecialtyGridViewState();
}

class _SpecialtyGridViewState extends State<SpecialtyGridView> {
  @override
  Widget build(BuildContext context) {
    final theme = context.uiKitTheme;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: SpacingFoundation.horizontalSpacing16),
      child: GridView.builder(
        controller: widget.scrollController,
        padding: EdgeInsets.zero,
        shrinkWrap: true,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: SpacingFoundation.horizontalSpacing8,
          mainAxisSpacing: SpacingFoundation.verticalSpacing8,
        ),
        itemCount: widget.listSelectSpecialty.length,
        itemBuilder: (context, index) {
          final item = widget.listSelectSpecialty[index];
          return GestureDetector(
            onTap: () {
              widget.onSubmit(!item.isSelected, item.description, index);
            },
            child: Container(
              decoration: BoxDecoration(
                gradient: item.isSelected ? GradientFoundation.defaultLinearGradient : null,
                color: item.isSelected ? null : theme?.colorScheme.surface2,
                borderRadius: BorderRadiusFoundation.all24,
              ),
              child: Center(
                child: Text(
                  item.name,
                  style: theme?.boldTextTheme.caption3Medium
                      .copyWith(color: item.isSelected ? theme.colorScheme.surface : theme.colorScheme.darkNeutral900),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
