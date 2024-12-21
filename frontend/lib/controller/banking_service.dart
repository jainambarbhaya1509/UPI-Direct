import 'package:background_sms/background_sms.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

class BankingServiceController extends GetxController {
  var isPermissionGranted = false.obs;
  var isCustomSimSupported = false.obs;

  @override
  void onInit() {
    super.onInit();
    checkPermissions();
    checkCustomSimSupport();
  }

  _getPermission() async {
    var status = await Permission.sms.request();
    isPermissionGranted.value = status.isGranted;
  }

  Future<void> checkPermissions() async {
    isPermissionGranted.value = await Permission.sms.isGranted;
  }

  Future<void> checkCustomSimSupport() async {
    isCustomSimSupported.value = (await BackgroundSms.isSupportCustomSim)!;
  }

  Future<void> sendMessage(String phoneNumber, String message, {int? simSlot}) async {
    if (isPermissionGranted.value) {
      var result = await BackgroundSms.sendMessage(
        phoneNumber: phoneNumber,
        message: message,
        simSlot: simSlot,
      );
      if (result == SmsStatus.sent) {
        print("Sent");
      } else {
        print("Failed");
      }
    } else {
      _getPermission();
    }
  }
}

BankingServiceController bankingServiceController = Get.put(BankingServiceController());