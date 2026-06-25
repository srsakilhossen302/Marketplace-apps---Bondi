import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:dio/dio.dart';
import '../../Main/view/main_screen.dart';
import '../../ContactSync/Data/DataSource/contact_sync_data_source.dart';
import '../../ContactSync/Data/ApiService/contact_sync_api_service.dart';
import '../../ContactSync/Data/Repository/contact_sync_repository.dart';
import '../../ContactSync/Data/Repository/contact_sync_exceptions.dart';

class ConnectDiscoverController extends GetxController {
  final searchController = TextEditingController();
  final RxBool isSyncing = false.obs;

  // Mock data for UI
  final hubs = [
    {
      'name': 'Sneaker Traders',
      'members': '2.4k Members',
      'icon': Icons.shopping_basket_outlined,
    },
    {
      'name': 'Gaming Hub',
      'members': '1.8k Members',
      'icon': Icons.videogame_asset_outlined,
    },
  ].obs;

  final RxList<Map<String, dynamic>> friends = <Map<String, dynamic>>[
    {
      'name': 'Elena Rodriguez',
      'username': '@elena_design',
      'image': 'https://i.pravatar.cc/150?u=elena',
    },
    {
      'name': 'Julian Vane',
      'username': '@julian_v',
      'image': 'https://i.pravatar.cc/150?u=julian',
    },
  ].obs;

  final RxList<Map<String, dynamic>> contacts = <Map<String, dynamic>>[
    {'name': 'Alex Kim', 'phone': '+1 (555) 012-3456', 'initials': 'AK'},
    {'name': 'Maya Lin', 'phone': '+1 (555) 987-6543', 'initials': 'ML'},
  ].obs;

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

  void continueToFeed() {
    Get.offAll(() => const MainScreen());
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }
}
