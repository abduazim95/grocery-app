import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class BarcodeScannerScreen extends StatefulWidget {
  const BarcodeScannerScreen({super.key});

  @override
  State<BarcodeScannerScreen> createState() => _BarcodeScannerScreenState();
}

class _BarcodeScannerScreenState extends State<BarcodeScannerScreen> {
  final MobileScannerController _controller = MobileScannerController();
  bool _detected = false;

  @override
  void dispose() {
    _controller.dispose();
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
            onPressed: () => _controller.toggleTorch(),
          ),
        ],
      ),
      body: Stack(
        children: [
          MobileScanner(controller: _controller, onDetect: _onDetect),
          _ScannerOverlay(),
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

class _ScannerOverlay extends StatefulWidget {
  const _ScannerOverlay({super.key});

  @override
  State<_ScannerOverlay> createState() => _ScannerOverlayState();
}

class _ScannerOverlayState extends State<_ScannerOverlay>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    // Анимация для сканирующей линии
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // 1. Затемненный фон с прорезью
        Stack(
          fit: StackFit.expand,
          children: [
            Center(
              child: Container(
                width: 280,
                height: 180,
                decoration: BoxDecoration(
                  color: Colors.transparent, // Цвет не важен из-за srcOut
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
        // 2. Рамка и анимация
        Center(
          child: SizedBox(
            width: 280,
            height: 180,
            child: Stack(
              children: [
                // Угловые скобки (CustomPainter для красоты)
                Positioned.fill(
                    child: CustomPaint(painter: _ScannerBorderPainter())),

                // Анимированная линия
                AnimatedBuilder(
                  animation: _controller,
                  builder: (context, child) {
                    return Positioned(
                      top: 180 * _controller.value,
                      left: 10,
                      right: 10,
                      child: Container(
                        height: 2,
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: Colors.greenAccent.withAlpha(200),
                              blurRadius: 10,
                              spreadRadius: 2,
                            )
                          ],
                          color: Colors.greenAccent,
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
        // 3. Подсказка снизу
        const Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: EdgeInsets.all(80.0),
            child: Text(
              "Поместите QR-код в рамку",
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

    final path = Path();
    double cornerSize = 20;

    // Топ-лево
    path.moveTo(0, cornerSize);
    path.lineTo(0, 0);
    path.lineTo(cornerSize, 0);

    // Топ-право
    path.moveTo(size.width - cornerSize, 0);
    path.lineTo(size.width, 0);
    path.lineTo(size.width, cornerSize);

    // Низ-право
    path.moveTo(size.width, size.height - cornerSize);
    path.lineTo(size.width, size.height);
    path.lineTo(size.width - cornerSize, size.height);

    // Низ-лево
    path.moveTo(cornerSize, size.height);
    path.lineTo(0, size.height);
    path.lineTo(0, size.height - cornerSize);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
