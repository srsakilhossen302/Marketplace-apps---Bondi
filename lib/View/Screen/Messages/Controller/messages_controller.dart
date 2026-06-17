import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import '../../../../service/api_client.dart';
import '../../../../service/api_url.dart';
import '../../../../helper/shared_prefe/shared_prefe.dart';
import '../../../../helper/network_img/image_helper.dart';

class MessagesController extends GetxController {
  final isDirectChat = false.obs;
  final directChatUserId = ''.obs;
  final directChatUserName = ''.obs;
  final directChatUserImage = ''.obs;
  final directConversationId = ''.obs;
  final messageTextController = TextEditingController();
  final isMessagesLoading = false.obs;
  final directChatUserOnline = false.obs;
  final groupParticipantsCount = 0.obs;

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments;
    if (args != null && args is Map && (args.containsKey('userId') || args.containsKey('conversationId'))) {
      loadChatDetails(args);
    }
  }

  void loadChatDetails(Map<dynamic, dynamic> args) {
    print('loadChatDetails arguments received: $args');
    isDirectChat.value = args['conversationType'] != 'group' && args['isGroup'] != true;
    directChatUserId.value = args['userId'] ?? '';
    directChatUserName.value = args['name'] ?? 'Seller';
    directChatUserImage.value = args['image'] ?? '';
    final newConvId = args['conversationId'] ?? '';

    directConversationId.value = newConvId;
    groupMessages.clear();

    if (newConvId.isNotEmpty) {
      print('loadChatDetails loading conversation messages with ID: $newConvId');
      fetchMessages(newConvId);
      markMessagesAsSeen(newConvId);
    }
  }

  @override
  void onClose() {
    messageTextController.dispose();
    super.onClose();
  }

  final recentChats = <Map<String, dynamic>>[].obs;

  final chatList = <Map<String, dynamic>>[].obs;

  final groupMessages = <Map<String, dynamic>>[].obs;

  Future<void> sendMessageAction() async {
    final text = messageTextController.text.trim();
    if (text.isEmpty) return;

    messageTextController.clear();

    if (directConversationId.value.isNotEmpty) {
      try {
        groupMessages.add({
          'sender': 'Me',
          'text': text,
          'isMe': true,
          'time': 'Just now',
        });

        final fields = {
          'conversationId': directConversationId.value,
          'text': text,
        };
        final response = await ApiClient.multipartPost(
          ApiUrl.sendMessage,
          fields,
          requireAuth: true,
        );
        if (response.statusCode != 200 && response.statusCode != 201) {
          Get.snackbar(
            'Error',
            'Failed to deliver message.',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.redAccent.withOpacity(0.9),
            colorText: Colors.white,
          );
        }
      } catch (e) {
        print('Error sending message: $e');
      }
    } else {
      groupMessages.add({
        'sender': 'Me',
        'text': text,
        'isMe': true,
        'time': 'Just now',
      });
    }
  }

  Future<void> fetchMessages(String conversationId) async {
    isMessagesLoading.value = true;
    try {
      final response = await ApiClient.get(
        '${ApiUrl.message}/$conversationId',
        requireAuth: true,
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success'] == true && data['data'] != null) {
          final resData = data['data'];

          // Update receiver or group info
          if (resData is Map) {
            final hasReceiverInfo = resData.containsKey('receiverInfo') && resData['receiverInfo'] != null;
            if (hasReceiverInfo) {
              final recInfo = resData['receiverInfo'];
              isDirectChat.value = true;
              directChatUserName.value = recInfo['fullName'] ?? recInfo['username'] ?? directChatUserName.value;
              directChatUserImage.value = ImageHelper.formatImageUrl(recInfo['profileImage'] ?? recInfo['picture']);
              directChatUserOnline.value = recInfo['isOnline'] ?? false;
            } else {
              isDirectChat.value = false;
              if (resData.containsKey('groupInfo') && resData['groupInfo'] != null) {
                final grpInfo = resData['groupInfo'];
                directChatUserName.value = grpInfo['groupName'] ?? directChatUserName.value;
                directChatUserImage.value = ImageHelper.formatImageUrl(grpInfo['groupImage']);
                groupParticipantsCount.value = grpInfo['participantsCount'] ?? 0;
              }
            }
          }

          // Parse list of messages (can be a direct list, nested under 'data', or nested under 'messages')
          List<dynamic> list = [];
          if (resData is List) {
            list = resData;
          } else if (resData is Map) {
            list = resData['data'] ?? resData['messages'] ?? [];
          }

          final currentUserId = await SharedPrefsHelper.getUserId() ?? '';
          final parsedMessages = list.map((msg) {
            final senderObj = msg['senderId'] ?? msg['sender'];
            String msgSenderId = '';
            String senderName = 'User';
            String senderImage = '';
            
            if (senderObj != null) {
              if (senderObj is Map) {
                msgSenderId = (senderObj['_id'] ?? senderObj['id'] ?? '').toString();
                senderName = (senderObj['fullName'] ?? senderObj['displayName'] ?? senderObj['username'] ?? 'User').toString();
                senderImage = ImageHelper.formatImageUrl(senderObj['profileImage']?.toString() ?? senderObj['picture']?.toString() ?? '');
              } else {
                msgSenderId = senderObj.toString();
              }
            }
            if (msgSenderId.isEmpty && msg['senderId'] != null && msg['senderId'] is! Map) {
              msgSenderId = msg['senderId'].toString();
            }
            
            // Check msg['isMe'] first, then fallback to currentUserId comparison
            final isMe = msg['isMe'] ?? (msgSenderId.isNotEmpty && msgSenderId == currentUserId);
            if (senderImage.isEmpty && !isMe) {
              senderImage = directChatUserImage.value;
            }
            if (senderImage.isEmpty) {
              senderImage = 'https://i.pravatar.cc/150?u=${senderName.hashCode}';
            }

            return {
              'sender': senderName,
              'text': msg['text'] ?? msg['content'] ?? '',
              'isMe': isMe,
              'image': senderImage,
              'messageType': msg['messageType'] ?? 'text',
              'mediaUrls': msg['mediaUrls'] != null ? List<String>.from(msg['mediaUrls']) : <String>[],
              'time': msg['createdAt'] != null 
                  ? DateTime.parse(msg['createdAt']).toLocal().toString().substring(11, 16) 
                  : '',
            };
          }).toList();

          // Reverse messages list to display chronologically (oldest at top, newest at bottom)
          groupMessages.assignAll(parsedMessages.reversed.toList());
        }
      }
    } catch (e) {
      print('Error fetching messages: $e');
    } finally {
      isMessagesLoading.value = false;
    }
  }

  Future<void> markMessagesAsSeen(String conversationId) async {
    try {
      await ApiClient.post(
        '${ApiUrl.messageSeen}/$conversationId',
        {},
        requireAuth: true,
      );
    } catch (e) {
      print('Error marking messages as seen: $e');
    }
  }

  final ImagePicker _imagePicker = ImagePicker();

  Future<void> pickAndSendImage() async {
    try {
      List<XFile>? pickedFiles = await _imagePicker.pickMultiImage(
        imageQuality: 70,
      );
      if (pickedFiles != null && pickedFiles.isNotEmpty) {
        if (pickedFiles.length > 5) {
          pickedFiles = pickedFiles.sublist(0, 5);
          Get.snackbar(
            'Limit Exceeded',
            'Only the first 5 images will be sent.',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.orangeAccent.withOpacity(0.9),
            colorText: Colors.white,
          );
        }
        await uploadImageMessages(pickedFiles);
      }
    } catch (e) {
      print('Error picking images: $e');
    }
  }

  Future<void> uploadImageMessages(List<XFile> filesList) async {
    if (directConversationId.value.isEmpty) return;

    try {
      groupMessages.add({
        'sender': 'Me',
        'text': '[Sending ${filesList.length} image(s)...]',
        'isMe': true,
        'time': 'Just now',
      });

      final fields = {
        'conversationId': directConversationId.value,
        'text': '',
      };

      List<http.MultipartFile> files = [];
      for (var file in filesList) {
        files.add(await http.MultipartFile.fromPath(
          'media',
          file.path,
        ));
      }

      final response = await ApiClient.multipartPost(
        ApiUrl.sendMessage,
        fields,
        files: files,
        requireAuth: true,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        fetchMessages(directConversationId.value);
      } else {
        Get.snackbar(
          'Error',
          'Failed to send image(s).',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.redAccent.withOpacity(0.9),
          colorText: Colors.white,
        );
      }
    } catch (e) {
      print('Error sending image messages: $e');
    }
  }

  final isConversationsLoading = false.obs;

  Future<void> fetchConversations() async {
    isConversationsLoading.value = true;
    try {
      final response = await ApiClient.get(ApiUrl.conversation, requireAuth: true);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success'] == true && data['data'] != null) {
          final List<dynamic> list = data['data'];
          final currentUserId = await SharedPrefsHelper.getUserId() ?? '';
          
          final List<Map<String, dynamic>> parsedChats = [];
          for (var conv in list) {
            if (conv is! Map) continue;
            
            final conversationId = conv['_id'] ?? '';
            final conversationType = conv['conversationType'] ?? 'direct';
            
            // Extract other participant details
            final participants = conv['participants'] as List<dynamic>? ?? [];
            Map<String, dynamic> otherParticipant = {};
            for (var p in participants) {
              if (p is Map) {
                final pId = (p['_id'] ?? p['id'] ?? '').toString();
                if (pId != currentUserId) {
                  otherParticipant = Map<String, dynamic>.from(p);
                  break;
                }
              }
            }
            if (otherParticipant.isEmpty && participants.isNotEmpty) {
              otherParticipant = Map<String, dynamic>.from(participants[0]);
            }
            
            final otherUserId = otherParticipant['_id'] ?? otherParticipant['id'] ?? '';
            final otherUserName = otherParticipant['fullName'] ?? otherParticipant['displayName'] ?? otherParticipant['username'] ?? 'User';
            final otherUserImage = otherParticipant['profileImage'] ?? otherParticipant['picture'] ?? '';
            final isOnline = otherParticipant['status'] == 'active';

            // Extract last message info
            final lastMessageId = conv['lastMessageId'];
            String lastMsgText = '';
            bool isSeen = true;
            if (lastMessageId != null && lastMessageId is Map) {
              lastMsgText = lastMessageId['content'] ?? '';
              isSeen = lastMessageId['isSeen'] ?? true;
              if (lastMsgText.isEmpty) {
                final msgType = lastMessageId['messageType'] ?? '';
                if (msgType == 'text') {
                  lastMsgText = 'Message';
                } else if (msgType.isNotEmpty) {
                  lastMsgText = '[Media]';
                }
              }
            }
            if (lastMsgText.isEmpty) {
              lastMsgText = 'Tap to chat';
            }

            // Extract time
            String lastMsgTime = '';
            final timeStr = conv['lastActivity'] ?? conv['updatedAt'] ?? (lastMessageId is Map ? lastMessageId['createdAt'] : null);
            if (timeStr != null) {
              try {
                final date = DateTime.parse(timeStr.toString()).toLocal();
                lastMsgTime = "${date.hour}:${date.minute.toString().padLeft(2, '0')}";
              } catch (e) {
                lastMsgTime = '';
              }
            }

            final isGroup = conversationType == 'group' || conversationType == 'trade';
            final grpImage = conv['groupImage']?.toString() ?? '';
            final grpName = conv['groupName']?.toString() ?? '';

            parsedChats.add({
              '_id': conversationId,
              'userId': otherUserId,
              'title': isGroup ? (grpName.isNotEmpty ? grpName : 'Group Chat') : otherUserName,
              'lastMsg': lastMsgText,
              'time': lastMsgTime,
              'status': isSeen ? 'Read' : 'Unread',
              'image': isGroup 
                  ? ImageHelper.formatImageUrl(grpImage) 
                  : ImageHelper.formatImageUrl(otherUserImage),
              'groupImage': ImageHelper.formatImageUrl(grpImage),
              'groupName': grpName,
              'isGroup': isGroup,
              'conversationType': conversationType,
              'online': isOnline,
              'otherParticipant': otherParticipant,
            });
          }
          
          chatList.assignAll(parsedChats);
 
          // Build dynamic recentChats list (taking up to 10 most recent)
          final List<Map<String, dynamic>> parsedRecent = parsedChats.map((chat) {
            final title = chat['title'] ?? 'User';
            final img = (chat['image'] != null && (chat['image'] as String).isNotEmpty)
                ? chat['image'] as String
                : 'https://i.pravatar.cc/150?u=${title.hashCode}';
            return {
              '_id': chat['_id'],
              'userId': chat['userId'],
              'name': title,
              'image': img,
              'online': chat['online'] ?? false,
              'isGroup': chat['isGroup'] ?? false,
              'conversationType': chat['conversationType'] ?? 'direct',
            };
          }).take(10).toList();
          recentChats.assignAll(parsedRecent);
        }
      }
    } catch (e) {
      print('Error fetching conversations: $e');
    } finally {
      isConversationsLoading.value = false;
    }
  }
}
