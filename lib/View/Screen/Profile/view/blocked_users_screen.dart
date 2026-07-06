import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../Utils/AppColors/app_colors.dart';
import '../../../../Utils/StaticString/static_string.dart';
import '../../../../helper/network_img/image_helper.dart';
import '../Controller/blocked_users_controller.dart';

class BlockedUsersScreen extends GetView<BlockedUsersController> {
  const BlockedUsersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(BlockedUsersController());

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
                child: Obx(() {
                  if (controller.isLoading.value) {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: AppColors.accentColor,
                      ),
                    );
                  }

                  if (controller.blockedUsers.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.block_outlined,
                            size: 64.r,
                            color: Colors.white.withValues(alpha: 0.3),
                          ),
                          SizedBox(height: 15.h),
                          Text(
                            'No blocked users found.',
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.6),
                              fontSize: 15.sp,
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  return ListView.builder(
                    padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 15.h),
                    itemCount: controller.blockedUsers.length,
                    itemBuilder: (context, index) {
                      final user = controller.blockedUsers[index];
                      final userId = (user['_id'] ?? user['id'] ?? '').toString();
                      final fullName = (user['fullName'] ?? user['username'] ?? 'User').toString();
                      final username = '@${user['username'] ?? ''}';
                      final rawImage = (user['profileImage'] ?? user['picture'] ?? '').toString();
                      final imageUrl = rawImage.isNotEmpty ? ImageHelper.formatImageUrl(rawImage) : '';

                      return Container(
                        margin: EdgeInsets.only(bottom: 12.h),
                        padding: EdgeInsets.all(12.r),
                        decoration: BoxDecoration(
                          color: AppColors.cardColor.withValues(alpha: 0.4),
                          borderRadius: BorderRadius.circular(20.r),
                          border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
                        ),
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 24.r,
                              backgroundColor: Colors.white.withValues(alpha: 0.1),
                              backgroundImage: imageUrl.isNotEmpty ? NetworkImage(imageUrl) : null,
                              child: imageUrl.isEmpty
                                  ? Icon(Icons.person, color: Colors.white.withValues(alpha: 0.6), size: 24.sp)
                                  : null,
                            ),
                            SizedBox(width: 15.w),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    fullName,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 15.sp,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  if (user['username'] != null)
                                    Text(
                                      username,
                                      style: TextStyle(
                                        color: Colors.white.withValues(alpha: 0.5),
                                        fontSize: 12.sp,
                                      ),
                                    ),
                                ],
                              ),
                            ),
                            Obx(() {
                              final isUnblocking = controller.unblockingUsers.contains(userId);
                              return ElevatedButton(
                                onPressed: isUnblocking ? null : () => controller.unblockUser(userId),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.accentColor,
                                  foregroundColor: Colors.white,
                                  padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 8.h),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20.r),
                                  ),
                                  elevation: 0,
                                ),
                                child: isUnblocking
                                    ? SizedBox(
                                        height: 16.h,
                                        width: 16.w,
                                        child: const CircularProgressIndicator(
                                          color: Colors.white,
                                          strokeWidth: 2,
                                        ),
                                      )
                                    : Text(
                                        'Unblock',
                                        style: TextStyle(
                                          fontSize: 13.sp,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                              );
                            }),
                          ],
                        ),
                      );
                    },
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return Column(
      children: [
        Padding(
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
                      color: Colors.white.withValues(alpha: 0.2),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.close, color: Colors.white, size: 20.sp),
                  ),
                ),
              ),
              Text(
                StaticString.blockedUsers,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        Container(
          height: 1.h,
          width: double.infinity,
          color: Colors.white.withValues(alpha: 0.1),
        ),
      ],
    );
  }
}
