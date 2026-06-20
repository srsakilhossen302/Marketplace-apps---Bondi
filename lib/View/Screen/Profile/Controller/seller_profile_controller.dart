import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../service/api_url.dart';
import '../../../../service/api_client.dart';
import '../../../../Utils/StaticString/static_string.dart';
import '../../../../helper/shared_prefe/shared_prefe.dart';
import '../../../../helper/network_img/image_helper.dart';
import '../../Login/view/login_screen.dart';
import '../../Messages/view/chat_detail_screen.dart';

class SellerProfileController extends GetxController {
  final userId = ''.obs;
  final isLoading = false.obs;
  final isConnectionActionLoading = false.obs;

  final sellerName = 'Jane Doe'.obs;
  final sellerImage = ''.obs;
  final shortBio = ''.obs;
  final longBio = ''.obs;
  final location = 'New York, NY'.obs;
  final isVerifiedSeller = false.obs;

  final tradesCount = '0'.obs;
  final rating = '0.0'.obs;
  final followersCount = '0'.obs;

  final activeListings = <Map<String, String>>[].obs;
  final mutualFriends = <String>[].obs;
  final mutualFriendsCount = 0.obs;
  final sharedGroups = <String>[].obs;

  // Connection states
  final relationshipStatus = 'none'.obs; // 'none', 'pending', 'accepted'
  final isFriendRequestSentByMe = false.obs;
  final relationshipId = ''.obs;

  @override
  void onInit() {
    super.onInit();
    checkAuthAndInit();
  }

  Future<void> checkAuthAndInit() async {
    final token = await SharedPrefsHelper.getToken();
    if (token == null || token.isEmpty) {
      Get.off(() => const LoginScreen());
      return;
    }
    final args = Get.arguments;
    if (args != null && args is String) {
      userId.value = args;
      fetchSellerProfile();
      fetchSellerListings();
    }
  }

  Future<void> fetchSellerProfile() async {
    if (userId.isEmpty) return;
    isLoading.value = true;
    try {
      final response = await ApiClient.get('${ApiUrl.publicProfile}/${userId.value}', requireAuth: true);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success'] == true) {
          final resData = data['data'];
          if (resData != null) {
            sellerName.value = resData['displayName'] ?? resData['username'] ?? 'Jane Doe';
            sellerImage.value = ImageHelper.formatImageUrl(resData['profileImage']?.toString());
            
            final bioText = resData['bio']?.toString() ?? '';
            shortBio.value = bioText.isNotEmpty ? bioText : 'No bio provided';
            longBio.value = bioText.isNotEmpty ? bioText : 'No additional information available';

            final city = resData['city']?.toString().trim() ?? '';
            final country = resData['country']?.toString().trim() ?? '';
            if (city.isNotEmpty && country.isNotEmpty) {
              location.value = '$city, $country';
            } else if (city.isNotEmpty) {
              location.value = city;
            } else if (country.isNotEmpty) {
              location.value = country;
            } else {
              location.value = StaticString.noAddress;
            }

            isVerifiedSeller.value = resData['isVerifiedSeller'] ?? false;
            tradesCount.value = resData['completedTrades']?.toString() ?? '0';
            rating.value = resData['averageRating']?.toString() ?? '0.0';
            followersCount.value = resData['totalFriends']?.toString() ?? '0';

            // Parse relationship status
            String status = 'none';
            String senderId = '';
            relationshipId.value = '';
            
            if (resData['relationshipStatus'] != null) {
              status = resData['relationshipStatus'].toString().toLowerCase();
            } else if (resData['relationship'] != null && resData['relationship'] is Map) {
              status = (resData['relationship']['status'] ?? 'none').toString().toLowerCase();
              senderId = (resData['relationship']['senderId'] ?? resData['relationship']['sender'] ?? '').toString();
            }
            
            if (resData['relationshipSenderId'] != null) {
              senderId = resData['relationshipSenderId'].toString();
            }

            if (resData['relationshipId'] != null) {
              relationshipId.value = resData['relationshipId'].toString();
            } else if (resData['relationship'] != null && resData['relationship'] is Map) {
              relationshipId.value = (resData['relationship']['_id'] ?? '').toString();
            }
            
            // Normalize status to: 'none', 'pending_sent', 'pending_received', 'friend', 'blocked'
            if (status == 'accepted' || status == 'friend') {
              relationshipStatus.value = 'friend';
            } else if (status == 'blocked') {
              relationshipStatus.value = 'blocked';
              isFriendRequestSentByMe.value = false;
            } else if (status == 'pending_sent' || status == 'sent_pending' || status == 'sent') {
              relationshipStatus.value = 'pending_sent';
              isFriendRequestSentByMe.value = true;
            } else if (status == 'pending_received' || status == 'received_pending' || status == 'received') {
              relationshipStatus.value = 'pending_received';
              isFriendRequestSentByMe.value = false;
            } else if (status == 'pending') {
              final currentUserId = await SharedPrefsHelper.getUserId() ?? '';
              if (senderId.isNotEmpty && currentUserId.isNotEmpty && senderId == currentUserId) {
                relationshipStatus.value = 'pending_sent';
                isFriendRequestSentByMe.value = true;
              } else {
                relationshipStatus.value = 'pending_received';
                isFriendRequestSentByMe.value = false;
              }
            } else {
              relationshipStatus.value = 'none';
              isFriendRequestSentByMe.value = false;
            }

            // Mutual Friends
            final List<dynamic> friendsList = resData['mutualFriends']?['data'] ?? [];
            final List<String> friendImgs = [];
            for (var friend in friendsList) {
              final img = friend['profileImage']?.toString() ?? '';
              if (img.isNotEmpty) {
                friendImgs.add(ImageHelper.formatImageUrl(img));
              }
            }
            if (friendImgs.isNotEmpty) {
              mutualFriends.assignAll(friendImgs);
            } else {
              mutualFriends.assignAll([
                'https://randomuser.me/api/portraits/men/1.jpg',
                'https://randomuser.me/api/portraits/men/2.jpg',
                'https://randomuser.me/api/portraits/men/3.jpg',
              ]);
            }
            mutualFriendsCount.value = resData['mutualFriends']?['meta']?['total'] ?? 0;

            // Shared Groups
            final List<dynamic> groupsList = resData['sharedGroups'] ?? [];
            final List<String> groupNames = groupsList
                .map((g) => (g['name'] ?? '').toString())
                .where((name) => name.isNotEmpty)
                .toList();
            if (groupNames.isNotEmpty) {
              sharedGroups.assignAll(groupNames);
            } else {
              sharedGroups.assignAll(['Sneaker Traders', 'NYC Horology']);
            }
          }
        }
      }
    } catch (e) {
      print('Error fetching public seller profile: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchSellerListings() async {
    if (userId.isEmpty) return;
    try {
      final response = await ApiClient.get('${ApiUrl.sellerListings}/${userId.value}', requireAuth: true);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final listingsJson = data['data'] as List<dynamic>;
        
        final List<Map<String, String>> loadedListings = [];
        for (var json in listingsJson) {
          String thumbnail = json['thumbnail']?.toString().replaceAll('`', '').trim() ?? '';
          if (thumbnail.isEmpty && json['images'] != null && (json['images'] as List).isNotEmpty) {
            thumbnail = json['images'][0].toString().replaceAll('`', '').trim();
          }
          if (thumbnail.isEmpty) {
            thumbnail = 'https://images.unsplash.com/photo-1523275335684-37898b6baf30?q=80&w=800&auto=format&fit=crop';
          }
          loadedListings.add({
            'title': json['title'] ?? 'No Title',
            'price': '\$${json['price']?.toString() ?? '0'}',
            'image': ImageHelper.formatImageUrl(thumbnail),
            'slug': json['slug']?.toString() ?? '',
          });
        }
        if (loadedListings.isNotEmpty) {
          activeListings.assignAll(loadedListings);
        } else {
          activeListings.assignAll([
            {
              'title': 'Air Max Crimson Limited',
              'price': '\$420',
              'image': 'https://images.unsplash.com/photo-1542291026-7eec264c27ff?q=80&w=500&auto=format&fit=crop',
            },
            {
              'title': 'Custom KB-88 Stealth',
              'price': '\$285',
              'image': 'https://images.unsplash.com/photo-1511467687858-23d96c32e4ae?q=80&w=500&auto=format&fit=crop',
            },
          ]);
        }
      }
    } catch (e) {
      print('Error fetching seller listings: $e');
    }
  }

  // Connection API Actions
  Future<void> sendFriendRequest() async {
    final token = await SharedPrefsHelper.getToken();
    if (token == null || token.isEmpty) {
      Get.to(() => const LoginScreen());
      return;
    }

    isConnectionActionLoading.value = true;
    try {
      final response = await ApiClient.post(
        '${ApiUrl.social}/friend-request',
        {'recipientId': userId.value},
        requireAuth: true,
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        relationshipStatus.value = 'pending_sent';
        isFriendRequestSentByMe.value = true;

        try {
          final resData = jsonDecode(response.body);
          if (resData['data'] != null && resData['data']['_id'] != null) {
            relationshipId.value = resData['data']['_id'].toString();
          }
        } catch (_) {}

        Get.snackbar(
          'Success',
          'Friend request sent successfully.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green.withOpacity(0.9),
          colorText: Colors.white,
        );
      } else {
        final errorData = jsonDecode(response.body);
        Get.snackbar(
          'Error',
          errorData['message'] ?? 'Failed to send friend request.',
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
      isConnectionActionLoading.value = false;
    }
  }

  Future<void> cancelFriendRequest() async {
    final token = await SharedPrefsHelper.getToken();
    if (token == null || token.isEmpty) {
      Get.to(() => const LoginScreen());
      return;
    }

    isConnectionActionLoading.value = true;
    try {
      final idToUse = relationshipId.value.isNotEmpty ? relationshipId.value : userId.value;
      final response = await ApiClient.post(
        '${ApiUrl.social}/cancel-request/$idToUse',
        {},
        requireAuth: true,
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        relationshipStatus.value = 'none';
        isFriendRequestSentByMe.value = false;
        relationshipId.value = '';
        Get.snackbar(
          'Success',
          'Friend request cancelled successfully.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green.withOpacity(0.9),
          colorText: Colors.white,
        );
      } else {
        final errorData = jsonDecode(response.body);
        Get.snackbar(
          'Error',
          errorData['message'] ?? 'Failed to cancel friend request.',
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
      isConnectionActionLoading.value = false;
    }
  }

  Future<void> acceptFriendRequest() async {
    final token = await SharedPrefsHelper.getToken();
    if (token == null || token.isEmpty) {
      Get.to(() => const LoginScreen());
      return;
    }

    isConnectionActionLoading.value = true;
    try {
      final idToUse = relationshipId.value.isNotEmpty ? relationshipId.value : userId.value;
      final response = await ApiClient.post(
        '${ApiUrl.social}/accept-request/$idToUse',
        {},
        requireAuth: true,
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        relationshipStatus.value = 'friend';
        isFriendRequestSentByMe.value = false;
        relationshipId.value = '';
        Get.snackbar(
          'Success',
          'Friend request accepted successfully.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green.withOpacity(0.9),
          colorText: Colors.white,
        );
      } else {
        final errorData = jsonDecode(response.body);
        Get.snackbar(
          'Error',
          errorData['message'] ?? 'Failed to accept friend request.',
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
      isConnectionActionLoading.value = false;
    }
  }

  Future<void> declineFriendRequest() async {
    final token = await SharedPrefsHelper.getToken();
    if (token == null || token.isEmpty) {
      Get.to(() => const LoginScreen());
      return;
    }

    isConnectionActionLoading.value = true;
    try {
      final idToUse = relationshipId.value.isNotEmpty ? relationshipId.value : userId.value;
      final response = await ApiClient.post(
        '${ApiUrl.social}/reject-request/$idToUse',
        {},
        requireAuth: true,
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        relationshipStatus.value = 'none';
        relationshipId.value = '';
        Get.snackbar(
          'Success',
          'Friend request declined.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green.withOpacity(0.9),
          colorText: Colors.white,
        );
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
      isConnectionActionLoading.value = false;
    }
  }

  Future<void> removeFriend() async {
    final token = await SharedPrefsHelper.getToken();
    if (token == null || token.isEmpty) {
      Get.to(() => const LoginScreen());
      return;
    }

    isConnectionActionLoading.value = true;
    try {
      final response = await ApiClient.delete(
        '${ApiUrl.social}/remove-friend/${userId.value}',
        requireAuth: true,
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        relationshipStatus.value = 'none';
        isFriendRequestSentByMe.value = false;
        relationshipId.value = '';
        Get.snackbar(
          'Success',
          'Friend removed successfully.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green.withOpacity(0.9),
          colorText: Colors.white,
        );
      } else {
        final errorData = jsonDecode(response.body);
        Get.snackbar(
          'Error',
          errorData['message'] ?? 'Failed to remove friend.',
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
      isConnectionActionLoading.value = false;
    }
  }

  Future<void> blockUser() async {
    final token = await SharedPrefsHelper.getToken();
    if (token == null || token.isEmpty) {
      Get.to(() => const LoginScreen());
      return;
    }

    isConnectionActionLoading.value = true;
    try {
      final response = await ApiClient.post(
        '${ApiUrl.social}/block-user/${userId.value}',
        {},
        requireAuth: true,
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        relationshipStatus.value = 'blocked';
        Get.snackbar(
          'Success',
          'User blocked successfully.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green.withOpacity(0.9),
          colorText: Colors.white,
        );
      } else {
        final errorData = jsonDecode(response.body);
        Get.snackbar(
          'Error',
          errorData['message'] ?? 'Failed to block user.',
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
      isConnectionActionLoading.value = false;
    }
  }

  Future<void> unblockUser() async {
    final token = await SharedPrefsHelper.getToken();
    if (token == null || token.isEmpty) {
      Get.to(() => const LoginScreen());
      return;
    }

    isConnectionActionLoading.value = true;
    try {
      final response = await ApiClient.post(
        '${ApiUrl.social}/unblock-user/${userId.value}',
        {},
        requireAuth: true,
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        relationshipStatus.value = 'none';
        Get.snackbar(
          'Success',
          'User unblocked successfully.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green.withOpacity(0.9),
          colorText: Colors.white,
        );
      } else {
        final errorData = jsonDecode(response.body);
        Get.snackbar(
          'Error',
          errorData['message'] ?? 'Failed to unblock user.',
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
      isConnectionActionLoading.value = false;
    }
  }

  Future<void> startChat() async {
    final token = await SharedPrefsHelper.getToken();
    if (token == null || token.isEmpty) {
      Get.to(() => const LoginScreen());
      return;
    }

    isConnectionActionLoading.value = true;
    try {
      final response = await ApiClient.post(
        ApiUrl.conversation,
        {
          'recipientId': userId.value,
          'conversationType': 'direct',
        },
        requireAuth: true,
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);
        if (data['success'] == true && data['data'] != null) {
          final conversationId = data['data']['_id'] ?? '';
          if (conversationId.isNotEmpty) {
            Get.to(
              () => const ChatDetailScreen(),
              arguments: {
                'conversationId': conversationId,
                'userId': userId.value,
                'name': sellerName.value,
                'image': sellerImage.value,
              },
            );
            return;
          }
        }
      }
      
      final errorMsg = response.statusCode != 200 && response.statusCode != 201
          ? jsonDecode(response.body)['message']
          : 'Failed to start conversation.';
      Get.snackbar(
        'Error',
        errorMsg ?? 'Failed to start conversation.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent.withOpacity(0.9),
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Something went wrong: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent.withOpacity(0.9),
        colorText: Colors.white,
      );
    } finally {
      isConnectionActionLoading.value = false;
    }
  }
}
