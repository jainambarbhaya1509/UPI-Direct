import 'package:get/get.dart';

class QRController extends GetxController {
  var scannedQRCode = "Not Yet Scanned".obs;

  void updateScannedQRCode(String qrCode) {
    scannedQRCode.value = qrCode;
  }
}

QRController qrController = Get.put(QRController());