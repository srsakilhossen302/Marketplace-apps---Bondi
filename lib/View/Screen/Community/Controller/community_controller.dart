import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../helper/network_img/image_helper.dart';
import '../../../../service/api_client.dart';
import '../../../../service/api_url.dart';

class CommunityController extends GetxController {
  final featuredCommunities = [
    {
      'title': 'Elite Tech Leaders',
      'description': 'The primary hub for Silicon Valley veterans and emerging',
      'members': '12.4k',
      'tag': 'Admin Choice',
      'code': 'TECH-1240',
      'image':
          'https://images.unsplash.com/photo-1519389950473-47ba0277781c?q=80&w=500&auto=format&fit=crop',
    },
    {
      'title': 'Global UX Collective',
      'description': 'Curating and UX s...',
      'members': '8.2k',
      'tag': 'Trending Now',
      'code': 'UX-4520',
      'image':
          'https://images.unsplash.com/photo-1558655146-d09347e92766?q=80&w=500&auto=format&fit=crop',
    },
  ].obs;

  final myGroups = <Map<String, dynamic>>[].obs;
  final isMyGroupsLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchMyGroups();
    fetchExploreGroups();
  }

  Future<void> fetchMyGroups() async {
    isMyGroupsLoading.value = true;
    try {
      final response = await ApiClient.get(ApiUrl.myGroups, requireAuth: true);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success'] == true && data['data'] != null) {
          final List<dynamic> list = data['data'];
          final List<Map<String, dynamic>> parsedGroups = [];
          for (var group in list) {
            if (group is! Map) continue;
            final participants = group['participants'] as List? ?? [];
            final unreadCount = group['unreadCount'] ?? 0;
            final status = unreadCount > 0 
                ? '$unreadCount new post${unreadCount > 1 ? "s" : ""}' 
                : '${participants.length} member${participants.length != 1 ? "s" : ""}';
            
            parsedGroups.add({
              '_id': group['_id'] ?? '',
              'title': group['groupName'] ?? 'No Name',
              'image': ImageHelper.formatImageUrl(group['groupImage']),
              'status': status,
              'conversationType': 'group',
              'isGroup': true,
            });
          }
          myGroups.assignAll(parsedGroups);
        }
      }
    } catch (e) {
      print('Error fetching my groups: $e');
    } finally {
      isMyGroupsLoading.value = false;
    }
  }

  final exploreCommunities = <Map<String, dynamic>>[].obs;
  final isExploreLoading = false.obs;
  final currentPage = 1.obs;
  final totalPage = 1.obs;
  final exploreLimit = 10;

  Future<void> fetchExploreGroups({bool loadMore = false}) async {
    if (loadMore) {
      if (currentPage.value >= totalPage.value) return;
      currentPage.value++;
    } else {
      currentPage.value = 1;
      exploreCommunities.clear();
    }

    isExploreLoading.value = true;
    try {
      final url = '${ApiUrl.exploreGroups}?page=${currentPage.value}&limit=$exploreLimit&search=';
      final response = await ApiClient.get(url, requireAuth: true);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success'] == true && data['data'] != null) {
          final List<dynamic> list = data['data'];
          
          if (data['meta'] != null) {
            totalPage.value = data['meta']['totalPage'] ?? 1;
          }

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
              'title': group['groupName'] ?? 'No Name',
              'image': ImageHelper.formatImageUrl(group['groupImage']),
              'code': code,
              'members': '${participants.length} member${participants.length != 1 ? "s" : ""}',
              'conversationType': 'group',
              'isGroup': true,
              'description': group['description'] ?? '',
              'hasRequestedToJoin': group['hasRequestedToJoin'] ?? false,
            });
          }

          if (loadMore) {
            exploreCommunities.addAll(parsedGroups);
          } else {
            exploreCommunities.assignAll(parsedGroups);
          }
        }
      }
    } catch (e) {
      print('Error fetching explore groups: $e');
    } finally {
      isExploreLoading.value = false;
    }
  }

  Future<void> joinGroup(String groupId, String groupName) async {
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
        fetchMyGroups();
        fetchExploreGroups();
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
    }
  }

  Future<void> cancelJoinRequest(String groupId, String groupName) async {
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
        fetchMyGroups();
        fetchExploreGroups();
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
    }
  }
}
