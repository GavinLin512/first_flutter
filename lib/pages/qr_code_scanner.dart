import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

import '../color.dart';
import '../main.dart';
import '../widget/drawer.dart';

class QRCodeScanner extends StatelessWidget {
  const QRCodeScanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('QR code 掃描器'),
        backgroundColor: Palette.primary,
      ),
      drawer: const MyDrawer(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Padding(
              padding: EdgeInsets.only(bottom: 30.0),
              child: Text(
                '請掃描 QR code:',
                style: TextStyle(fontSize: 18.0),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 50.0),
              child: QrImage(
                // data: "415646",
                data: "https://pub.dev/packages/url_launcher/example",
                version: QrVersions.auto,
                size: 300.0,
              ),
            ),
            SizedBox(
              width: 300.0,
              height: 50.0,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  // 文字顏色
                  foregroundColor: generateMaterialColor(Palette.text),
                  // 背景色
                  backgroundColor:
                      generateMaterialColor(Palette.primary).shade400,
                ).copyWith(
                    // 陰影
                    elevation: ButtonStyleButton.allOrNull(10.0)),
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const QRViewExample(),
                  ));
                },
                child: const Text(
                  'QR code scan',
                  style: TextStyle(fontSize: 16.0),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

// class QRCodeBody extends StatelessWidget {
//   const QRCodeBody({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return
//   }
// }

class QRViewExample extends StatefulWidget {
  const QRViewExample({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _QRViewExampleState();
}

class _QRViewExampleState extends State<QRViewExample> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  Barcode? result;
  QRViewController? controller;

  // In order to get hot reload to work we need to pause the camera if the platform
  // is android, or resume the camera if the platform is iOS.
  // @override
  // void reassemble() {
  //   super.reassemble();
  //   if (Platform.isAndroid) {
  //     controller!.pauseCamera();
  //   } else if (Platform.isIOS) {
  //     controller!.resumeCamera();
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    // For this example we check how width or tall the device is and change the scanArea and overlay accordingly.
    var scanArea = (MediaQuery.of(context).size.width < 400 ||
            MediaQuery.of(context).size.height < 400)
        ? 200.0
        : 350.0;
    return Scaffold(
      body: Column(
        children: <Widget>[
          Expanded(
            // Webview 在渲染時為無限大，所以必須用 Expanded 包起來
            flex: 5,
            child: QRView(
              key: qrKey,
              onQRViewCreated: _onQRViewCreated,
              overlay: QrScannerOverlayShape(
                  borderColor: Colors.deepOrange.shade400,
                  borderRadius: 10,
                  borderLength: 30,
                  borderWidth: 10,
                  cutOutSize: scanArea),
            ),
          ), // 最後一個元素自動填滿剩餘空間
          Expanded(
            flex: 1,
            child: Center(
              child:
                  // (result != null)
                  // ? Text(
                  //     'Barcode Type: ${describeEnum(result!.format)}   Data: ${result!.code}')
                  // :
                  Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 350,
                    height: 50.0,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        // 文字顏色
                        foregroundColor: generateMaterialColor(Palette.text),
                        // 背景色
                        backgroundColor:
                            generateMaterialColor(Palette.primary).shade400,
                      ).copyWith(
                          // 陰影
                          elevation: ButtonStyleButton.allOrNull(10.0)),
                      onPressed: () {
                        (result != null)
                            ? _launchUrl(Uri.parse('${result!.code}'))
                            : Navigator.pop(context, true);
                      },
                      child: (result != null)
                          ? Text(
                              '${result!.code}',
                              style: const TextStyle(
                                  fontSize: 16.0,
                                  color: Color(0xFFFB4C28),
                                  decoration: TextDecoration.underline),
                              softWrap: true,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            )
                          : const Text(
                              '返回掃碼',
                              style: TextStyle(fontSize: 16.0),
                            ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _launchUrl(Uri url) async {
    debugPrint('$url');
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      throw '無法開啟網址: $url';
    }
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        result = scanData;
      });
    });
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
