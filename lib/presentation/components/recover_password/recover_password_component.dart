import 'package:flutter/material.dart';
import 'package:shuffle_components_kit/shuffle_components_kit.dart';
import 'package:shuffle_uikit/shuffle_uikit.dart';

class RecoverPasswordDialogComponent extends StatelessWidget {
  const RecoverPasswordDialogComponent({super.key});

  @override
  Widget build(BuildContext context) {
    final restorePasswordConfig = ComponentModel.fromJson(
      GlobalConfiguration().appConfig.content['recover_password'],
    );
    final horizontalMargin = (restorePasswordConfig.positionModel?.horizontalMargin ?? 0).toDouble();
    final verticalMargin = (restorePasswordConfig.positionModel?.verticalMargin ?? 0).toDouble();

    return Dialog(
      child: const Column().paddingSymmetric(horizontal: horizontalMargin, vertical: verticalMargin),
    );
  }
}
