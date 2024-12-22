import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vjti/controller/pay_from_phone_upi_controller.dart';

class QRController extends GetxController {
  void updateScannedQRCode(String qrCode) {
    payFromPhoneUpiController.upiIdController.text = qrCode;
    payFromPhoneUpiController.payFromUpi();
  }
}

QRController qrController = Get.put(QRController());
