part of 'donation_component.dart';

class _DonationTabMenu extends StatefulWidget {
  const _DonationTabMenu({
    required this.onNextButtonTap,
    required this.topDayUsers,
    required this.topMonthUsers,
    required this.topYearUsers,
  });

  final VoidCallback? onNextButtonTap;

  final List<UiDonationUserModel> topDayUsers;
  final List<UiDonationUserModel> topMonthUsers;
  final List<UiDonationUserModel> topYearUsers;

  @override
  State<_DonationTabMenu> createState() => _DonationTabMenuState();
}

class _DonationTabMenuState extends State<_DonationTabMenu> {
  final PageController _pageController = PageController();
  Duration pageDuration = const Duration(milliseconds: 300);

  void _jumpToPage(int index) {
    _pageController.animateToPage(
      index,
      duration: pageDuration,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        UiKitCustomTabBar(
          tabs: [
            UiKitCustomTab(
              title: 'DAY',
              height: 24.h,
              isAutoSizeEnabled: true,
            ),
            UiKitCustomTab(
              title: 'MONTH',
              height: 24.h,
              isAutoSizeEnabled: true,
            ),
            UiKitCustomTab(
              title: 'YEAR',
              height: 24.h,
              isAutoSizeEnabled: true,
            ),
          ],
          onTappedTab: (page) => _jumpToPage(page),
        ).paddingSymmetric(horizontal: EdgeInsetsFoundation.horizontal16),
        SpacingFoundation.verticalSpace16,
        ConstrainedBox(
          constraints: BoxConstraints.expand(height: 550.h),
          child: PageView(
            physics: const NeverScrollableScrollPhysics(),
            controller: _pageController,
            children: [
              ListView.separated(
                padding: EdgeInsets.symmetric(horizontal: EdgeInsetsFoundation.horizontal16),
                physics: const NeverScrollableScrollPhysics(),
                scrollDirection: Axis.vertical,
                itemCount: widget.topDayUsers.length,
                itemBuilder: (_, index) {
                  final user = widget.topDayUsers[index];

                  return UiKitDonationCard(
                    number: user.position,
                    title: user.nikcname,
                    subtitle: '${user.name} ${user.surname}',
                    points: index < 3 ? '${user.sum}00' : null,
                    sum: user.sum.toString(),
                    isStarEnabled: user.isStarEnabled,
                  );
                },
                separatorBuilder: (_, __) => SpacingFoundation.verticalSpace24,
              ),
              ListView.separated(
                padding: EdgeInsets.symmetric(horizontal: EdgeInsetsFoundation.horizontal16),
                physics: const NeverScrollableScrollPhysics(),
                scrollDirection: Axis.vertical,
                itemCount: widget.topMonthUsers.length,
                itemBuilder: (_, index) {
                  final user = widget.topMonthUsers[index];

                  return UiKitDonationCard(
                    number: user.position,
                    title: user.nikcname,
                    subtitle: '${user.name} ${user.surname}',
                    points: index < 3 ? '${user.sum}00' : null,
                    sum: user.sum.toString(),
                    isStarEnabled: user.isStarEnabled,
                  );
                },
                separatorBuilder: (_, __) => SpacingFoundation.verticalSpace24,
              ),
              ListView.separated(
                padding: EdgeInsets.symmetric(horizontal: EdgeInsetsFoundation.horizontal16),
                physics: const NeverScrollableScrollPhysics(),
                scrollDirection: Axis.vertical,
                itemCount: widget.topYearUsers.length,
                itemBuilder: (_, index) {
                  final user = widget.topYearUsers[index];

                  return UiKitDonationCard(
                    number: user.position,
                    title: user.nikcname,
                    subtitle: '${user.name} ${user.surname}',
                    points: index < 3 ? '${user.sum}00' : null,
                    sum: user.sum.toString(),
                    isStarEnabled: user.isStarEnabled,
                  );
                },
                separatorBuilder: (_, __) => SpacingFoundation.verticalSpace24,
              )
            ],
          ),
        ),
        SpacingFoundation.verticalSpace16,
        ConstrainedBox(
          constraints: BoxConstraints.expand(height: 40.h),
          child: OrdinaryButtonWithIcon(
            onPressed: () => widget.onNextButtonTap?.call(),
            icon: const Icon(CupertinoIcons.chevron_down),
            text: 'NEXT 7 PEOPLE',
          ),
        ).paddingSymmetric(horizontal: EdgeInsetsFoundation.horizontal16),
      ],
    );
  }
}
