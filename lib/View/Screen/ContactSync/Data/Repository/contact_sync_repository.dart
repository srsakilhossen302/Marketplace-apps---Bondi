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
    final rawNumbers = await _dataSource.getDeviceContacts();
    
    // 2. Clean and normalize
    final List<String> cleanedNumbers = [];
    for (var raw in rawNumbers) {
      // Remove spaces, dashes, parentheses, brackets, and any non-digit/non-plus character
      final cleaned = raw.replaceAll(RegExp(r'[^\d+]'), '');
      if (cleaned.isNotEmpty) {
        cleanedNumbers.add(cleaned);
      }
    }
    
    // 3. Remove duplicates
    final uniqueNumbers = cleanedNumbers.toSet().toList();
    
    if (uniqueNumbers.isEmpty) {
      throw NoContactsFoundException();
    }
    
    // 4. Send using api service
    final data = await _apiService.uploadContacts(uniqueNumbers);
    
    return ContactSyncResult(
      friendsOnBondi: data['friendsOnBondi'] as List<dynamic>? ?? [],
      inviteFromContacts: data['inviteFromContacts'] as List<dynamic>? ?? [],
      referralLink: data['referralLink'] as String? ?? '',
      inviteMessageTemplate: data['inviteMessageTemplate'] as String? ?? '',
    );
  }
}
