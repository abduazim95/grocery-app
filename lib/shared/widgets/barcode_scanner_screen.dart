import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class BarcodeScannerScreen extends StatefulWidget {
  const BarcodeScannerScreen({super.key});

  @override
  State<BarcodeScannerScreen> createState() => _BarcodeScannerScreenState();
}

class _BarcodeScannerScreenState extends State<BarcodeScannerScreen>
    with SingleTickerProviderStateMixin {
  final MobileScannerController _scanner = MobileScannerController();
  late final AnimationController _animation = AnimationController(
    duration: const Duration(seconds: 2),
    vsync: this,
  )..repeat(reverse: true);
  bool _detected = false;

  @override
  void dispose() {
    _scanner.dispose();
    _animation.dispose();
    super.dispose();
  }

  void _onDetect(BarcodeCapture capture) {
    if (_detected) return;
    final barcode = capture.barcodes.firstOrNull?.rawValue;
    if (barcode != null) {
      _detected = true;
      context.pop(barcode);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Сканирование'),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => context.pop(null),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.flash_on),
            onPressed: _scanner.toggleTorch,
          ),
        ],
      ),
      body: Stack(
        children: [
          MobileScanner(controller: _scanner, onDetect: _onDetect),
          _ScannerOverlay(animation: _animation),
          Positioned(
            bottom: 48,
            left: 0,
            right: 0,
            child: Center(
              child: TextButton(
                onPressed: () => context.pop(null),
                style: TextButton.styleFrom(foregroundColor: Colors.white),
                child: const Text(
                  'Ввести вручную',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ScannerOverlay extends StatelessWidget {
  const _ScannerOverlay({required this.animation});

  final Animation<double> animation;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Center(
          child: SizedBox(
            width: 280,
            height: 180,
            child: Stack(
              children: [
                Positioned.fill(child: CustomPaint(painter: _ScannerBorderPainter())),
                AnimatedBuilder(
                  animation: animation,
                  builder: (context, _) => Positioned(
                    top: 178 * animation.value,
                    left: 10,
                    right: 10,
                    child: Container(
                      height: 2,
                      decoration: BoxDecoration(
                        color: Colors.greenAccent,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.greenAccent.withAlpha(200),
                            blurRadius: 10,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: EdgeInsets.all(80),
            child: Text(
              'Поместите QR-код в рамку',
              style: TextStyle(color: Colors.white70, fontSize: 16),
            ),
          ),
        ),
      ],
    );
  }
}

class _ScannerBorderPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.greenAccent
      ..strokeWidth = 4
      ..style = PaintingStyle.stroke;

    const c = 20.0;
    final path = Path()
      ..moveTo(0, c)
      ..lineTo(0, 0)
      ..lineTo(c, 0)
      ..moveTo(size.width - c, 0)
      ..lineTo(size.width, 0)
      ..lineTo(size.width, c)
      ..moveTo(size.width, size.height - c)
      ..lineTo(size.width, size.height)
      ..lineTo(size.width - c, size.height)
      ..moveTo(c, size.height)
      ..lineTo(0, size.height)
      ..lineTo(0, size.height - c);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
