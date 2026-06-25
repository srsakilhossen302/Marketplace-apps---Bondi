import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:dio/dio.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../Main/view/main_screen.dart';
import '../../ContactSync/Data/DataSource/contact_sync_data_source.dart';
import '../../ContactSync/Data/ApiService/contact_sync_api_service.dart';
import '../../ContactSync/Data/Repository/contact_sync_repository.dart';
import '../../ContactSync/Data/Repository/contact_sync_exceptions.dart';
import '../../../../helper/network_img/image_helper.dart';
import '../../../../service/api_client.dart';
import '../../../../service/api_url.dart';

class ConnectDiscoverController extends GetxController {
  final searchController = TextEditingController();
  final RxBool isSyncing = false.obs;
  final RxBool isHubsLoading = false.obs;
  final RxBool showAllContacts = false.obs;
  final RxString inviteMessageTemplate = ''.obs;

  // List of public groups fetched from exploreGroups API
  final RxList<Map<String, dynamic>> hubs = <Map<String, dynamic>>[].obs;

  final RxList<Map<String, dynamic>> friends = <Map<String, dynamic>>[].obs;

  final RxList<Map<String, dynamic>> contacts = <Map<String, dynamic>>[].obs;

  Future<void> syncContacts() async {
    if (isSyncing.value) return;
    
    isSyncing.value = true;
    
    try {
      final status = await Permission.contacts.status;
      if (status.isGranted) {
        await _performSync();
      } else if (status.isDenied) {
        final requestStatus = await Permission.contacts.request();
        if (requestStatus.isGranted) {
          await _performSync();
        } else if (requestStatus.isPermanentlyDenied) {
          isSyncing.value = false;
          _showSettingsDialog();
        } else {
          isSyncing.value = false;
          Get.snackbar(
            'Permission Denied',
            'Contacts permission is required to sync contacts.',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.redAccent.withOpacity(0.8),
            colorText: Colors.white,
          );
        }
      } else if (status.isPermanentlyDenied) {
        isSyncing.value = false;
        _showSettingsDialog();
      } else {
        isSyncing.value = false;
        Get.snackbar(
          'Error',
          'Contacts permission is currently unavailable.',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      isSyncing.value = false;
      Get.snackbar(
        'Error',
        'Unexpected error checking permissions: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  Future<void> _performSync() async {
    try {
      final ContactSyncDataSource dataSource = ContactSyncDataSourceImpl();
      final ContactSyncApiService apiService = ContactSyncApiServiceImpl();
      final ContactSyncRepository repository = ContactSyncRepositoryImpl(
        dataSource: dataSource,
        apiService: apiService,
      );

      final result = await repository.syncContacts();
      inviteMessageTemplate.value = result.inviteMessageTemplate;
      
      // Parse friendsOnBondi
      final List<Map<String, dynamic>> parsedFriends = [];
      for (var f in result.friendsOnBondi) {
        final Map<String, dynamic> friendMap = f as Map<String, dynamic>;
        final String name = friendMap['name'] ?? friendMap['username'] ?? friendMap['phone'] ?? 'Bondi User';
        final String rawUsername = friendMap['username'] ?? '';
        final String username = rawUsername.isNotEmpty ? (rawUsername.startsWith('@') ? rawUsername : '@$rawUsername') : '';
        final String image = friendMap['image'] ?? friendMap['avatar'] ?? friendMap['profileImage'] ?? 'https://i.pravatar.cc/150?u=$name';
        
        parsedFriends.add({
          'name': name,
          'username': username,
          'image': image,
        });
      }
      
      // Parse inviteFromContacts
      final List<Map<String, dynamic>> parsedContacts = [];
      for (var c in result.inviteFromContacts) {
        final Map<String, dynamic> contactMap = c as Map<String, dynamic>;
        final String name = contactMap['name'] ?? contactMap['phone'] ?? 'Contact';
        final String phone = contactMap['phone'] ?? '';
        
        parsedContacts.add({
          'name': name,
          'phone': phone,
          'initials': _getInitials(name),
        });
      }
      
      friends.value = parsedFriends;
      contacts.value = parsedContacts;
      
      isSyncing.value = false;
      
      Get.snackbar(
        'Success',
        'Contacts synchronized successfully. Found ${friends.length} friends on Bondi.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green.withOpacity(0.8),
        colorText: Colors.white,
      );
    } on NoContactsFoundException catch (e) {
      isSyncing.value = false;
      Get.snackbar(
        'No Contacts',
        e.message,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.orangeAccent.withOpacity(0.8),
        colorText: Colors.white,
      );
    } on DioException catch (dioErr) {
      isSyncing.value = false;
      String errStr = 'API error occurred.';
      if (dioErr.type == DioExceptionType.connectionTimeout || dioErr.type == DioExceptionType.receiveTimeout) {
        errStr = 'Request timed out. Please check your network connection and try again.';
      } else if (dioErr.type == DioExceptionType.connectionError) {
        errStr = 'No internet connection. Please connect to the internet.';
      } else if (dioErr.response != null) {
        errStr = dioErr.response?.data?['message'] ?? 'API error: ${dioErr.response?.statusCode}';
      }
      Get.snackbar(
        'Sync Failed',
        errStr,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent.withOpacity(0.8),
        colorText: Colors.white,
      );
    } catch (e) {
      isSyncing.value = false;
      Get.snackbar(
        'Sync Failed',
        'Unexpected error: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent.withOpacity(0.8),
        colorText: Colors.white,
      );
    }
  }

  String _getInitials(String name) {
    if (name.isEmpty) return 'U';
    final cleanName = name.trim().replaceAll(RegExp(r'[^\w\s]'), '');
    final parts = cleanName.split(RegExp(r'\s+'));
    if (parts.length > 1 && parts[0].isNotEmpty && parts[1].isNotEmpty) {
      return (parts[0][0] + parts[1][0]).toUpperCase();
    }
    if (parts[0].isNotEmpty) {
      return parts[0][0].toUpperCase();
    }
    return 'U';
  }

  void _showSettingsDialog() {
    Get.defaultDialog(
      title: 'Settings Required',
      titleStyle: const TextStyle(fontWeight: FontWeight.bold),
      middleText: 'Contacts permission is required to find friends on Bondi. Please enable it in the app settings.',
      textConfirm: 'Open Settings',
      textCancel: 'Cancel',
      confirmTextColor: Colors.white,
      buttonColor: const Color(0xFF0052D4),
      onConfirm: () async {
        Get.back();
        await openAppSettings();
      },
    );
  }

  @override
  void onInit() {
    super.onInit();
    fetchHubs();
    _handlePassedArguments();
    
    // Auto-sync contacts on page load if not pre-populated via arguments
    if (Get.arguments == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        syncContacts();
      });
    }
  }

  void _handlePassedArguments() {
    if (Get.arguments != null && Get.arguments is Map) {
      final args = Get.arguments as Map;
      final List<dynamic>? passedFriends = args['friends'];
      final List<dynamic>? passedContacts = args['contacts'];
      final String? passedInviteMessage = args['inviteMessage'] as String?;

      if (passedInviteMessage != null) {
        inviteMessageTemplate.value = passedInviteMessage;
      }

      if (passedFriends != null) {
        final List<Map<String, dynamic>> parsedFriends = [];
        for (var f in passedFriends) {
          final Map<String, dynamic> friendMap = f as Map<String, dynamic>;
          final String name = friendMap['name'] ?? friendMap['username'] ?? friendMap['phone'] ?? 'Bondi User';
          final String rawUsername = friendMap['username'] ?? '';
          final String username = rawUsername.isNotEmpty ? (rawUsername.startsWith('@') ? rawUsername : '@$rawUsername') : '';
          final String image = friendMap['image'] ?? friendMap['avatar'] ?? friendMap['profileImage'] ?? 'https://i.pravatar.cc/150?u=$name';

          parsedFriends.add({
            'name': name,
            'username': username,
            'image': image,
          });
        }
        friends.value = parsedFriends;
      }

      if (passedContacts != null) {
        final List<Map<String, dynamic>> parsedContacts = [];
        for (var c in passedContacts) {
          final Map<String, dynamic> contactMap = c as Map<String, dynamic>;
          final String name = contactMap['name'] ?? contactMap['phone'] ?? 'Contact';
          final String phone = contactMap['phone'] ?? '';

          parsedContacts.add({
            'name': name,
            'phone': phone,
            'initials': _getInitials(name),
          });
        }
        contacts.value = parsedContacts;
      }
    }
  }

  Future<void> fetchHubs() async {
    isHubsLoading.value = true;
    try {
      final url = '${ApiUrl.exploreGroups}?page=1&limit=10&search=';
      final response = await ApiClient.get(url, requireAuth: true);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success'] == true && data['data'] != null) {
          final List<dynamic> list = data['data'];
          final List<Map<String, dynamic>> parsedGroups = [];
          for (var group in list) {
            if (group is! Map) continue;
            final participants = group['participants'] as List? ?? [];
            final groupId = group['_id'] ?? '';
            final code = groupId.length >= 6 
                ? 'GP-${groupId.substring(groupId.length - 6).toUpperCase()}'
                : 'GP-${groupId.toUpperCase()}';

            parsedGroups.add({
              '_id': groupId,
              'name': group['groupName'] ?? 'No Name',
              'image': ImageHelper.formatImageUrl(group['groupImage']),
              'code': code,
              'members': '${participants.length} Member${participants.length != 1 ? "s" : ""}',
              'description': group['description'] ?? '',
              'hasRequestedToJoin': group['hasRequestedToJoin'] ?? false,
            });
          }
          hubs.assignAll(parsedGroups);
        }
      }
    } catch (e) {
      print('Error fetching hubs: $e');
    } finally {
      isHubsLoading.value = false;
    }
  }

  Future<void> joinGroup(String groupId, String groupName) async {
    isHubsLoading.value = true;
    try {
      final response = await ApiClient.post(
        '${ApiUrl.baseUrl}/conversation/join/$groupId',
        {},
        requireAuth: true,
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        Get.snackbar(
          'Success',
          'Joined $groupName successfully!',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green.withOpacity(0.9),
          colorText: Colors.white,
        );
        fetchHubs();
      } else {
        final errorData = jsonDecode(response.body);
        Get.snackbar(
          'Error',
          errorData['message'] ?? 'Failed to join group.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.redAccent.withOpacity(0.9),
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Something went wrong: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent.withOpacity(0.9),
        colorText: Colors.white,
      );
    } finally {
      isHubsLoading.value = false;
    }
  }

  Future<void> cancelJoinRequest(String groupId, String groupName) async {
    isHubsLoading.value = true;
    try {
      final response = await ApiClient.post(
        '${ApiUrl.baseUrl}/conversation/cancel-join/$groupId',
        {},
        requireAuth: true,
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        Get.snackbar(
          'Success',
          'Cancelled join request for $groupName successfully!',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green.withOpacity(0.9),
          colorText: Colors.white,
        );
        fetchHubs();
      } else {
        final errorData = jsonDecode(response.body);
        Get.snackbar(
          'Error',
          errorData['message'] ?? 'Failed to cancel join request.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.redAccent.withOpacity(0.9),
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Something went wrong: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent.withOpacity(0.9),
        colorText: Colors.white,
      );
    } finally {
      isHubsLoading.value = false;
    }
  }

  Future<void> inviteContact(String phone) async {
    final message = inviteMessageTemplate.value;
    if (message.isEmpty) {
      Get.snackbar(
        'Info',
        'Sync contacts first to retrieve invitation template.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.orangeAccent.withOpacity(0.8),
        colorText: Colors.white,
      );
      return;
    }

    final Uri smsUri = Uri.parse('sms:$phone?body=${Uri.encodeComponent(message)}');

    try {
      if (await canLaunchUrl(smsUri)) {
        await launchUrl(smsUri);
      } else {
        await launchUrl(smsUri);
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Could not launch messaging app: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent.withOpacity(0.8),
        colorText: Colors.white,
      );
    }
  }

  void continueToFeed() {
    Get.offAll(() => const MainScreen());
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }
}
