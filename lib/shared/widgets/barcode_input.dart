import 'package:flutter/material.dart';
import 'package:grocery/shared/widgets/barcode_scanner_screen.dart';

class BarcodeInput extends StatefulWidget {
  final void Function(String barcode) onScanned;
  final TextEditingController? controller;
  final String? initialValue;

  const BarcodeInput({
    super.key,
    required this.onScanned,
    this.controller,
    this.initialValue,
  });

  @override
  State<BarcodeInput> createState() => _BarcodeInputState();
}

class _BarcodeInputState extends State<BarcodeInput> {
  late final TextEditingController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = widget.controller ?? TextEditingController(text: widget.initialValue);
  }

  @override
  void dispose() {
    if (widget.controller == null) _ctrl.dispose();
    super.dispose();
  }

  Future<void> _openScanner() async {
    final barcode = await Navigator.push<String?>(
      context,
      MaterialPageRoute(builder: (_) => const BarcodeScannerScreen()),
    );
    if (barcode != null) {
      _ctrl.text = barcode;
      widget.onScanned(barcode);
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _ctrl,
      decoration: InputDecoration(
        labelText: 'Штрихкод',
        hintText: 'Введите или отсканируйте',
        suffixIcon: IconButton(
          icon: const Icon(Icons.qr_code_scanner),
          onPressed: _openScanner,
        ),
      ),
      onSubmitted: (v) {
        if (v.isNotEmpty) widget.onScanned(v);
      },
    );
  }
}
