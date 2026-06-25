import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:dio/dio.dart';
import '../Data/Repository/contact_sync_repository.dart';
import '../Data/Repository/contact_sync_exceptions.dart';

enum ContactSyncState {
  idle,
  requestingPermission,
  readingContacts,
  uploading,
  success,
  error,
}

class ContactSyncController extends GetxController {
  final ContactSyncRepository _repository;

  ContactSyncController({required ContactSyncRepository repository}) : _repository = repository;

  final Rx<ContactSyncState> syncState = ContactSyncState.idle.obs;
  final RxInt syncedCount = 0.obs;
  final RxString errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    // Auto-start contact sync when screen opens
    startContactSync();
  }

  Future<void> startContactSync() async {
    errorMessage.value = '';
    
    // 1. Request/Verify permission
    syncState.value = ContactSyncState.requestingPermission;
    try {
      final status = await Permission.contacts.status;
      if (status.isGranted) {
        await _readAndUpload();
      } else if (status.isDenied) {
        final requestStatus = await Permission.contacts.request();
        if (requestStatus.isGranted) {
          await _readAndUpload();
        } else if (requestStatus.isPermanentlyDenied) {
          syncState.value = ContactSyncState.error;
          errorMessage.value = 'Contacts permission permanently denied. Please enable it in system settings.';
          _showSettingsDialog();
        } else {
          syncState.value = ContactSyncState.error;
          errorMessage.value = 'Contacts permission denied. Access is required to match with friends.';
        }
      } else if (status.isPermanentlyDenied) {
        syncState.value = ContactSyncState.error;
        errorMessage.value = 'Contacts permission permanently denied. Please enable it in system settings.';
        _showSettingsDialog();
      } else {
        syncState.value = ContactSyncState.error;
        errorMessage.value = 'Contacts permission is currently unavailable.';
      }
    } catch (e) {
      syncState.value = ContactSyncState.error;
      errorMessage.value = 'Unexpected error checking permissions: $e';
    }
  }

  Future<void> _readAndUpload() async {
    // 2. Read contacts
    syncState.value = ContactSyncState.readingContacts;
    try {
      // Small artificial delay for visual feedback/smooth UI transitions
      await Future.delayed(const Duration(milliseconds: 600));

      // 3. Upload contacts
      syncState.value = ContactSyncState.uploading;
      
      final result = await _repository.syncContacts();
      final count = result.friendsOnBondi.length + result.inviteFromContacts.length;
      syncedCount.value = count;
      
      syncState.value = ContactSyncState.success;
      Get.snackbar(
        'Sync Complete',
        'Successfully synced $count contacts.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green.withOpacity(0.9),
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
      );
    } on NoContactsFoundException catch (e) {
      syncState.value = ContactSyncState.error;
      errorMessage.value = e.message;
    } on DioException catch (dioErr) {
      syncState.value = ContactSyncState.error;
      if (dioErr.type == DioExceptionType.connectionTimeout || dioErr.type == DioExceptionType.receiveTimeout) {
        errorMessage.value = 'Connection request timed out. Please check your network and try again.';
      } else if (dioErr.type == DioExceptionType.connectionError) {
        errorMessage.value = 'No internet connection. Please check your network connection.';
      } else if (dioErr.response != null) {
        final apiMsg = dioErr.response?.data?['message'];
        errorMessage.value = apiMsg ?? 'Server responded with error: ${dioErr.response?.statusCode}';
      } else {
        errorMessage.value = 'Network error: ${dioErr.message}';
      }
    } catch (e) {
      syncState.value = ContactSyncState.error;
      errorMessage.value = 'An unexpected error occurred: $e';
    }
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
}
