import 'package:flutter/material.dart';
import 'package:shuffle_uikit/shuffle_uikit.dart';
import 'package:auto_size_text/auto_size_text.dart';

class FavoriteFoldersComponent extends StatelessWidget {
  const FavoriteFoldersComponent({
    super.key,
    this.onShareTap,
    this.onEditTap,
    this.onRenameTap,
    this.onDeleteTap,
    this.onDoneTap,
    required this.content,
    required this.folderName,
  });

  final VoidCallback? onShareTap;
  final VoidCallback? onEditTap;
  final VoidCallback? onRenameTap;
  final VoidCallback? onDeleteTap;
  final VoidCallback? onDoneTap;
  final List<Widget> content;
  final String folderName;

  @override
  Widget build(BuildContext context) {
    final theme = context.uiKitTheme;
    TextStyle? textStyle =
        theme?.boldTextTheme.title1 ?? Theme
            .of(context)
            .primaryTextTheme
            .titleMedium;
    textStyle = textStyle?.copyWith(color: theme?.colorScheme.inversePrimary);

    return Scaffold(
      body: BlurredAppBarPage(
        customToolbarBaseHeight: 100,
        autoImplyLeading: true,
        // centerTitle: true,
        appBarTrailing: onDoneTap != null
            ? context.smallOutlinedButton(
            data: BaseUiKitButtonData(
                onPressed: onDoneTap, iconInfo: BaseUiKitButtonIconData(iconData: ShuffleUiKitIcons.check)))
            : UiKitPopUpMenuButton(options: [
          UiKitPopUpMenuButtonOption(
            title: S
                .of(context)
                .Share,
            value: 'share',
            onTap: onShareTap,
          ),
          UiKitPopUpMenuButtonOption(
            title: S
                .of(context)
                .Edit,
            value: 'edit',
            onTap: onEditTap,
          ),
          UiKitPopUpMenuButtonOption(
            title: S
                .of(context)
                .Rename,
            value: 'rename',
            onTap: onRenameTap,
          ),
          UiKitPopUpMenuButtonOption(
            title: S
                .of(context)
                .Delete,
            value: 'delete',
            onTap: onDeleteTap,
          ),
        ]),
        // title: ,
        customTitle: Expanded(
            child: AutoSizeText(folderName, maxLines: 2, style: textStyle, textAlign: TextAlign.center,)),
        childrenPadding: EdgeInsets.symmetric(vertical: EdgeInsetsFoundation.all16),
        children: content,
      ),
    );
  }
}
