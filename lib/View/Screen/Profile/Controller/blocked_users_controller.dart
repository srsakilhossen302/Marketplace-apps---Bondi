import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../service/api_client.dart';
import '../../../../service/api_url.dart';

class BlockedUsersController extends GetxController {
  final blockedUsers = <Map<String, dynamic>>[].obs;
  final isLoading = false.obs;
  final unblockingUsers = <String>{}.obs;

  @override
  void onInit() {
    super.onInit();
    fetchBlockedUsers();
  }

  Future<void> fetchBlockedUsers() async {
    isLoading.value = true;
    try {
      final response = await ApiClient.get(
        ApiUrl.blockedUsers,
        requireAuth: true,
      );
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        if (data['success'] == true && data['data'] != null) {
          final List<dynamic> rawList = data['data'];
          blockedUsers.assignAll(
            rawList.map((item) => Map<String, dynamic>.from(item)).toList(),
          );
        }
      } else {
        final errorData = jsonDecode(response.body);
        Get.snackbar(
          'Error',
          errorData['message'] ?? 'Failed to load blocked users.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.redAccent.withValues(alpha: 0.9),
          colorText: Colors.white,
        );
      }
    } catch (e) {
      debugPrint('Error fetching blocked users: $e');
      Get.snackbar(
        'Error',
        'Something went wrong: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent.withValues(alpha: 0.9),
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> unblockUser(String userId) async {
    unblockingUsers.add(userId);
    try {
      final response = await ApiClient.post(
        '${ApiUrl.social}/unblock-user/$userId',
        {},
        requireAuth: true,
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        blockedUsers.removeWhere((user) => user['_id'] == userId);
        Get.snackbar(
          'Success',
          'User unblocked successfully.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green.withValues(alpha: 0.9),
          colorText: Colors.white,
        );
      } else {
        final errorData = jsonDecode(response.body);
        Get.snackbar(
          'Error',
          errorData['message'] ?? 'Failed to unblock user.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.redAccent.withValues(alpha: 0.9),
          colorText: Colors.white,
        );
      }
    } catch (e) {
      debugPrint('Error unblocking user: $e');
      Get.snackbar(
        'Error',
        'Something went wrong: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent.withValues(alpha: 0.9),
        colorText: Colors.white,
      );
    } finally {
      unblockingUsers.remove(userId);
    }
  }
}
