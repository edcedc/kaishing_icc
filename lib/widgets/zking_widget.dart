import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

/**
 *  二维码扫描
 */
class ZkingWidget extends StatelessWidget {
  final Function(String) onCodeDetected;

  ZkingWidget({required this.onCodeDetected});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Container(
      height: screenWidth,
      child: Stack(
        children: [
          Material(
            type: MaterialType.transparency,
            child: Center(
              child: MobileScanner(
                onDetect: (BarcodeCapture capture) {
                  for (final barcode in capture.barcodes) {
                    if (barcode.rawValue == null) {
                      // 扫描失败
                      print('Failed to scan Barcode');
                      Fluttertoast.showToast(msg: 'Failed to scan Barcode');
                    } else {
                      final String code = barcode.rawValue!;
                      print('Barcode found! $code');
                      onCodeDetected(code);
                    }
                  }
                },
              ),
            ),
          ),
          Positioned(
            top: 10,
            right: 10,
            child: IconButton(
              icon: Icon(Icons.close, color: Colors.red),
              onPressed: () {
                Get.back(); // 关闭对话框
              },
            ),
          ),
        ],
      ),
    );
  }
}