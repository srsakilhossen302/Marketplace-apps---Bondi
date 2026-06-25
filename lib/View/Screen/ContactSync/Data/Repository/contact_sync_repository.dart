import 'contact_sync_exceptions.dart';
import '../DataSource/contact_sync_data_source.dart';
import '../ApiService/contact_sync_api_service.dart';

class ContactSyncResult {
  final List<dynamic> friendsOnBondi;
  final List<dynamic> inviteFromContacts;
  final String referralLink;
  final String inviteMessageTemplate;

  ContactSyncResult({
    required this.friendsOnBondi,
    required this.inviteFromContacts,
    required this.referralLink,
    required this.inviteMessageTemplate,
  });
}

abstract class ContactSyncRepository {
  Future<ContactSyncResult> syncContacts();
}

class ContactSyncRepositoryImpl implements ContactSyncRepository {
  final ContactSyncDataSource _dataSource;
  final ContactSyncApiService _apiService;

  ContactSyncRepositoryImpl({
    required ContactSyncDataSource dataSource,
    required ContactSyncApiService apiService,
  })  : _dataSource = dataSource,
        _apiService = apiService;

  @override
  Future<ContactSyncResult> syncContacts() async {
    // 1. Fetch raw contacts
    final rawContacts = await _dataSource.getDeviceContacts();
    
    // 2. Clean, normalize and remove duplicates by phone number
    final Map<String, Map<String, String>> uniqueContactsMap = {};
    for (var raw in rawContacts) {
      final String rawPhone = raw['phone'] ?? '';
      final String name = raw['name'] ?? '';
      
      // Remove spaces, dashes, parentheses, brackets, and any non-digit/non-plus character
      final cleanedPhone = rawPhone.replaceAll(RegExp(r'[^\d+]'), '');
      if (cleanedPhone.isNotEmpty && !uniqueContactsMap.containsKey(cleanedPhone)) {
        uniqueContactsMap[cleanedPhone] = {
          'name': name.isNotEmpty ? name : cleanedPhone,
          'phone': cleanedPhone,
        };
      }
    }
    
    final List<Map<String, String>> cleanedContacts = uniqueContactsMap.values.toList();
    
    if (cleanedContacts.isEmpty) {
      throw NoContactsFoundException();
    }
    
    // 3. Send using api service
    final data = await _apiService.uploadContacts(cleanedContacts);
    
    return ContactSyncResult(
      friendsOnBondi: data['friendsOnBondi'] as List<dynamic>? ?? [],
      inviteFromContacts: data['inviteFromContacts'] as List<dynamic>? ?? [],
      referralLink: data['referralLink'] as String? ?? '',
      inviteMessageTemplate: data['inviteMessageTemplate'] as String? ?? '',
    );
  }
}
