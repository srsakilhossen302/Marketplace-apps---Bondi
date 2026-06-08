import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import '../Controller/notification_controller.dart';

class NotificationScreen extends GetView<NotificationController> {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(NotificationController());

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/img.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildAppBar(),
              Expanded(
                child: Obx(
                  () => ListView.builder(
                    padding: EdgeInsets.symmetric(
                      horizontal: 20.w,
                      vertical: 10.h,
                    ),
                    itemCount: controller.notifications.length,
                    itemBuilder: (context, index) {
                      final notification = controller.notifications[index];
                      return _buildNotificationCard(notification);
                    },
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
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: GestureDetector(
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
          ),
          Column(
            children: [
              Text(
                "Notifications",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 4.h),
              Container(
                width: 4.w,
                height: 4.h,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationCard(Map<String, dynamic> data) {
    return Container(
      margin: EdgeInsets.only(bottom: 15.h),
      padding: EdgeInsets.all(15.r),
      decoration: BoxDecoration(
        color: const Color(0xFF2558A8).withOpacity(0.4),
        borderRadius: BorderRadius.circular(30.r),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildAvatar(data),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: RichText(
                            text: TextSpan(
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14.sp,
                              ),
                              children: [
                                if (data['user'] != null)
                                  TextSpan(
                                    text: "${data['user']} ",
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                TextSpan(text: data['action']),
                                if (data['item'] != null)
                                  TextSpan(
                                    text: "\n${data['item']}",
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                if (data['group'] != null)
                                  TextSpan(
                                    text: " ${data['group']}",
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              data['time'],
                              style: TextStyle(
                                color: const Color(0xFF00E5FF).withOpacity(0.8),
                                fontSize: 10.sp,
                              ),
                            ),
                            if (data['is_unread'] == true)
                              Padding(
                                padding: EdgeInsets.only(top: 5.h),
                                child: Container(
                                  width: 8.w,
                                  height: 8.h,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: Colors.white,
                                      width: 1.5,
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ],
                    ),
                    if (data['message'] != null) ...[
                      SizedBox(height: 8.h),
                      Text(
                        data['message'],
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.7),
                          fontSize: 13.sp,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ],
                    if (data['status'] != null) ...[
                      SizedBox(height: 10.h),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 12.w,
                          vertical: 6.h,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFF00E5FF).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(15.r),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.check_circle,
                              color: const Color(0xFF00E5FF),
                              size: 14.sp,
                            ),
                            SizedBox(width: 5.w),
                            Text(
                              data['status'],
                              style: TextStyle(
                                color: const Color(0xFF00E5FF),
                                fontSize: 11.sp,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
          if (data['item_image'] != null) ...[
            SizedBox(height: 15.h),
            ClipRRect(
              borderRadius: BorderRadius.circular(20.r),
              child: Image.network(
                data['item_image'],
                height: 140.h,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
          ],
          if (data['likers'] != null) ...[
            SizedBox(height: 15.h),
            Row(
              children: [
                ...List.generate(
                  (data['likers'] as List).length,
                  (index) => Align(
                    widthFactor: 0.7,
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: const Color(0xFF2558A8),
                          width: 2,
                        ),
                      ),
                      child: CircleAvatar(
                        radius: 14.r,
                        backgroundImage: NetworkImage(data['likers'][index]),
                      ),
                    ),
                  ),
                ),
                if (data['extra_likers'] != null)
                  Align(
                    widthFactor: 0.7,
                    child: Container(
                      padding: EdgeInsets.all(4.r),
                      decoration: BoxDecoration(
                        color: const Color(0xFF0044CC),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: const Color(0xFF2558A8),
                          width: 2,
                        ),
                      ),
                      child: Text(
                        "+${data['extra_likers']}",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 10.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ],
          if (data['type'] == 'new_message') ...[
            SizedBox(height: 15.h),
            SizedBox(
              width: double.infinity,
              height: 45.h,
              child: OutlinedButton(
                onPressed: () {},
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: Colors.white.withOpacity(0.2)),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25.r),
                  ),
                ),
                child: Text(
                  "Reply Now",
                  style: TextStyle(
                    color: const Color(0xFF00E5FF),
                    fontSize: 14.sp,
                  ),
                ),
              ),
            ),
          ],
          if (data['type'] == 'group_invite') ...[
            SizedBox(height: 15.h),
            Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 45.h,
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF0044CC),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25.r),
                        ),
                      ),
                      child: Text(
                        "Join Group",
                        style: TextStyle(fontSize: 14.sp),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 10.w),
                Expanded(
                  child: SizedBox(
                    height: 45.h,
                    child: OutlinedButton(
                      onPressed: () {},
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: Colors.white.withOpacity(0.2)),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25.r),
                        ),
                      ),
                      child: Text(
                        "Decline",
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.6),
                          fontSize: 14.sp,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildAvatar(Map<String, dynamic> data) {
    return Stack(
      children: [
        Container(
          padding: EdgeInsets.all(2.r),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: data['is_unread'] == true
                  ? const Color(0xFF00E5FF)
                  : Colors.transparent,
              width: 1.5.w,
            ),
          ),
          child: CircleAvatar(
            radius: 25.r,
            backgroundImage: data['user_image'] != null
                ? NetworkImage(data['user_image'])
                : null,
            backgroundColor: data['icon'] == 'heart'
                ? Colors.white.withOpacity(0.1)
                : Colors.transparent,
            child: data['icon'] == 'heart'
                ? Icon(Icons.favorite, color: Colors.red, size: 24.sp)
                : null,
          ),
        ),
        if (data['type'] != 'liked')
          Positioned(
            bottom: 2.h,
            right: 2.w,
            child: Container(
              padding: EdgeInsets.all(4.r),
              decoration: const BoxDecoration(
                color: Color(0xFF0044CC),
                shape: BoxShape.circle,
              ),
              child: Icon(
                _getSmallIcon(data['type']),
                color: Colors.white,
                size: 10.sp,
              ),
            ),
          ),
      ],
    );
  }

  IconData _getSmallIcon(String type) {
    switch (type) {
      case 'new_item':
        return Icons.add;
      case 'trade_accepted':
        return Icons.swap_horiz;
      case 'new_message':
        return Icons.chat_bubble;
      case 'group_invite':
        return Icons.group;
      default:
        return Icons.notifications;
    }
  }
}
