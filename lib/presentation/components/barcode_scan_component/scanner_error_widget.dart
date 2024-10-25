import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:shuffle_uikit/shuffle_uikit.dart';

class ScannerErrorWidget extends StatelessWidget {
  const ScannerErrorWidget({super.key, required this.error});

  final MobileScannerException error;

  @override
  Widget build(BuildContext context) {
    final theme = context.uiKitTheme;
    String errorMessage;

    switch (error.errorCode) {
      case MobileScannerErrorCode.controllerUninitialized:
        errorMessage = S.of(context).ScanControllerNotReady;
      case MobileScannerErrorCode.permissionDenied:
        errorMessage = S.of(context).ScanPermissionDenied;
      case MobileScannerErrorCode.unsupported:
        errorMessage = S.of(context).ScanningIsUnsupported;
      default:
        errorMessage = S.of(context).ScanGenericError;
        break;
    }

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ImageWidget(
            iconData: Icons.error,
            height: 45.h,
            color: ColorsFoundation.error,
          ),
          Text(
            '${S.of(context).ErrorOccured}: $errorMessage',
            style: theme?.boldTextTheme.body,
            textAlign: TextAlign.center,
          ).paddingAll(EdgeInsetsFoundation.all16),
          Text(
            error.errorDetails?.message ?? '',
            style: theme?.boldTextTheme.body,
          ),
        ],
      ),
    );
  }
}
