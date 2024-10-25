import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:shuffle_components_kit/presentation/components/barcode_scan_component/corner_border_painter.dart';
import 'package:shuffle_components_kit/presentation/components/barcode_scan_component/scanner_error_widget.dart';
import 'package:shuffle_components_kit/presentation/components/barcode_scan_component/scanner_overlay.dart';
import 'package:shuffle_uikit/shuffle_uikit.dart';

class CustomBarcodeScanner extends StatefulWidget {
  final ValueChanged<BarcodeCapture>? onDetect;
  const CustomBarcodeScanner({
    super.key,
    this.onDetect,
  });

  @override
  _CustomBarcodeScannerState createState() => _CustomBarcodeScannerState();
}

class _CustomBarcodeScannerState extends State<CustomBarcodeScanner> {
  final MobileScannerController controller = MobileScannerController();
  final width = 0.76.sw;
  final height = 0.5.sw;

  Rect scanWindow(bool isUiWindow) {
    return Rect.fromCenter(
      center: isUiWindow ? Offset.zero : Offset(1.sw / 2, 1.sh / 2),
      width: isUiWindow ? width : 0.7.sw,
      height: isUiWindow ? height - 0.05.sw : 0.6.sh,
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: AlignmentDirectional.center,
      children: [
        MobileScanner(
          scanWindow: scanWindow(false),
          controller: controller,
          onDetect: widget.onDetect,
          errorBuilder: (context, error, child) {
            return ScannerErrorWidget(error: error);
          },
        ),
        ValueListenableBuilder(
          valueListenable: controller,
          builder: (context, value, child) {
            if (!value.isInitialized || !value.isRunning || value.size.isEmpty) {
              return const LoadingWidget();
            } else if (value.error != null) {
              return ScannerErrorWidget(error: value.error!);
            }

            return CustomPaint(
              painter: ScannerOverlay(scanWindow(true)),
            );
          },
        ),
        SizedBox(
          height: height,
          child: LottieAnimation(
            lottiePath: GraphicsFoundation.instance.animations.lottie.codeScannerPink.path,
            fit: BoxFit.fill,
          ),
        ),
        CustomPaint(
          painter: CornerBorderPainter(),
          child: SizedBox(
            width: width,
            height: height - 0.02.sw,
          ),
        ),
      ],
    );
  }
}
