import 'package:flutter_contacts/flutter_contacts.dart';

abstract class ContactSyncDataSource {
  Future<List<String>> getDeviceContacts();
}

class ContactSyncDataSourceImpl implements ContactSyncDataSource {
  @override
  Future<List<String>> getDeviceContacts() async {
    // Fetches contacts with properties, meaning phone numbers are retrieved
    final List<Contact> contacts = await FlutterContacts.getContacts(withProperties: true);
    final List<String> rawPhoneNumbers = [];
    
    for (var contact in contacts) {
      for (var phone in contact.phones) {
        if (phone.number.isNotEmpty) {
          rawPhoneNumbers.add(phone.number);
        }
      }
    }
    return rawPhoneNumbers;
  }
}
