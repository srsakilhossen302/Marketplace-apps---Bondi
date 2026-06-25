import 'package:flutter_contacts/flutter_contacts.dart';

abstract class ContactSyncDataSource {
  Future<List<Map<String, String>>> getDeviceContacts();
}

class ContactSyncDataSourceImpl implements ContactSyncDataSource {
  @override
  Future<List<Map<String, String>>> getDeviceContacts() async {
    // Fetches contacts with properties, meaning phone numbers are retrieved
    final List<Contact> contacts = await FlutterContacts.getContacts(withProperties: true);
    final List<Map<String, String>> rawContacts = [];
    
    for (var contact in contacts) {
      final String name = contact.displayName.trim();
      for (var phone in contact.phones) {
        if (phone.number.isNotEmpty) {
          rawContacts.add({
            'name': name.isNotEmpty ? name : phone.number,
            'phone': phone.number,
          });
        }
      }
    }
    return rawContacts;
  }
}
