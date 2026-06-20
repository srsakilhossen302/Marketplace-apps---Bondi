import 'dart:convert';
import 'package:get/get.dart';
import '../../../../service/api_client.dart';
import '../../../../service/api_url.dart';
import '../../../../helper/network_img/image_helper.dart';

class FriendsController extends GetxController {
  final friends = <Map<String, String>>[].obs;
  final following = <Map<String, String>>[].obs;
  final requests = <Map<String, String>>[].obs;
  final suggested = <Map<String, String>>[].obs;
  final recommended = <Map<String, String>>[].obs;

  final selectedTab = 0.obs;
  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadAllData();
  }

  Future<void> loadAllData() async {
    isLoading.value = true;
    try {
      await Future.wait([
        fetchFriends(),
        fetchFollowing(),
        fetchRequests(),
        fetchSuggested(),
      ]);
    } catch (e) {
      print('Error loading all data: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Map<String, String> _parseUser(Map<String, dynamic> item) {
    String id = (item['_id'] ?? item['id'] ?? '').toString();
    String name = '';
    String image = '';
    String relationshipId = '';

    if (item['sender'] != null && item['sender'] is Map) {
      final sender = item['sender'] as Map<String, dynamic>;
      relationshipId = id;
      id = (sender['_id'] ?? sender['id'] ?? '').toString();
      name = (sender['fullName'] ?? sender['username'] ?? '').toString();
      image = (sender['profileImage'] ?? sender['picture'] ?? '').toString();
    } else if (item['recipient'] != null && item['recipient'] is Map) {
      final recipient = item['recipient'] as Map<String, dynamic>;
      relationshipId = id;
      id = (recipient['_id'] ?? recipient['id'] ?? '').toString();
      name = (recipient['fullName'] ?? recipient['username'] ?? '').toString();
      image = (recipient['profileImage'] ?? recipient['picture'] ?? '').toString();
    } else {
      name = (item['fullName'] ?? item['username'] ?? '').toString();
      image = (item['profileImage'] ?? item['picture'] ?? '').toString();
    }

    if (name.isEmpty) {
      name = 'Jane Doe';
    }

    image = ImageHelper.formatImageUrl(image);
    if (image.isEmpty) {
      image = 'https://i.pravatar.cc/150?u=${name.hashCode}';
    }

    int mutualCount = 0;
    if (item['mutualFriends'] != null) {
      if (item['mutualFriends'] is Map) {
        mutualCount = item['mutualFriends']['meta']?['total'] ?? 0;
      } else if (item['mutualFriends'] is List) {
        mutualCount = (item['mutualFriends'] as List).length;
      }
    } else if (item['mutualFriendsCount'] != null) {
      mutualCount = int.tryParse(item['mutualFriendsCount'].toString()) ?? 0;
    }

    return {
      'id': id,
      'relationshipId': relationshipId.isNotEmpty ? relationshipId : id,
      'name': name,
      'mutual': mutualCount > 0 ? '$mutualCount mutual friends' : 'No mutual friends',
      'image': image,
    };
  }

  Future<void> fetchFriends() async {
    try {
      final response = await ApiClient.get('${ApiUrl.social}/friends', requireAuth: true);
      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        if (decoded['success'] == true && decoded['data'] != null) {
          final List<dynamic> data = decoded['data'];
          friends.assignAll(data.map((e) => _parseUser(Map<String, dynamic>.from(e))).toList());
        }
      }
    } catch (e) {
      print('Error fetching friends: $e');
    }
  }

  Future<void> fetchFollowing() async {
    try {
      final response = await ApiClient.get('${ApiUrl.social}/sent-requests', requireAuth: true);
      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        if (decoded['success'] == true && decoded['data'] != null) {
          final List<dynamic> data = decoded['data'];
          following.assignAll(data.map((e) => _parseUser(Map<String, dynamic>.from(e))).toList());
        }
      }
    } catch (e) {
      print('Error fetching sent requests: $e');
    }
  }

  Future<void> fetchRequests() async {
    try {
      final response = await ApiClient.get('${ApiUrl.social}/pending-requests', requireAuth: true);
      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        if (decoded['success'] == true && decoded['data'] != null) {
          final List<dynamic> data = decoded['data'];
          requests.assignAll(data.map((e) => _parseUser(Map<String, dynamic>.from(e))).toList());
        }
      }
    } catch (e) {
      print('Error fetching pending requests: $e');
    }
  }

  Future<void> fetchSuggested() async {
    try {
      final response = await ApiClient.get('${ApiUrl.social}/recommendations', requireAuth: true);
      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        if (decoded['success'] == true && decoded['data'] != null) {
          final List<dynamic> data = decoded['data'];
          final parsed = data.map((e) => _parseUser(Map<String, dynamic>.from(e))).toList();
          suggested.assignAll(parsed);
          recommended.assignAll(parsed.take(3).toList());
        }
      }
    } catch (e) {
      print('Error fetching recommendations: $e');
    }
  }

  Future<void> acceptFriendRequest(String relationshipId) async {
    try {
      final response = await ApiClient.post(
        '${ApiUrl.social}/accept-request/$relationshipId',
        {},
        requireAuth: true,
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        Get.snackbar('Success', 'Friend request accepted.');
        loadAllData();
      } else {
        final decoded = jsonDecode(response.body);
        Get.snackbar('Error', decoded['message'] ?? 'Failed to accept request.');
      }
    } catch (e) {
      Get.snackbar('Error', 'Something went wrong: $e');
    }
  }

  Future<void> declineFriendRequest(String relationshipId) async {
    try {
      final response = await ApiClient.post(
        '${ApiUrl.social}/reject-request/$relationshipId',
        {},
        requireAuth: true,
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        Get.snackbar('Success', 'Friend request declined.');
        loadAllData();
      } else {
        final decoded = jsonDecode(response.body);
        Get.snackbar('Error', decoded['message'] ?? 'Failed to reject request.');
      }
    } catch (e) {
      Get.snackbar('Error', 'Something went wrong: $e');
    }
  }

  Future<void> sendFriendRequest(String userId) async {
    try {
      final response = await ApiClient.post(
        '${ApiUrl.social}/friend-request',
        {'recipientId': userId},
        requireAuth: true,
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        Get.snackbar('Success', 'Friend request sent successfully.');
        loadAllData();
      } else {
        final decoded = jsonDecode(response.body);
        Get.snackbar('Error', decoded['message'] ?? 'Failed to send request.');
      }
    } catch (e) {
      Get.snackbar('Error', 'Something went wrong: $e');
    }
  }

  Future<void> cancelFriendRequest(String relationshipId) async {
    try {
      final response = await ApiClient.post(
        '${ApiUrl.social}/cancel-request/$relationshipId',
        {},
        requireAuth: true,
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        Get.snackbar('Success', 'Friend request cancelled.');
        loadAllData();
      } else {
        final decoded = jsonDecode(response.body);
        Get.snackbar('Error', decoded['message'] ?? 'Failed to cancel request.');
      }
    } catch (e) {
      Get.snackbar('Error', 'Something went wrong: $e');
    }
  }
}
