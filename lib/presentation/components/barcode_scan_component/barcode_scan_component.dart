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
  late final Rect scanWindow;
  final width = 0.76.sw;
  final height = 0.5.sw;

  Widget _buildScanWindow(Rect scanWindowRect) {
    return ValueListenableBuilder(
      valueListenable: controller,
      builder: (context, value, child) {
        if (!value.isInitialized || !value.isRunning || value.size.isEmpty) {
          return const LoadingWidget();
        } else if (value.error != null) {
          return ScannerErrorWidget(error: value.error!);
        }

        return CustomPaint(
          painter: ScannerOverlay(scanWindowRect),
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    final centerHeight = 1.sh / 2;
    final diff = 1.sw <= 380 ? 0.2 : 0.15;
    scanWindow = Rect.fromCenter(
      center: Offset(1.sw / 2, centerHeight - centerHeight * diff),
      width: width,
      height: height - 0.05.sw,
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: S.of(context).Scanner,
        autoImplyLeading: true,
      ),
      body: SafeArea(
        child: Stack(
          children: [
            MobileScanner(
              scanWindow: scanWindow,
              controller: controller,
              onDetect: widget.onDetect,
              errorBuilder: (context, error, child) {
                return ScannerErrorWidget(error: error);
              },
            ),
            _buildScanWindow(scanWindow),
            Center(
              child: SizedBox(
                height: height,
                child: LottieAnimation(
                  lottiePath: GraphicsFoundation.instance.animations.lottie.codeScannerPink.path,
                  fit: BoxFit.fill,
                ),
              ),
            ),
            Center(
              child: CustomPaint(
                painter: CornerBorderPainter(),
                child: SizedBox(
                  width: width,
                  height: height - 0.02.sw,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
