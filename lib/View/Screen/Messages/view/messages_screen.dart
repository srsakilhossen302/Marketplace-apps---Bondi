import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import '../../../../Utils/AppColors/app_colors.dart';
import '../../../../Utils/StaticString/static_string.dart';
import '../Controller/messages_controller.dart';
import 'chat_detail_screen.dart';

class MessagesScreen extends GetView<MessagesController> {
  const MessagesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(MessagesController());
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.fetchConversations();
    });

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
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 10.h),
                      _buildSearchBar(),
                      SizedBox(height: 30.h),
                      Text(
                        StaticString.recentChats.toUpperCase(),
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.6),
                          fontSize: 12.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 15.h),
                      _buildRecentChats(),
                      SizedBox(height: 30.h),
                      _buildChatList(),
                      SizedBox(height: 20.h),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 15.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () => Get.back(),
            child: Container(
              padding: EdgeInsets.all(8.r),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.close, color: Colors.white, size: 20.sp),
            ),
          ),
          Text(
            StaticString.messages,
            style: TextStyle(
              color: Colors.white,
              fontSize: 24.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(width: 40.w),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      height: 55.h,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(30.r),
      ),
      child: TextField(
        style: TextStyle(color: Colors.white, fontSize: 16.sp),
        decoration: InputDecoration(
          hintText: StaticString.searchTradeMore,
          hintStyle: TextStyle(
            color: Colors.white.withOpacity(0.6),
            fontSize: 16.sp,
          ),
          prefixIcon: Padding(
            padding: EdgeInsets.all(15.r),
            child: SvgPicture.asset(
              'assets/icons/Search-icons.svg',
              colorFilter: const ColorFilter.mode(
                Colors.cyanAccent,
                BlendMode.srcIn,
              ),
            ),
          ),
          suffixIcon: Padding(
            padding: EdgeInsets.all(15.r),
            child: SvgPicture.asset(
              'assets/icons/Filtering-icons.svg',
              colorFilter: const ColorFilter.mode(
                Colors.cyanAccent,
                BlendMode.srcIn,
              ),
            ),
          ),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(vertical: 15.h),
        ),
      ),
    );
  }

  Widget _buildRecentChats() {
    return Obx(() {
      if (controller.recentChats.isEmpty) {
        return SizedBox(
          height: 100.h,
          child: Center(
            child: Text(
              'No recent chats',
              style: TextStyle(
                color: Colors.white.withOpacity(0.4),
                fontSize: 12.sp,
              ),
            ),
          ),
        );
      }
      return SizedBox(
        height: 100.h,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: controller.recentChats.length,
          itemBuilder: (context, index) {
            final chat = controller.recentChats[index];
            return GestureDetector(
              onTap: () {
                print('Recent Chat Tapped: index=$index, name=${chat['name']}, conversationId=${chat['_id']}, conversationType=${chat['conversationType']}, isGroup=${chat['isGroup']}');
                Get.to(
                  () => const ChatDetailScreen(),
                  arguments: {
                    'conversationId': chat['_id'] ?? '',
                    'userId': chat['userId'] ?? '',
                    'name': chat['name'] ?? '',
                    'image': chat['image'] ?? '',
                    'conversationType': chat['conversationType'] ?? 'direct',
                    'isGroup': chat['isGroup'] ?? false,
                  },
                );
              },
              child: Container(
                margin: EdgeInsets.only(right: 20.w),
                child: Column(
                  children: [
                    Stack(
                      children: [
                        Container(
                          padding: EdgeInsets.all(2.r),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.cyanAccent, width: 2),
                          ),
                          child: CircleAvatar(
                            radius: 30.r,
                            backgroundImage: NetworkImage(chat['image'] as String),
                          ),
                        ),
                        if (chat['online'] as bool)
                          Positioned(
                            right: 2.w,
                            bottom: 2.h,
                            child: Container(
                              width: 14.w,
                              height: 14.h,
                              decoration: BoxDecoration(
                                color: Colors.cyanAccent,
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: AppColors.backgroundColor,
                                  width: 2,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      chat['name'] as String,
                      style: TextStyle(color: Colors.white, fontSize: 12.sp),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      );
    });
  }

  Widget _buildChatList() {
    return Obx(() {
      if (controller.isConversationsLoading.value) {
        return Center(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 40.h),
            child: const CircularProgressIndicator(
              color: AppColors.accentColor,
            ),
          ),
        );
      }
      if (controller.chatList.isEmpty) {
        return Center(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 40.h),
            child: Text(
              'No conversations yet.',
              style: TextStyle(
                color: Colors.white.withOpacity(0.6),
                fontSize: 14.sp,
              ),
            ),
          ),
        );
      }
      return Column(
        children: controller.chatList.map((chat) {
          return GestureDetector(
            onTap: () {
              print('Chat List Item Tapped: title=${chat['title']}, conversationId=${chat['_id']}, conversationType=${chat['conversationType']}, isGroup=${chat['isGroup']}');
              Get.to(
                () => const ChatDetailScreen(),
                arguments: {
                  'conversationId': chat['_id'] ?? '',
                  'userId': chat['userId'] ?? '',
                  'name': chat['title'] ?? '',
                  'image': chat['image'] ?? '',
                  'conversationType': chat['conversationType'] ?? 'direct',
                  'isGroup': chat['isGroup'] ?? false,
                },
              );
            },
            child: Container(
              margin: EdgeInsets.only(bottom: 15.h),
              padding: EdgeInsets.all(15.r),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                borderRadius: BorderRadius.circular(25.r),
              ),
              child: Row(
                children: [
                  _buildChatAvatar(chat),
                  SizedBox(width: 15.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                chat['title'] as String,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Text(
                              chat['time'] as String,
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.4),
                                fontSize: 11.sp,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 5.h),
                        if (chat['status'] != null &&
                            (chat['status'] as String).contains('TRADE'))
                          Container(
                            margin: EdgeInsets.only(bottom: 5.h),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.sync,
                                  color: Colors.cyanAccent,
                                  size: 12.sp,
                                ),
                                SizedBox(width: 4.w),
                                Text(
                                  chat['status'] as String,
                                  style: TextStyle(
                                    color: Colors.cyanAccent,
                                    fontSize: 10.sp,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                chat['lastMsg'] as String,
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.6),
                                  fontSize: 13.sp,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            if (chat['status'] == 'Read')
                              Icon(
                                Icons.done_all,
                                color: Colors.cyanAccent,
                                size: 14.sp,
                              )
                            else if ((chat['status'] as String).contains(
                              'online',
                            ))
                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 8.w,
                                  vertical: 2.h,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(10.r),
                                ),
                                child: Text(
                                  chat['status'] as String,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 10.sp,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      );
    });
  }

  Widget _buildChatAvatar(Map<String, dynamic> chat) {
    final title = chat['title'] ?? 'User';
    final fallbackUrl = 'https://i.pravatar.cc/150?u=${title.hashCode}';
    final groupFallbackUrl = 'https://images.unsplash.com/photo-1552346154-21d32810aba3?q=80&w=200';

    if (chat['isGroup'] == true) {
      final grpImage = (chat['groupImage'] != null && (chat['groupImage'] as String).isNotEmpty)
          ? chat['groupImage'] as String
          : groupFallbackUrl;
      return Container(
        width: 60.w,
        height: 60.h,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          image: DecorationImage(
            image: NetworkImage(grpImage),
            fit: BoxFit.cover,
          ),
        ),
        child: Stack(
          children: [
            Positioned(
              right: 0,
              top: 0,
              child: Container(
                padding: EdgeInsets.all(4.r),
                decoration: const BoxDecoration(
                  color: Colors.blue,
                  shape: BoxShape.circle,
                ),
                child: Text(
                  "2",
                  style: TextStyle(color: Colors.white, fontSize: 10.sp),
                ),
              ),
            ),
          ],
        ),
      );
    } else if (chat['images'] != null) {
      final images = chat['images'] as List;
      return SizedBox(
        width: 60.w,
        height: 60.h,
        child: Stack(
          children: [
            CircleAvatar(
              radius: 20.r,
              backgroundImage: NetworkImage(images.isNotEmpty ? images[0] as String : fallbackUrl),
            ),
            Positioned(
              right: 0,
              bottom: 0,
              child: CircleAvatar(
                radius: 20.r,
                backgroundImage: NetworkImage(images.length > 1 ? images[1] as String : fallbackUrl),
              ),
            ),
          ],
        ),
      );
    } else if (chat['itemImage'] != null) {
      final img = (chat['image'] != null && (chat['image'] as String).isNotEmpty)
          ? chat['image'] as String
          : fallbackUrl;
      return SizedBox(
        width: 60.w,
        height: 60.h,
        child: Stack(
          children: [
            CircleAvatar(
              radius: 25.r,
              backgroundImage: NetworkImage(img),
            ),
            Positioned(
              right: 0,
              bottom: 0,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(5.r),
                child: Image.network(
                  chat['itemImage'] as String,
                  width: 25.w,
                  height: 25.h,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ],
        ),
      );
    } else {
      final img = (chat['image'] != null && (chat['image'] as String).isNotEmpty)
          ? chat['image'] as String
          : fallbackUrl;
      return Stack(
        children: [
          CircleAvatar(
            radius: 30.r,
            backgroundImage: NetworkImage(img),
          ),
          if (chat['status'] == 'online')
            Positioned(
              right: 2.w,
              bottom: 2.h,
              child: Container(
                width: 12.w,
                height: 12.h,
                decoration: BoxDecoration(
                  color: Colors.cyanAccent,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppColors.backgroundColor,
                    width: 2,
                  ),
                ),
              ),
            ),
        ],
      );
    }
  }
}
