import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

class ContactController extends GetxController {
  var contacts = <Contact>[].obs;
  var isLoading = true.obs;
  var permissionDenied = false.obs;

  @override
  void onInit() {
    super.onInit();
    checkPermissionAndFetchContacts();
  }

  Future<void> checkPermissionAndFetchContacts() async {
    
    var status = await Permission.contacts.status;

    
    if (!status.isGranted) {
      status = await Permission.contacts.request();
    }

    if (status.isGranted) {
      
      fetchContacts();
    } else {
      
      permissionDenied.value = true;
      isLoading.value = false;
    }
  }

  Future<void> fetchContacts() async {
    isLoading.value = true;
    final fetchedContacts = await FlutterContacts.getContacts(withProperties: true);
    contacts.assignAll(fetchedContacts);
    isLoading.value = false;
  }
}
