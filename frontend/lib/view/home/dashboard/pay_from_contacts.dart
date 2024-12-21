import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vjti/conatants.dart';
import 'package:vjti/controller/contacts_controller.dart';

class VjtiPayFromContacts extends StatelessWidget {
  const VjtiPayFromContacts({super.key});

  @override
  Widget build(BuildContext context) {
    final ContactController controller = Get.put(ContactController());

    return Scaffold(
      backgroundColor: backgroundColor,
      body: Container(
        margin: EdgeInsets.only(top: 50, left: 20, right: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Pay from Contacts',
              style: GoogleFonts.inter(
                color: Colors.white,
                fontSize: 23,
                fontWeight: FontWeight.w600,
              ),
            ),
            Expanded(
              child: Obx(() {
                if (controller.permissionDenied.value) {
                  return Center(child: Text('Permission denied'));
                }
                if (controller.isLoading.value) {
                  return Center(child: CircularProgressIndicator());
                }
                if (controller.contacts.isEmpty) {
                  return Center(child: Text('No contacts found'));
                }
                return ListView.builder(
                  itemCount: controller.contacts.length,
                  itemBuilder: (context, index) {
                    final contact = controller.contacts[index];

                    final contactPhoto = contact.photo;

                    return ListTile(
                      leading: contactPhoto != null
                          ? CircleAvatar(
                              backgroundImage: MemoryImage(contactPhoto),
                            )
                          : CircleAvatar(
                              backgroundColor: Colors.grey,
                              child: Icon(Icons.person, color: Colors.white),
                            ),
                      title: Text(contact.displayName,
                          style: GoogleFonts.inter(color: Colors.white)),
                      onTap: () async {
                        final fullContact =
                            await FlutterContacts.getContact(contact.id);
                            print(fullContact?.phones.first.number.split("+91").last);
                      },
                    );
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
