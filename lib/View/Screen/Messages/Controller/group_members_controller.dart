import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../service/api_client.dart';
import '../../../../service/api_url.dart';

class GroupMembersController extends GetxController {
  final String conversationId;
  GroupMembersController({required this.conversationId});

  final isLoading = false.obs;
  final participants = <Map<String, dynamic>>[].obs;
  final pendingParticipants = <Map<String, dynamic>>[].obs;
  final adminIds = <String>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchConversationDetails();
  }

  Future<void> fetchConversationDetails() async {
    isLoading.value = true;
    try {
      final response = await ApiClient.get(
        '${ApiUrl.conversation}/$conversationId',
        requireAuth: true,
      );
      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);
        if (body['success'] == true && body['data'] != null) {
          final data = body['data'];
          
          // Parse participants
          final List<dynamic> parts = data['participants'] ?? [];
          participants.assignAll(parts.map((p) => Map<String, dynamic>.from(p)).toList());

          // Parse pending participants
          final List<dynamic> pendings = data['pendingParticipants'] ?? [];
          pendingParticipants.assignAll(pendings.map((p) => Map<String, dynamic>.from(p)).toList());

          // Parse admin ids
          final List<dynamic> admins = data['adminIds'] ?? [];
          adminIds.assignAll(admins.map((a) => a.toString()).toList());
        }
      }
    } catch (e) {
      print('Error fetching conversation details: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> acceptJoinRequest(String userId, String userName) async {
    isLoading.value = true;
    try {
      final response = await ApiClient.post(
        '${ApiUrl.conversation}/accept-request/$conversationId',
        {'userId': userId},
        requireAuth: true,
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        Get.snackbar(
          'Success',
          'Accepted request from $userName successfully!',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green.withOpacity(0.9),
          colorText: Colors.white,
        );
        fetchConversationDetails();
      } else {
        final errorData = jsonDecode(response.body);
        Get.snackbar(
          'Error',
          errorData['message'] ?? 'Failed to accept request.',
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
      isLoading.value = false;
    }
  }

  Future<void> cancelJoinRequest(String userId, String userName) async {
    isLoading.value = true;
    try {
      final response = await ApiClient.post(
        '${ApiUrl.conversation}/decline-request/$conversationId',
        {'userId': userId},
        requireAuth: true,
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        Get.snackbar(
          'Success',
          'Declined request from $userName successfully!',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green.withOpacity(0.9),
          colorText: Colors.white,
        );
        fetchConversationDetails();
      } else {
        final errorData = jsonDecode(response.body);
        Get.snackbar(
          'Error',
          errorData['message'] ?? 'Failed to decline request.',
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
      isLoading.value = false;
    }
  }
}
