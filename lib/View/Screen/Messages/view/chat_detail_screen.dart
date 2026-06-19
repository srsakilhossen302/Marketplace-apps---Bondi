import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../Utils/AppColors/app_colors.dart';
import '../../../../Utils/StaticString/static_string.dart';
import '../../../../Model/home_models.dart';
import '../../../../service/api_client.dart';
import '../../../../service/api_url.dart';
import '../../../../helper/network_img/image_helper.dart';
import '../../ProductDetails/view/product_details_screen.dart';
import '../Controller/messages_controller.dart';

class ChatDetailScreen extends GetView<MessagesController> {
  const ChatDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    if (!Get.isRegistered<MessagesController>()) {
      Get.put(MessagesController());
    }
    final messagesController = Get.find<MessagesController>();
    final args = Get.arguments;
    if (args != null && args is Map && (args.containsKey('userId') || args.containsKey('conversationId'))) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        messagesController.loadChatDetails(args);
      });
    }

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: AppColors.backgroundColor,
        child: SafeArea(
          child: Column(
            children: [
              _buildAppBar(),
              Expanded(
                child: Obx(
                  () {
                    if (controller.isMessagesLoading.value) {
                      return const Center(
                        child: CircularProgressIndicator(
                          color: AppColors.accentColor,
                        ),
                      );
                    }
                    if (controller.groupMessages.isEmpty) {
                      return Center(
                        child: Text(
                          'No messages yet. Say hello!',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.6),
                            fontSize: 14.sp,
                          ),
                        ),
                      );
                    }
                    return ListView.builder(
                      padding: EdgeInsets.symmetric(
                        horizontal: 20.w,
                        vertical: 10.h,
                      ),
                      itemCount: controller.groupMessages.length,
                      itemBuilder: (context, index) {
                        final msg = controller.groupMessages[index];
                        if (msg['isSystem'] == true) {
                          return _buildSystemMessage(msg['text'] as String);
                        } else if (msg['messageType'] == 'listing_card' || (msg['isCard'] == true && msg['listingId'] != null)) {
                          final listingData = msg['listingId'];
                          final isMe = msg['isMe'] == true;
                          
                          // Handle nested senderId object if present
                          final senderMap = msg['senderId'] is Map ? msg['senderId'] as Map : null;
                          final senderName = senderMap != null
                              ? (senderMap['fullName'] ?? senderMap['username'] ?? 'User').toString()
                              : (msg['sender'] ?? 'User').toString();
                          final senderImg = senderMap != null
                              ? (senderMap['profileImage'] ?? senderMap['picture'] ?? '').toString()
                              : (msg['senderImage'] ?? msg['image'] ?? '').toString();

                          if (listingData is Map) {
                            return SharedListingCard(
                              listingMap: Map<String, dynamic>.from(listingData),
                              sender: senderName,
                              senderImage: senderImg,
                              isMe: isMe,
                            );
                          } else {
                            return SharedListingCard(
                              listingIdString: listingData?.toString() ?? '',
                              sender: senderName,
                              senderImage: senderImg,
                              isMe: isMe,
                            );
                          }
                        } else if (msg['isCard'] == true) {
                          return _buildProductCard(msg);
                        } else if (msg['messageType'] == 'image') {
                          return _buildImageMessageBubble(msg);
                        } else {
                          return _buildMessageBubble(msg);
                        }
                      },
                    );
                  },
                ),
              ),
              _buildInputArea(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return Obx(() {
      final isDirect = controller.isDirectChat.value;
      final title = controller.directChatUserName.value.isNotEmpty
          ? controller.directChatUserName.value
          : (isDirect ? 'Chat' : StaticString.sneakerTraders);
      final subtitle = isDirect 
          ? (controller.directChatUserOnline.value ? "Online" : "Offline") 
          : "${controller.groupParticipantsCount.value} Members";
      final image = controller.directChatUserImage.value.isNotEmpty
          ? controller.directChatUserImage.value
          : (isDirect
              ? 'https://i.pravatar.cc/150?u=${controller.directChatUserName.value.hashCode}'
              : 'https://images.unsplash.com/photo-1552346154-21d32810aba3?q=80&w=200');

      return Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
        child: Row(
          children: [
            GestureDetector(
              onTap: () => Get.back(),
              child: Icon(Icons.arrow_back, color: Colors.white, size: 24.sp),
            ),
            SizedBox(width: 15.w),
            Stack(
              children: [
                CircleAvatar(
                  radius: 20.r,
                  backgroundImage: NetworkImage(image),
                ),
                Positioned(
                  right: 0,
                  bottom: 0,
                  child: Container(
                    width: 10.w,
                    height: 10.h,
                    decoration: BoxDecoration(
                      color: (!isDirect || controller.directChatUserOnline.value) ? Colors.green : Colors.grey,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: AppColors.backgroundColor,
                        width: 1.5,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.6),
                      fontSize: 11.sp,
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.search, color: Colors.white, size: 24.sp),
            SizedBox(width: 15.w),
            Icon(Icons.more_vert, color: Colors.white, size: 24.sp),
          ],
        ),
      );
    });
  }

  Widget _buildSystemMessage(String text) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 15.h),
        child: RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: "${StaticString.lacesOut} ",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextSpan(
                text: text,
                style: TextStyle(
                  color: Colors.white.withOpacity(0.6),
                  fontSize: 12.sp,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMessageBubble(Map<String, dynamic> msg) {
    bool isMe = msg['isMe'] == true;
    return Padding(
      padding: EdgeInsets.only(bottom: 20.h),
      child: Column(
        crossAxisAlignment: isMe
            ? CrossAxisAlignment.end
            : CrossAxisAlignment.start,
        children: [
          if (!isMe)
            Padding(
              padding: EdgeInsets.only(left: 45.w, bottom: 4.h),
              child: Text(
                msg['sender'] as String,
                style: TextStyle(
                  color: Colors.white.withOpacity(0.8),
                  fontSize: 12.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          Row(
            mainAxisAlignment: isMe
                ? MainAxisAlignment.end
                : MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (!isMe)
                CircleAvatar(
                  radius: 18.r,
                  backgroundImage: NetworkImage(
                    (msg['image'] != null && (msg['image'] as String).isNotEmpty)
                        ? msg['image'] as String
                        : 'https://i.pravatar.cc/150?u=${(msg['sender'] ?? 'User').hashCode}',
                  ),
                ),
              if (!isMe) SizedBox(width: 10.w),
              Flexible(
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 12.h,
                  ),
                  decoration: BoxDecoration(
                    color: isMe
                        ? Colors.white.withOpacity(0.1)
                        : Colors.white.withOpacity(0.15),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20.r),
                      topRight: Radius.circular(20.r),
                      bottomLeft: isMe
                          ? Radius.circular(20.r)
                          : Radius.circular(0),
                      bottomRight: isMe
                          ? Radius.circular(0)
                          : Radius.circular(20.r),
                    ),
                  ),
                  child: Text(
                    msg['text'] as String,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14.sp,
                      height: 1.4,
                    ),
                  ),
                ),
              ),
            ],
          ),
          if (msg['time'] != null)
            Padding(
              padding: EdgeInsets.only(top: 4.h),
              child: Text(
                msg['time'] as String,
                style: TextStyle(
                  color: Colors.white.withOpacity(0.4),
                  fontSize: 10.sp,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildProductCard(Map<String, dynamic> msg) {
    return Padding(
      padding: EdgeInsets.only(bottom: 20.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          CircleAvatar(
            radius: 18.r,
            backgroundImage: NetworkImage(
              (msg['senderImage'] != null && (msg['senderImage'] as String).isNotEmpty)
                  ? msg['senderImage'] as String
                  : (msg['image'] != null && (msg['image'] as String).isNotEmpty)
                      ? msg['image'] as String
                      : 'https://i.pravatar.cc/150?u=${(msg['sender'] ?? 'User').hashCode}',
            ),
          ),
          SizedBox(width: 10.w),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                borderRadius: BorderRadius.circular(25.r),
                border: Border.all(color: Colors.white.withOpacity(0.1)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(25.r),
                        ),
                        child: Image.network(
                          msg['image'] as String,
                          height: 180.h,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Positioned(
                        top: 12.h,
                        right: 12.w,
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 10.w,
                            vertical: 4.h,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10.r),
                          ),
                          child: Text(
                            StaticString.newListing.toUpperCase(),
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 9.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.all(15.r),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              msg['title'] as String,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16.sp,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              msg['price'] as String,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16.sp,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 10.h),
                        Row(
                          children: [
                            _buildBadge(
                              msg['details'].toString().split(' • ')[0],
                            ),
                            SizedBox(width: 8.w),
                            _buildBadge(
                              msg['details'].toString().split(' • ')[1],
                            ),
                          ],
                        ),
                        SizedBox(height: 15.h),
                        SizedBox(
                          width: double.infinity,
                          height: 45.h,
                          child: ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.buttonColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25.r),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  StaticString.viewListing,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(width: 8.w),
                                Icon(
                                  Icons.arrow_forward,
                                  color: Colors.white,
                                  size: 16.sp,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBadge(String text) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(15.r),
      ),
      child: Text(
        text,
        style: TextStyle(color: Colors.white.withOpacity(0.6), fontSize: 11.sp),
      ),
    );
  }

  Widget _buildInputArea() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 15.h),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => controller.pickAndSendImage(),
            child: Container(
              padding: EdgeInsets.all(10.r),
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.add, color: AppColors.cardColor, size: 24.sp),
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 15.w),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(25.r),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Obx(() => TextField(
                      controller: controller.messageTextController,
                      style: TextStyle(color: Colors.black, fontSize: 14.sp),
                      decoration: InputDecoration(
                        hintText: controller.isDirectChat.value ? "Message..." : StaticString.messageGroup,
                        hintStyle: TextStyle(
                          color: Colors.black.withOpacity(0.3),
                          fontSize: 14.sp,
                        ),
                        border: InputBorder.none,
                        isDense: true,
                        contentPadding: EdgeInsets.symmetric(vertical: 12.h),
                      ),
                    )),
                  ),
                  Icon(
                    Icons.sentiment_satisfied_alt,
                    color: Colors.black.withOpacity(0.3),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(width: 12.w),
          GestureDetector(
            onTap: () => controller.sendMessageAction(),
            child: Container(
              padding: EdgeInsets.all(10.r),
              decoration: const BoxDecoration(
                color: AppColors.buttonColor,
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.send, color: Colors.white, size: 24.sp),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImageMessageBubble(Map<String, dynamic> msg) {
    bool isMe = msg['isMe'] == true;
    final List<dynamic> mediaUrls = msg['mediaUrls'] ?? [];
    final text = msg['text'] as String? ?? '';

    return Padding(
      padding: EdgeInsets.only(bottom: 20.h),
      child: Column(
        crossAxisAlignment: isMe
            ? CrossAxisAlignment.end
            : CrossAxisAlignment.start,
        children: [
          if (!isMe)
            Padding(
              padding: EdgeInsets.only(left: 45.w, bottom: 4.h),
              child: Text(
                msg['sender'] as String? ?? 'User',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.8),
                  fontSize: 12.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          Row(
            mainAxisAlignment: isMe
                ? MainAxisAlignment.end
                : MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (!isMe)
                CircleAvatar(
                  radius: 18.r,
                  backgroundImage: NetworkImage(
                    (msg['image'] != null && (msg['image'] as String).isNotEmpty)
                        ? msg['image'] as String
                        : 'https://i.pravatar.cc/150?u=${(msg['sender'] ?? 'User').hashCode}',
                  ),
                ),
              if (!isMe) SizedBox(width: 10.w),
              Flexible(
                child: Container(
                  padding: EdgeInsets.all(8.r),
                  decoration: BoxDecoration(
                    color: isMe
                        ? Colors.white.withOpacity(0.1)
                        : Colors.white.withOpacity(0.15),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20.r),
                      topRight: Radius.circular(20.r),
                      bottomLeft: isMe
                          ? Radius.circular(20.r)
                          : Radius.circular(0),
                      bottomRight: isMe
                          ? Radius.circular(0)
                          : Radius.circular(20.r),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (mediaUrls.isNotEmpty)
                        Column(
                          children: mediaUrls.map((url) {
                            return Padding(
                              padding: EdgeInsets.only(bottom: mediaUrls.last == url ? 0.h : 6.h),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(15.r),
                                child: Image.network(
                                  url.toString(),
                                  width: 200.w,
                                  fit: BoxFit.cover,
                                  loadingBuilder: (context, child, loadingProgress) {
                                    if (loadingProgress == null) return child;
                                    return Container(
                                      width: 200.w,
                                      height: 150.h,
                                      color: Colors.white.withOpacity(0.05),
                                      child: const Center(
                                        child: CircularProgressIndicator(
                                          color: AppColors.accentColor,
                                        ),
                                      ),
                                    );
                                  },
                                  errorBuilder: (context, error, stackTrace) {
                                    return Container(
                                      width: 200.w,
                                      height: 100.h,
                                      color: Colors.white.withOpacity(0.05),
                                      child: const Icon(
                                        Icons.broken_image,
                                        color: Colors.white38,
                                      ),
                                    );
                                  },
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      if (text.isNotEmpty)
                        Padding(
                          padding: EdgeInsets.only(top: 8.h, left: 8.w, right: 8.w, bottom: 4.h),
                          child: Text(
                            text,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14.sp,
                              height: 1.4,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          if (msg['time'] != null)
            Padding(
              padding: EdgeInsets.only(top: 4.h),
              child: Text(
                msg['time'] as String,
                style: TextStyle(
                  color: Colors.white.withOpacity(0.4),
                  fontSize: 10.sp,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class SharedListingCard extends StatefulWidget {
  final String? listingIdString;
  final Map<String, dynamic>? listingMap;
  final String sender;
  final String senderImage;
  final bool isMe;

  const SharedListingCard({
    super.key,
    this.listingIdString,
    this.listingMap,
    required this.sender,
    required this.senderImage,
    required this.isMe,
  });

  @override
  State<SharedListingCard> createState() => _SharedListingCardState();
}

class _SharedListingCardState extends State<SharedListingCard> {
  late Future<Map<String, dynamic>?> _listingFuture;

  @override
  void initState() {
    super.initState();
    if (widget.listingMap != null) {
      _listingFuture = Future.value(widget.listingMap);
    } else {
      _listingFuture = _fetchListingDetails();
    }
  }

  Future<Map<String, dynamic>?> _fetchListingDetails() async {
    final id = widget.listingIdString;
    if (id == null || id.isEmpty) return null;
    try {
      final response = await ApiClient.get(
        '${ApiUrl.listing}/$id',
        requireAuth: true,
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success'] == true && data['data'] != null) {
          final resData = data['data'];
          final listingMap = resData['listing'] != null 
              ? Map<String, dynamic>.from(resData['listing']) 
              : Map<String, dynamic>.from(resData);
          return listingMap;
        }
      }
    } catch (e) {
      print('Error fetching card details: $e');
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 20.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: widget.isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          if (!widget.isMe) ...[
            CircleAvatar(
              radius: 18.r,
              backgroundImage: NetworkImage(
                widget.senderImage.isNotEmpty
                    ? widget.senderImage
                    : 'https://i.pravatar.cc/150?u=${widget.sender.hashCode}',
              ),
            ),
            SizedBox(width: 10.w),
          ],
          Expanded(
            child: FutureBuilder<Map<String, dynamic>?>(
              future: _listingFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Container(
                    height: 180.h,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(25.r),
                    ),
                    child: const Center(
                      child: CircularProgressIndicator(color: AppColors.accentColor),
                    ),
                  );
                }
                
                final listing = snapshot.data;
                if (listing == null) {
                  return Container(
                    padding: EdgeInsets.all(16.r),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(25.r),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.error_outline, color: Colors.white.withOpacity(0.4)),
                        SizedBox(width: 10.w),
                        Text(
                          'Listing not available',
                          style: TextStyle(color: Colors.white.withOpacity(0.4), fontSize: 13.sp),
                        ),
                      ],
                    ),
                  );
                }

                // Parse fields
                final title = listing['title']?.toString() ?? 'No Title';
                final price = listing['price']?.toString() ?? '0';
                final condition = listing['condition']?.toString() ?? 'new';
                final listingType = listing['listingType']?.toString() ?? 'sale';

                String thumbnail = listing['thumbnail']?.toString().replaceAll('`', '').trim() ?? '';
                if (thumbnail.isEmpty && listing['images'] != null && (listing['images'] as List).isNotEmpty) {
                  thumbnail = listing['images'][0].toString().replaceAll('`', '').trim();
                }
                final formattedImg = ImageHelper.formatImageUrl(thumbnail);

                // Map condition for badge
                String conditionDisplay = 'New';
                if (condition.toLowerCase() == 'like_new') {
                  conditionDisplay = 'Like New';
                } else if (condition.toLowerCase() == 'good') {
                  conditionDisplay = 'Used - Good';
                }

                // Map type for badge
                String typeDisplay = 'Sell';
                if (listingType.toLowerCase() == 'trade') {
                  typeDisplay = 'Trade';
                } else if (listingType.toLowerCase() == 'sale_and_trade') {
                  typeDisplay = 'Trade or Sell';
                }

                return GestureDetector(
                  onTap: () => _navigateToDetails(listing, formattedImg),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(25.r),
                      border: Border.all(color: Colors.white.withOpacity(0.1)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Stack(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.vertical(
                                top: Radius.circular(25.r),
                              ),
                              child: Image.network(
                                formattedImg,
                                height: 180.h,
                                width: double.infinity,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) => Container(
                                  height: 180.h,
                                  color: Colors.white.withOpacity(0.05),
                                  child: const Icon(Icons.broken_image, color: Colors.white38),
                                ),
                              ),
                            ),
                            Positioned(
                              top: 12.h,
                              right: 12.w,
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 10.w,
                                  vertical: 4.h,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10.r),
                                ),
                                child: Text(
                                  StaticString.newListing.toUpperCase(),
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 9.sp,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: EdgeInsets.all(15.r),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Text(
                                      title,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16.sp,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  Text(
                                    '\$$price',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 10.h),
                              Row(
                                children: [
                                  _buildBadge(conditionDisplay),
                                  SizedBox(width: 8.w),
                                  _buildBadge(typeDisplay),
                                ],
                              ),
                              SizedBox(height: 15.h),
                              SizedBox(
                                width: double.infinity,
                                height: 45.h,
                                child: ElevatedButton(
                                  onPressed: () => _navigateToDetails(listing, formattedImg),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.buttonColor,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(25.r),
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        StaticString.viewListing,
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 14.sp,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      SizedBox(width: 8.w),
                                      Icon(
                                        Icons.arrow_forward,
                                        color: Colors.white,
                                        size: 16.sp,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          if (widget.isMe) ...[
            SizedBox(width: 46.w),
          ] else ...[
            SizedBox(width: 46.w),
          ],
        ],
      ),
    );
  }

  Widget _buildBadge(String text) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(15.r),
      ),
      child: Text(
        text,
        style: TextStyle(color: Colors.white.withOpacity(0.6), fontSize: 11.sp),
      ),
    );
  }

  void _navigateToDetails(Map<String, dynamic> listingJson, String formattedImg) {
    final sellerName = listingJson['sellerProfileId'] != null
        ? (listingJson['sellerProfileId']['displayName'] ?? 'Seller').toString()
        : 'Seller';

    final listingModel = ListingModel(
      title: listingJson['title']?.toString() ?? '',
      price: '\$${listingJson['price']?.toString() ?? '0'}',
      seller: sellerName,
      image: formattedImg,
      isNew: listingJson['condition']?.toString().toLowerCase() == 'new',
      isTrade: listingJson['listingType']?.toString().toLowerCase() == 'trade' || 
               listingJson['listingType']?.toString().toLowerCase() == 'sale_and_trade',
      slug: listingJson['slug']?.toString() ?? '',
    );

    Get.to(() => const ProductDetailsScreen(), arguments: listingModel);
  }
}
