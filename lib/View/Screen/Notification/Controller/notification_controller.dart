import 'dart:convert';
import 'package:get/get.dart';
import '../../../../service/api_client.dart';
import '../../../../service/api_url.dart';
import '../../../../helper/network_img/image_helper.dart';

class NotificationController extends GetxController {
  final notifications = <Map<String, dynamic>>[].obs;
  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchNotifications();
  }

  Future<void> fetchNotifications() async {
    isLoading.value = true;
    try {
      final response = await ApiClient.get(ApiUrl.notification, requireAuth: true);
      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        if (decoded['success'] == true && decoded['data'] != null) {
          final List<dynamic> list = decoded['data'];
          final mappedList = list.map((e) => Map<String, dynamic>.from(e)).toList();
          notifications.assignAll(mappedList);
        }
      }
    } catch (e) {
      print('Error fetching notifications: $e');
    } finally {
      isLoading.value = false;
    }
  }

  String formatTimeAgo(String? timeStr) {
    if (timeStr == null || timeStr.trim().isEmpty) return '';
    try {
      final dateTime = DateTime.parse(timeStr).toLocal();
      final difference = DateTime.now().difference(dateTime);
      if (difference.inDays >= 365) {
        final years = (difference.inDays / 365).floor();
        return '${years}y ago';
      } else if (difference.inDays >= 30) {
        final months = (difference.inDays / 30).floor();
        return '${months}mo ago';
      } else if (difference.inDays >= 7) {
        final weeks = (difference.inDays / 7).floor();
        return '${weeks}w ago';
      } else if (difference.inDays >= 1) {
        return '${difference.inDays}d ago';
      } else if (difference.inHours >= 1) {
        return '${difference.inHours}h ago';
      } else if (difference.inMinutes >= 1) {
        return '${difference.inMinutes}m ago';
      } else {
        return 'Just now';
      }
    } catch (e) {
      return '';
    }
  }

  Map<String, dynamic> mapApiToUi(Map<String, dynamic> apiData) {
    final actor = apiData['actorId'] is Map ? apiData['actorId'] : null;
    final actorName = actor != null ? (actor['username'] ?? '') : '';
    final actorPic = actor != null ? (actor['picture'] ?? '') : '';
    
    String user = '';
    String action = '';
    String? message;
    String? status;
    
    final type = apiData['type']?.toString() ?? '';
    final body = apiData['body']?.toString() ?? '';
    final title = apiData['title']?.toString() ?? '';
    
    if (type == 'new_message') {
      user = actorName.isNotEmpty ? actorName : title;
      action = 'sent you a message:';
      message = body;
    } else if (type == 'friend_request') {
      user = actorName.isNotEmpty ? actorName : 'Someone';
      action = 'sent you a friend request.';
    } else if (type == 'trade_accepted') {
      user = actorName.isNotEmpty ? actorName : 'Someone';
      action = 'accepted your trade offer.';
      status = 'Trade Accepted';
    } else if (type == 'trade_completed') {
      user = 'Trade Completed';
      action = body;
      status = 'Completed';
    } else {
      user = title;
      action = body;
    }
    
    return {
      'id': apiData['_id'],
      'type': type,
      'user': user.isNotEmpty ? user : null,
      'action': action,
      'message': message,
      'status': status,
      'time': formatTimeAgo(apiData['createdAt']),
      'user_image': actorPic.isNotEmpty ? ImageHelper.formatImageUrl(actorPic) : null,
      'is_unread': apiData['isRead'] == false,
      'redirectType': apiData['redirectType'],
      'redirectId': apiData['redirectId'],
      '_raw': apiData,
    };
  }
}
